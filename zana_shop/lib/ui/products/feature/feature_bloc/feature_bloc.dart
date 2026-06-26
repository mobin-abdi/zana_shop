import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zana_shop/data/model/product.dart';
import 'package:zana_shop/data/repo/product_repository.dart';

part 'feature_event.dart';
part 'feature_state.dart';

class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  final IProductRepository repository;
  FeatureBloc(this.repository) : super(FeatureInitial()) {
    on<FeatureEvent>((event, emit) async {
      emit(FeatureLoading());

      try {
        final List<Product> allProducts = await repository.getAllProducts();
        emit(FeatureLoaded(allProducts));
      } catch (e) {
        emit(FeatureError(e.toString()));
      }
    });
  }
}
