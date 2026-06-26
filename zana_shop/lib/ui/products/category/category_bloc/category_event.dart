part of 'category_bloc.dart';

sealed class CategoryEvent extends Equatable {
  const CategoryEvent();
}

class CategoryProductsStarted extends CategoryEvent {
  final int categoryId;
  const CategoryProductsStarted(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}