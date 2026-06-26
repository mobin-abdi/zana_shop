part of 'product_detail_bloc.dart';

sealed class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();
}

class ProductDetailStarted extends ProductDetailEvent {
  final int productId;

  const ProductDetailStarted(this.productId);

  @override
  List<Object?> get props => [productId];
}

class AddToCartEvent extends ProductDetailEvent {
  final int productId;
  const AddToCartEvent({required this.productId});

  @override
  List<Object?> get props => [productId];
}