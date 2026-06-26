part of 'feature_bloc.dart';

sealed class FeatureEvent extends Equatable {
  const FeatureEvent();
}

class FeatureStarted extends FeatureEvent {
  @override
  List<Object?> get props => [];
}