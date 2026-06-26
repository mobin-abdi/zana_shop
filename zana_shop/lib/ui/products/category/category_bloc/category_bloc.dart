import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zana_shop/data/model/product.dart';
import 'package:zana_shop/data/repo/product_repository.dart';

part 'category_event.dart';

part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final IProductRepository repository;

  CategoryBloc(this.repository) : super(CategoryProductsLoading()) {
    on<CategoryProductsStarted>((event, emit) async {
      emit(CategoryProductsLoading());
      try {
        final products = await repository.getAllByCategory(event.categoryId);
        emit(CategoryProductsLoaded(products));
      } catch (e) {
        emit(CategoryProductsError("failed to load products : $e"));
      }
    });
  }
}