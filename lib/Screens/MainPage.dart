import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class MainPage extends StatefulWidget {
  User? current_user;
   MainPage({Key? key,this.current_user }) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState(current_user:this.current_user);
}

class _MainPageState extends State<MainPage> {
  User?current_user;
  _MainPageState({this.current_user});
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
