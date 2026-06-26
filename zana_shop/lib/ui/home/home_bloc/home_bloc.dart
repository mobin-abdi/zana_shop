import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zana_shop/data/model/banner.dart';
import 'package:zana_shop/data/model/category.dart';
import 'package:zana_shop/data/model/product.dart';
import 'package:zana_shop/data/repo/banner_repository.dart';
import 'package:zana_shop/data/repo/product_repository.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IProductRepository productRepository;
  final IBannerRepository bannerRepository;

  HomeBloc(this.productRepository, this.bannerRepository)
    : super(HomeInitial()) {
    on<HomeStarted>(_onHomeStarted);
  }

  Future<void> _onHomeStarted(
    HomeStarted event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());
    try {
      final featureProducts = await productRepository.getFeaturedProducts();
      final recommendedProducts = await productRepository.getRecommendedProducts();
      final popularProducts = await productRepository.getPopularProducts();
      final banners = await bannerRepository.getAll();
      final categories = await productRepository.getCategories();
      emit(HomeLoaded(featureProducts, recommendedProducts, banners, popularProducts, categories));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
