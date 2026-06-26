part of 'feature_bloc.dart';

sealed class FeatureState extends Equatable {
  const FeatureState();
}

final class FeatureInitial extends FeatureState {
  @override
  List<Object> get props => [];
}

class FeatureLoading extends FeatureState {
  @override
  List<Object?> get props => [];
}

class FeatureLoaded extends FeatureState {
  final List<Product> allProducts;

  const FeatureLoaded(this.allProducts);

  @override
  List<Object?> get props => [allProducts];
}

class FeatureError extends FeatureState {
  final String message;

  const FeatureError(this.message);

  @override
  List<Object?> get props => [message];
}