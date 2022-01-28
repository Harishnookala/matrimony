import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSucced extends RegisterState {
  User ?user;
  RegisterSucced({this.user});
}

class RegisterFailed extends RegisterState {
  String? message;
  RegisterFailed({required this.message});
}

class RegisterSuccess extends RegisterState{
  bool ? checking;
  RegisterSuccess({this.checking});
}
class RegisterFail extends RegisterState{
  bool?message;
  RegisterFail({this.message});
}