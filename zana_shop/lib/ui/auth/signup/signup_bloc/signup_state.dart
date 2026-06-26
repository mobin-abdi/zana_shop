part of 'signup_bloc.dart';

sealed class SignupState extends Equatable {
  const SignupState();
}

final class SignupInitial extends SignupState {
  @override
  List<Object> get props => [];
}

class SignupLoading extends SignupState {
  @override
  List<Object?> get props => [];
}

class SignupLoaded extends SignupState {
  final String token;

  const SignupLoaded({required this.token});

  @override
  List<Object?> get props => [token];
}

class SignupError extends SignupState {
  final String message;

  const SignupError({required this.message});

  @override
  List<Object?> get props => [message];
}