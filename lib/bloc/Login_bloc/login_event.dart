import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class SignInButtonPressed extends LoginEvent {
  String? email, password;
  SignInButtonPressed({this.email,  this.password});
}