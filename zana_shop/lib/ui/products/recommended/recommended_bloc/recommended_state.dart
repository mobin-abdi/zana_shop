part of 'recommended_bloc.dart';

sealed class RecommendedState extends Equatable {
  const RecommendedState();
}

final class RecommendedInitial extends RecommendedState {
  @override
  List<Object> get props => [];
}

class RecommendedLoading extends RecommendedState {
  @override
  List<Object?> get props => [];
}

class RecommendedLoaded extends RecommendedState {
  final List<Product> recommendedProducts;

  const RecommendedLoaded(this.recommendedProducts);

  @override
  List<Object?> get props => [recommendedProducts];
}

class RecommendedError extends RecommendedState {
  final String message;

  const RecommendedError(this.message);

  @override
  List<Object?> get props => [message];
}