part of 'category_bloc.dart';

sealed class CategoryState extends Equatable {
  const CategoryState();
}

final class CategoryInitial extends CategoryState {
  @override
  List<Object> get props => [];
}

class CategoryProductsLoading extends CategoryState {
  @override
  List<Object?> get props => [];
}

class CategoryProductsLoaded extends CategoryState {
  final List<Product> products;

  const CategoryProductsLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class CategoryProductsError extends CategoryState {
  final String message;

  const CategoryProductsError(this.message);

  @override
  List<Object?> get props => [message];
}
