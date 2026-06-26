part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();
}

final class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeState {
  @override
  List<Object?> get props => [];
}

class HomeLoaded extends HomeState {
  final List<Product> featureProducts;
  final List<Product> recommndedProducts;
  final List<Product> popularProducts;
  final List<Banner> banners;
  final List<Category> categories;

  const HomeLoaded(this.featureProducts, this.recommndedProducts, this.banners, this.popularProducts, this.categories);

  @override
  List<Object?> get props => [featureProducts, recommndedProducts, banners, categories];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
