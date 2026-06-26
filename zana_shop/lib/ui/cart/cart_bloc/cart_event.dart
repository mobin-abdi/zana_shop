part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();
}

class CartStarted extends CartEvent {
  @override
  List<Object?> get props => [];
}

class CartItemIncreased extends CartEvent {
  final int productId;
  final String action;
  const CartItemIncreased(this.productId, this.action);

  @override
  List<Object> get props => [productId, action];
}

class CartItemDecreased extends CartEvent {
  final String action;
  final int productId;

  const CartItemDecreased(this.productId, this.action);

  @override
  List<Object?> get props => [action, productId];
}