import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zana_shop/data/model/product.dart';
import 'package:zana_shop/data/repo/product_repository.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final IProductRepository repository;

  SearchBloc(this.repository) : super(SearchInitial()) {
    on<SearchStarted>((event, emit) async {
      emit(SearchLoading());
      try {
        final results = await repository.searchProducts(event.query);
        emit(SearchLoaded(result: results));
      } catch (e) {
        emit(SearchError(e.toString()));
      }
    });

    on<LoadPopularProducts>((event, emit) async {
      emit(SearchLoading());
      try {
        final popular = await repository.getPopularProducts();
        emit(SearchLoaded(result: popular));
      } catch (e) {
        emit(SearchError("خطا در بارگذاری محبوب‌ها"));
      }
    });
  }
}