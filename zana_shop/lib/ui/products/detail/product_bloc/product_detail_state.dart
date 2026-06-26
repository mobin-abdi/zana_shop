part of 'product_detail_bloc.dart';

sealed class ProductDetailState extends Equatable {
  const ProductDetailState();
}

final class ProductDetailInitial extends ProductDetailState {
  @override
  List<Object> get props => [];
}

class ProductDetailLoading extends ProductDetailState {
  @override
  List<Object?> get props => [];
}

class ProductDetailLoded extends ProductDetailState {
  final Product product;
  final List<Product> popular;
  final Cart cart;

  const ProductDetailLoded({required this.product, required this.popular, required this.cart});

  @override
  List<Object?> get props => [product, popular, cart];
}

class ProductDetailError extends ProductDetailState {
  final String message;

  const ProductDetailError(this.message);

  @override
  List<Object?> get props => [message];
}