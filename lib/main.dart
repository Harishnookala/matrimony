import 'package:firebase_auth/firebase_auth.dart';
import 'package:matrimony/bloc/Signup_bloc/register_bloc.dart';
import 'package:matrimony/repositories/authentication.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrimony/repositories/authentication.dart';
import 'Screens/Home.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/Login/login.dart';
import 'auth_bloc/auth_bloc.dart';
import 'auth_bloc/auth_state.dart';
import 'bloc/Login_bloc/login_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   SharedPreferences preferences = await SharedPreferences.getInstance();

  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Authentication? authentication = Authentication();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(authentication: authentication),
          ),
          BlocProvider(
            create: (context) => Login_bloc(authentication: authentication),
          ),
          BlocProvider(create: (context)=>RegisterBloc(userRepository: authentication))
        ],
        child: MaterialApp(
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              print(state);
              if (state is UnAuthenticateState) {
                return const Login();
              } else if (state is AuthenticateState) {
                return Home();
              }

              return const Login();
            },
          ),
        ));
  }
}

