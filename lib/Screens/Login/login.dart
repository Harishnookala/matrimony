import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrimony/Custom_widgets/wrappers.dart';
import 'package:matrimony/Screens/Login/phoneAuthentication.dart';
import 'package:matrimony/bloc/Login_bloc/login_state.dart';
import 'package:matrimony/repositories/authentication.dart';
import 'package:matrimony/bloc/Login_bloc/login_bloc.dart';
import 'package:matrimony/bloc/Login_bloc/login_event.dart';
import '../Forgotpassword.dart';
import '../Home.dart';
import 'package:dart_style/dart_style.dart';

import '../Signup.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  SigninState createState() => SigninState();
}

class SigninState extends State<Login> {
  final form_key = GlobalKey<FormState>();
  TextEditingController email_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();
  Login_bloc loginBloc = Login_bloc();
  bool securedValue = true;
  bool isChecked = false;
  Icon fab = const Icon(
    Icons.visibility_off,
    color: Colors.grey,
  );
  var login_error;
  bool login_success = false;
  @override
  Widget build(BuildContext context) {
    loginBloc = BlocProvider.of<Login_bloc>(context);

    return MaterialApp(
        home: Scaffold(
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(45),
                child: AppBar(
                  centerTitle: true,
                  backgroundColor: Colors.deepOrange,
                  title: const Text(
                    "Matrimony",
                    style: TextStyle(color: Colors.white),
                  ),
                )),
            body: Center(
                child: Container(
                    constraints: const BoxConstraints.expand(),
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/background_image.jpg"),
                            fit: BoxFit.cover)),
                    child: ClipRRect(
                        child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                            child: Container(
                              margin: const EdgeInsets.all(12.3),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child:
                                        ListView(shrinkWrap: true, children: [
                                      BlocListener<Login_bloc, LoginState>(
                                        listener: (context, state) {
                                          if (state is LoginSucced) {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) => Home(
                                                        email: email_controller
                                                            .text)));
                                          }
                                        },
                                        child:
                                            BlocBuilder<Login_bloc, LoginState>(
                                          builder: (context, state) {
                                            if (state is LoginFailed) {
                                              login_error = state.message;
                                            } else if (state is LoginSucced) {
                                              return Container();
                                            }
                                            return Container();
                                          },
                                        ),
                                      ),
                                      Form(
                                        key: form_key,
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            emailField(),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            passwordField(),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            submitButton(),

                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      signinwithgoogle(),
                                      siginwithphone(),
                                      Signup()
                                    ]),
                                  ),
                                ],
                              ),
                            )))))));
  }

  emailField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
          hintText: "You@example.com",
          labelText: "Email",
          labelStyle: const TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.5),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.5),
          ),
          hintStyle: const TextStyle(color: Colors.brown)),
      controller: email_controller,
      cursorColor: Colors.orange,
      style: const TextStyle(
          color: Colors.deepOrange, fontSize: 17, fontWeight: FontWeight.bold),
      validator: (email) {
        bool validateEmail = EmailValidator.validate(email!);
        if (email.isEmpty) {
          return 'Please enter email';
        } else if (!validateEmail) {
          return "Enter valid email address";
        }
        return null;
      },
    );
  }

  passwordField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.9),
      child: SizedBox(
          child: Stack(
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            obscureText: securedValue,
            decoration: InputDecoration(
                hintText: "Enter minimum 8 characters",
                labelText: "Password",
                labelStyle: const TextStyle(color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.5),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.5),
                ),
                hintStyle: const TextStyle(color: Colors.brown)),
            controller: password_controller,
            cursorColor: Colors.blue,
            style: const TextStyle(color: Colors.deepPurpleAccent),
            validator: (password) {
              login_success = validate(password_controller.text);
              print(login_success);
              if (password!.isEmpty) {
                return 'Please enter Password';
              } else if (password.length < 8) {
                return "Please enter minimum of 8 characters";
              } else if (!login_success) {
                return "Atleast one alphabet and one number of 8 characters";
              }

              return null;
            },
          ),
          Positioned(
              right: 15,
              top: 3,
              child: TextButton(
                child: fab,
                onPressed: () {
                  setState(() {
                    if (securedValue && password_controller.text.isNotEmpty) {
                      securedValue = false;
                      fab = const Icon(
                        Icons.visibility,
                        color: Colors.grey,
                      );
                    } else {
                      fab = const Icon(
                        Icons.visibility_off,
                        color: Colors.grey,
                      );
                      securedValue = true;
                    }
                  });
                },
              )),
        ],
      )),
    );
  }

  submitButton() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.6,
      margin: const EdgeInsets.only(top: 5.6),
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.green.shade500),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ))),
          onPressed: () {
            var validation = form_key.currentState!.validate();
            if (validation) {
              print("Gger");
              setState(() {
                loginBloc.add(SignInButtonPressed(
                    email: email_controller.text,
                    password: password_controller.text));
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                  (Route<dynamic> route) => false,
                );
              });
            }
          },
          child: const Text(
            "Submit",
            style: TextStyle(fontSize: 16, color: Colors.white),
          )),
    );
  }

  signinwithgoogle() {
    return Container(
      margin: const EdgeInsets.all(15.3),
      decoration: BoxDecoration(
          border: Border.all(width: 1.3, color: Colors.white),
          borderRadius: BorderRadius.circular(25.3)),
      child: TextButton(
        onPressed: () async {
          try {
            Future<User?> future =
                Future(() => Authentication.signInWithGoogle());
            var user = await future;
            if (user!.email != null) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Home()),
                (Route<dynamic> route) => false,
              );
            }
          } catch (e) {
            if (e is FirebaseAuthException) {
              wrappermethods().showMessage(e.message!, context);
            }
            const CircularProgressIndicator();
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Image(
              image: AssetImage("assets/google_image.jpg"),
              height: 35.0,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  siginwithphone() {
    return Container(
      margin: const EdgeInsets.all(15.3),
      decoration: BoxDecoration(
          border: Border.all(width: 1.3, color: Colors.white),
          borderRadius: BorderRadius.circular(25.3)),
      child: TextButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const PhoneAuthentication()),
            (Route<dynamic> route) => false,
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Icon(
              Icons.phone,
              color: Colors.green,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Phone',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Signup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Do n't have an account ? ",
          style: TextStyle(
              color: Colors.white, fontFamily: "Poppins", fontSize: 15),
        ),
        TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Signupform()),
                (Route<dynamic> route) => false,
              );
            },
            child: const Text("Sign up",
                style: TextStyle(
                    color: Color(0xfff2d493),
                    fontSize: 15,
                    letterSpacing: 1.3,
                    fontFamily: "Poppins"))),
      ],
    );
  }

  validate(String password) {
    bool passvalid = RegExp("^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.{8,})")
        .hasMatch(password);

    if (passvalid) {
      return true;
    } else {
      return false;
    }
  }

  ForgotPasswordButton() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
        child: Text(
          "Forgot password",
          textAlign: TextAlign.end,
          style: TextStyle(
              letterSpacing: 0.6,
              fontSize: 14,
              color: Colors.lightGreenAccent,
              fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ForgotPassword()));
        },
      ),
    );
  }
}
