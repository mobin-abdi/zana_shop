import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zana_shop/data/model/cart.dart';
import 'package:zana_shop/data/model/product.dart';
import 'package:zana_shop/data/repo/cart_repository.dart';
import 'package:zana_shop/data/repo/product_repository.dart';

part 'product_detail_event.dart';

part 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final IProductRepository productrepository;
  final ICartRepository cartRepository;

  ProductDetailBloc(this.productrepository, this.cartRepository)
    : super(ProductDetailInitial()) {
    on<ProductDetailStarted>((event, emit) async {
      emit(ProductDetailLoading());
      try {
        final product = await productrepository.getProductById(event.productId);
        final popular = await productrepository.getPopularProducts();
        final cart = await cartRepository
            .getCart(); // فعلاً سبد خریدِ فعلی رو بگیر
        emit(
          ProductDetailLoded(product: product, popular: popular, cart: cart),
        );
      } catch (e) {
        emit(ProductDetailError(e.toString()));
      }
    });

    on<AddToCartEvent>((event, emit) async {
      final currentState = state;
      if (currentState is ProductDetailLoded) {
        try {
          final newCart = await cartRepository.addToCart(event.productId);

          emit(
            ProductDetailLoded(
              product: currentState.product,
              popular: currentState.popular,
              cart: newCart,
            ),
          );
        } catch (e) {
          emit(ProductDetailError("failed to add to cart"));
        }
      }
    });
  }
}
