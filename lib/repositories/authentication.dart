

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Screens/Home.dart';

class Authentication{

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String errorMessage="";

  String ?message ="";
  static Future<User?> signInWithGoogle() async {
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
        user = userCredential.user;
        print(user);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {

        }
        else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        // handle the error here
      }
    }
    else{
      print("Harish890");
    }

    return user;
  }


  Future<User?> signIn(String email, String password) async {
    var auth=FirebaseAuth.instance;
    UserCredential? user;
    try {
      user = await auth
          .signInWithEmailAndPassword(email: email, password: password);
      print(user.user);
      return user.user;
    } on FirebaseAuthException catch (error) {

      print(error);
      switch (error.code) {
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;

        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
      }
    }
    if (errorMessage != null) {
      return Future.error(errorMessage);
    }

    return user!.user;
  }

  // Sign Out



  Future<bool> isSignedIn() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    return currentUser != null;
  }

  //get current user

  Future<User?> getCurrentUser() async {
    return  FirebaseAuth.instance.currentUser;
  }




  Future<bool?> login_user(String phone, BuildContext context,
      TextEditingController _codeController) async{
    print(phone);
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (AuthCredential credential) async{
        Navigator.of(context).pop();
        print(credential);
        var result = await _auth.signInWithCredential(credential);

        User? user = result.user;

        if(user != null){

          Navigator.push(context, MaterialPageRoute(
              builder: (context) => Home(user: user,)
          ));
        }else{
          print("Error");
        }

        //This callback would gets called when verification is done automatically
      },
      verificationFailed: (exception){
        print(exception);
      },
      codeSent: (String verificationId, [ int? forceResendingToken]){
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text("Give the code?"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _codeController,
                    ),
                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Confirm"),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: () async {
                      final code = _codeController.text.trim();
                      AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code);
                      var result = await _auth.signInWithCredential(credential);
                      //print(result);
                      User? user = result.user;
                      print(user);
                      if(user != null){
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => Home(user: user,)
                        ));
                      } else {
                        print("Error");
                      }
                    },
                  )
                ],
              );
            }
        );
      }, codeAutoRetrievalTimeout: (String verificationId) {
      print(verificationId);
    },
    );
  }

  Future<User?>signUp(String email, String password,String name) async {
    print(name);
    var instance =  FirebaseAuth.instance;
    UserCredential? auth;
    try {
      auth = await instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await instance.currentUser!.updateDisplayName(name);
      auth.user!.reload();
      return auth.user;
    }on FirebaseAuthException catch (error) {
      print(error.code);
      switch(error.code){
        case "email-already-in-use":
          message = "Your email already in use";
          break;
      }
    }
    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
    return auth!.user;
  }

  Future<void> signOutFromGoogle() async{
    await _googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

 Future<bool?>getEmail(email) async {
    print(email);
    final list =
    await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

    if (list.isNotEmpty) {
      return true;
    } else if (list.isEmpty) {
      return false;
    }
  }

 Future<UserCredential?>update_password(String text,String password) async {
    var auth= FirebaseAuth.instance;
     var user = await auth.currentUser?.updatePassword(password);
 }
}



