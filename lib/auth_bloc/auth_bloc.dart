import 'dart:async';

import 'package:matrimony/repositories/authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'auth_event.dart';
import 'auth_state.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  Authentication? authentication = Authentication();
  AuthBloc({this.authentication}) : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(
      AuthEvent event,
      ) async* {
    if (event is AppLoaded) {
      print(authentication);
      try {
        var isSignedIn = await Authentication().isSignedIn();

        if (isSignedIn) {
          var user = await Authentication().getCurrentUser();

          yield AuthenticateState(user: user);
        } else {

          yield UnAuthenticateState();
        }
      } catch (e) {
        yield UnAuthenticateState();
      }
    }
  }
}