import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class SignUpButtonPressed extends RegisterEvent {
  String? email;
  String?password;
  String?name;
  SignUpButtonPressed({ this.email,  this.password,this.name,});
}

class Signupbutton extends RegisterEvent{
  String?email;
  Signupbutton({this.email});
}