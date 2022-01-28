import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthenticateState extends AuthState {
  User? user;
  AuthenticateState({ this.user});
}

//
class UnAuthenticateState extends AuthState {}