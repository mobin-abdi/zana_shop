import 'package:zana_shop/data/model/product.dart';

class CartItem {
  final int id;
  final Product product;
  int quantity;

  CartItem.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      product = Product.fromJson(json['product']),
      quantity = json['quantity'];
}

class Cart {
  final int id;
  final List<CartItem> items;

  Cart.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      items = (json['items'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList();
}
