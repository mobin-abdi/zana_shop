part of 'popular_bloc.dart';

sealed class PopularEvent extends Equatable {
  const PopularEvent();
}

class PopularStarted extends PopularEvent {
  @override
  List<Object?> get props => [];
}
