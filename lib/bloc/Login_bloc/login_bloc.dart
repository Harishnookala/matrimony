import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:matrimony/repositories/authentication.dart';
import 'package:matrimony/bloc/Login_bloc/login_event.dart';
import 'package:matrimony/bloc/Login_bloc/login_state.dart';
import 'dart:async';
class Login_bloc  extends Bloc<LoginEvent,LoginState>{
  Authentication? authentication = new Authentication();
  Login_bloc({ this.authentication, }) : super(LoginInitial());
  @override
  Stream<LoginState> mapEventToState(
      LoginEvent event,
      ) async* {
    if (event is SignInButtonPressed) {

      yield LoginLoading();

      try {
        print(event.email);
        var user = await authentication!.signIn(event.email!, event.password!);

        yield LoginSucced(user: user);
      } catch (e) {

        yield LoginFailed(message: e.toString());
      }
    }
  }
}