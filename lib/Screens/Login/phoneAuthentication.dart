import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import'package:flutter/material.dart';
import 'package:matrimony/repositories/authentication.dart';


class PhoneAuthentication extends StatefulWidget {
  const PhoneAuthentication({Key? key}) : super(key: key);

  @override
  _PhoneAuthenticationState createState() => _PhoneAuthenticationState();
}

class _PhoneAuthenticationState extends State<PhoneAuthentication> {
  TextEditingController phone_number = TextEditingController();
  TextEditingController _codeController = TextEditingController();

  final form_key = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Authentication authentication =Authentication();
  @override
  Widget build(BuildContext context) {
          return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/background_image.jpg"),
                fit: BoxFit.cover)),
          child: ClipRRect(
              child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(
                    margin: const EdgeInsets.all(12.3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
              children: [
                        Expanded(
                          child:
                          ListView(shrinkWrap: true, children: [
                            Form(
                              key: form_key,
                  child: Column(
                    children: [
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  build_phonenumber(),
                                  SizedBox(height: 10,),
                                  submitButton(),
                                ],
                        ),
                      ),
                            const SizedBox(
                              height: 20,
                            ),

                          ]),
                        ),
                    ],
                  ),
                  )))));
  }

  build_phonenumber() {
    return TextFormField(
      decoration: const InputDecoration(
          labelStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(color: Colors.brown),
                ),
      controller: phone_number,
      cursorColor: Colors.orange,
      style: const TextStyle(color: Colors.deepPurpleAccent),
      validator: (phoneNumber) {
        if (phoneNumber!.isEmpty) {
          return 'Please enter phone number';
        }
        return null;
      },
    );
  }

  submitButton() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.6,
      margin: const EdgeInsets.only(top: 5.6),
      child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(0xfff2d493)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
          ),
          onPressed: () {
            var number = phone_number.text;
            form_key.currentState!.validate();
            authentication.login_user("+91 $number",context,_codeController);
          },
          child: const Text(
            "Submit",
            style: TextStyle(fontSize: 16,color: Colors.black),
          )),
    );
  }

}