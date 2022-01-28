import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrimony/bloc/Signup_bloc/register_event.dart';
import 'package:matrimony/bloc/Signup_bloc/register_state.dart';
import 'package:matrimony/repositories/authentication.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  Authentication? userRepository ;
  RegisterBloc({this.userRepository}) : super(RegisterInitial());

  @override
  Stream<RegisterState> mapEventToState(
      RegisterEvent event,
      ) async* {
    if (event is SignUpButtonPressed) {
      yield RegisterLoading();

      try {
        var user = await Authentication().signUp(event.email!, event.password!,event.name!);
        yield RegisterSucced(user: user);
      } catch (e) {
        yield RegisterFailed(message: "email already in use");
      }
    }
 /*   if (event is Signupbutton) {
      yield RegisterLoading();

      var user = await Authentication().getEmail(event.email!);
      print(user);
      if (user == true) {
        yield RegisterFail(message: user);
      } else {
        yield RegisterSuccess(checking: user);
      }
    }*/
  }
}
