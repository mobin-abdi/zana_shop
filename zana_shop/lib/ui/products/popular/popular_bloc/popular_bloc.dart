import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zana_shop/data/model/product.dart';
import 'package:zana_shop/data/repo/product_repository.dart';

part 'popular_event.dart';
part 'popular_state.dart';

class PopularBloc extends Bloc<PopularEvent, PopularState> {
  final IProductRepository repository;
  
  PopularBloc(this.repository) : super(PopularInitial()) {
    on<PopularEvent>((event, emit) async {
      emit(PopularLoading());
      
      try {
        final popularProducts = await repository.getPopularProducts();
        emit(PopularLoaded(popularProducts));
      } catch (e) {
        emit(PopularError(e.toString()));
      }
    });
  }
}
