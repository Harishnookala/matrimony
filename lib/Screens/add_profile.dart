import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class AddProfile extends StatefulWidget {
  User? current_user;
   AddProfile({Key? key,this.current_user }) : super(key: key);

  @override
  _AddProfileState createState() => _AddProfileState(current_user:current_user);
}

class _AddProfileState extends State<AddProfile> {

   User?current_user;
   _AddProfileState({this.current_user});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
