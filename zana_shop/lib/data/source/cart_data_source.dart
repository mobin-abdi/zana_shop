import 'package:dio/dio.dart';
import 'package:zana_shop/data/model/cart.dart';

abstract class ICartDataSource {
  Future<Cart> getCart();

  Future<Cart> addToCart(int productId);

  Future<Cart> changeQuantity(int productId, String action);
}

class CartRemoteDataSource implements ICartDataSource {
  final Dio dio;

  CartRemoteDataSource({required this.dio});

  @override
  Future<Cart> addToCart(int productId) async {
    try {
      final response = await dio.post("cart/", data: {"product_id": productId});

      if (response.statusCode == 200) {
        return Cart.fromJson(response.data);
      } else {
        throw Exception("server error ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("failed to add product to cart ${e.toString()}");
    }
  }

  @override
  Future<Cart> getCart() async {
    try {
      final response = await dio.get("cart");

      if (response.statusCode == 200) {
        return Cart.fromJson(response.data);
      } else {
        throw Exception("server error ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("failed to load cart ${e.toString()}");
    }
  }

  @override
  Future<Cart> changeQuantity(int productId, String action) async {
    final response = await dio.post(
      "cart/change-quantity/",
      data: {"product_id": productId, "action": action},
    );
    return Cart.fromJson(response.data);
  }
}
