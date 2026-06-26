import 'package:zana_shop/data/model/cart.dart';
import 'package:zana_shop/data/source/cart_data_source.dart';

abstract class ICartRepository {
  Future<Cart> getCart();

  Future<Cart> addToCart(int productId);

  Future<Cart> changeQuantity(int productId, String action);
}

class CartRepository implements ICartRepository {
  final ICartDataSource dataSource;

  CartRepository({required this.dataSource});

  @override
  Future<Cart> getCart() => dataSource.getCart();

  @override
  Future<Cart> addToCart(int productId) => dataSource.addToCart(productId);

  @override
  Future<Cart> changeQuantity(int productId, String action) => dataSource.changeQuantity(productId, action);
}
