import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zana_shop/data/model/cart.dart';
import 'package:zana_shop/data/repo/cart_repository.dart';

part 'cart_event.dart';

part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final ICartRepository repository;

  CartBloc(this.repository) : super(CartInitial()) {
    on<CartEvent>((event, emit) async {
      emit(CartLoading());

      try {
        final cart = await repository.getCart();
        emit(CartLoaded(cart: cart));
      } catch (e) {
        emit(CartError(message: e.toString()));
      }
    });
    on<CartItemIncreased>((event, emit) async {
      try {
        await repository.changeQuantity(event.productId, event.action);
        final newCart = await repository.getCart();
        emit(CartLoaded(cart: newCart));
      } catch (e) {
        emit(CartError(message: "failed to add to cart"));
      }
    });
    on<CartItemDecreased>((event, emit) async {
      try {
        await repository.changeQuantity(event.productId, event.action);
        final newCart = await repository.getCart();
        emit(CartLoaded(cart: newCart));
      } catch (e) {
        emit(CartError(message: "failed to add to cart"));
      }
    });
  }
}
