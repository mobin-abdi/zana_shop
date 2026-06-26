part of 'recommended_bloc.dart';

sealed class RecommendedEvent extends Equatable {
  const RecommendedEvent();
}

class RecommendedSrarted extends RecommendedEvent {
  @override
  List<Object?> get props => [];
}