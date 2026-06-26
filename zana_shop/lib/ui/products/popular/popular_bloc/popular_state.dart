part of 'popular_bloc.dart';

sealed class PopularState extends Equatable {
  const PopularState();
}

final class PopularInitial extends PopularState {
  @override
  List<Object> get props => [];
}

class PopularLoading extends PopularState {
  @override
  List<Object?> get props => [];
}

class PopularLoaded extends PopularState {
  final List<Product> popularProducts;

  const PopularLoaded(this.popularProducts);

  @override
  List<Object?> get props => [popularProducts];

}

class PopularError extends PopularState {
  final String message;

  const PopularError(this.message);

  @override
  List<Object?> get props => [message];
}