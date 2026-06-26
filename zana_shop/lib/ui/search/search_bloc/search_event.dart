part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();
}

class SearchStarted extends SearchEvent {
  final String query;

  const SearchStarted(this.query);

  @override
  List<Object?> get props => [query];
}

class LoadPopularProducts extends SearchEvent {
  @override
  List<Object?> get props => [];
}