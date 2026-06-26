import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zana_shop/data/repo/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final IAuthRepository repository;
  LoginBloc(this.repository) : super(LoginInitial()) {
    on<LoginStarted>((event, emit) async {
      emit(LoginLoading());
      
      try {
        final String token = await repository.login(event.username, event.password);
        emit(LoginLoaded(token: token));
      } catch (e) {
        emit(LoginError(message: e.toString()));
      }
    });
  }
}
