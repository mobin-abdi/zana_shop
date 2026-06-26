import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:zana_shop/data/repo/auth_repository.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final IAuthRepository repository;
  
  SignupBloc(this.repository) : super(SignupInitial()) {
    on<SignupStarted>((event, emit) async {
      emit(SignupLoading());
      
      try {
        final String token = await repository.register(event.username, event.password);
        emit(SignupLoaded(token: token));
      } catch (e) {
        emit(SignupError(message: e.toString()));
      }
    });
  }
}
