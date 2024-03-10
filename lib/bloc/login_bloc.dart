import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homefe/api/api_repository.dart';
import 'package:homefe/podo/login/login_body.dart';
import 'package:homefe/podo/token/token.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure(this.error);
}

class LoginSuccess extends LoginState {
  final Token token;

  LoginSuccess(this.token);
}

class LoginEvent extends LoginState {
  final LoginBody loginBody;

  LoginEvent(this.loginBody);
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(LoginLoading());

      LoginBody loginBody = event.loginBody;

      if (loginBody.username.isEmpty) {
        emit(LoginInitial());
        return;
      }

      Token token = await ApiRepository().postLogin(loginBody);
      if (token.error.isNotEmpty) {
        emit(LoginFailure(token.error));
        return;
      }

      emit(LoginSuccess(token));
    });
  }
}
