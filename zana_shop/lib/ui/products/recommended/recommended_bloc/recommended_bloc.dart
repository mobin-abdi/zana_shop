import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zana_shop/data/model/product.dart';
import 'package:zana_shop/data/repo/product_repository.dart';

part 'recommended_event.dart';
part 'recommended_state.dart';

class RecommendedBloc extends Bloc<RecommendedEvent, RecommendedState> {
  final IProductRepository repository;

  RecommendedBloc(this.repository) : super(RecommendedInitial()) {
    on<RecommendedEvent>((event, emit) async {
      emit(RecommendedLoading());

      try {
        final List<Product> recommendedProducts = await repository.getRecommendedProducts();
        emit(RecommendedLoaded(recommendedProducts));
      } catch (e) {
        emit(RecommendedError(e.toString()));
      }
    });
  }
}
