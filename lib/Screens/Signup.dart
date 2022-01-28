import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matrimony/bloc/Signup_bloc/register_bloc.dart';
import 'Home.dart';
import 'package:matrimony/bloc/Signup_bloc/register_event.dart';
import 'package:matrimony/bloc/Signup_bloc/register_state.dart';

import 'Login/login.dart';

class Signupform extends StatefulWidget {
  const Signupform({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signupform> {
  final form = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
 PhoneAuthCredential? phone;
  String error = "";
  String name = "";
  bool securedValue = true;
  bool isChecked = false;
  Icon fab = const Icon(
    Icons.visibility_off,
    color: Colors.grey,
  );
  bool login_success = false;

  RegisterBloc registerBloc = RegisterBloc();
  @override
  Widget build(BuildContext context) {
    registerBloc = BlocProvider.of<RegisterBloc>(context);
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
            body: Container(
              margin: const EdgeInsets.all(2.3),
              child: ListView(shrinkWrap: true, children: [
                BlocListener<RegisterBloc, RegisterState>(
                    listener: (context, state) {
                  print(state);
                  if (state is RegisterSucced) {
                    print(state.user);
                    //print(nameController.text);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Login(

                            )));
                  }
                }, child: BlocBuilder<RegisterBloc, RegisterState>(
                  builder: (context, state) {
                    if (state is RegisterFailed) {
                      error = state.message!;
                      print(error);
                    } else if (state is RegisterSuccess) {
                      return Container();
                    }
                    return Container();
                  },
                )),
                badge(),
                Card(
                  elevation: 4.3,
                  child: Container(
                    margin: const EdgeInsets.all(11.3),
                    child: Form(
                      key: form,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          nameFiled(),
                          const SizedBox(
                            height: 30,
                          ),
                          emailField(),
                          const SizedBox(
                            height: 30,
                          ),
                          passwordField(),
                          const SizedBox(
                            height: 20,
                          ),
                          confirmPasswordField(),
                          submitButton(),
                        ],
                      ),
                    ),
                  ),
                ),
                backToLogin()
              ]),
            )));
  }

  nameFiled() {
    return TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
            hintText: "Your name",
            labelText: "Name",
            labelStyle: const TextStyle(color: Colors.brown),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.5),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black38, width: 1.0),
            ),
            hintStyle: const TextStyle(color: Colors.brown)),
        controller: nameController,
        cursorColor: Colors.orange,
        style: const TextStyle(color: Colors.deepPurpleAccent),
        validator: (name) {
          if (name!.isEmpty) {
            return 'Please enter name';
          }
          return null;
        });
  }

  emailField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
          hintText: "You@example.com",
          labelText: "Email",
          labelStyle: const TextStyle(color: Colors.brown),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.5),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black38, width: 1.0),
          ),
          hintStyle: const TextStyle(color: Colors.brown)),
      controller: emailController,
      cursorColor: Colors.orange,
      style: const TextStyle(color: Colors.deepPurpleAccent),
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

  phonenumberField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: "Contact number",
          labelText: "Phone number",
          labelStyle: const TextStyle(color: Colors.brown),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.5),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black38, width: 1.0),
          ),
          hintStyle: const TextStyle(color: Colors.brown)),
      controller: phoneController,
      cursorColor: Colors.orange,
      style: const TextStyle(color: Colors.deepPurpleAccent),
      validator: (phone) {
        bool validate = validatePhone(phone!);
        if (phone.isEmpty) {
          return 'Please enter phone';
        } else if (!validate) {
          return "Enter a valid phone number";
        }  else if (phone.length != 10) {
          return "Enter 10 numbers";
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
                labelStyle: const TextStyle(color: Colors.brown),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.5),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38, width: 1.0),
                ),
                hintStyle: const TextStyle(color: Colors.brown)),
            controller: passwordController,
            cursorColor: Colors.blue,
            style: const TextStyle(color: Colors.deepPurpleAccent),
            validator: (password) {
              login_success = validate(passwordController.text);
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
                    if (securedValue && passwordController.text.isNotEmpty) {
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

  confirmPasswordField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.9),
      child: SizedBox(
          child: Stack(
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            obscureText: true,
            decoration: InputDecoration(
                hintText: "Enter minimum 8 characters",
                labelText: "Confirm Password",
                labelStyle: const TextStyle(color: Colors.brown),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.5),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38, width: 1.0),
                ),
                hintStyle: const TextStyle(color: Colors.brown)),
            controller: confirmPassword,
            cursorColor: Colors.blue,
            style: const TextStyle(color: Colors.deepPurpleAccent),
            validator: (password) {
              login_success = validate(passwordController.text);
              if (password!.isEmpty) {
                return 'Please enter Password';
              } else if (password.length < 8) {
                return "Please enter minimum of 8 characters";
              } else if (passwordController.text != confirmPassword.text) {
                return "Passwords does not match";
              } else if (!login_success) {
                return "Atleast one alphabet and one number of 8 characters";
              }

              return null;
            },
          ),
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
            var validate = form.currentState!.validate();
            if (validate) {
              setState(() {
                registerBloc.add(SignUpButtonPressed(
                    email: emailController.text,
                    password: passwordController.text,
                    name: nameController.text,
                    ));
              });
            }
          },
          child: const Text(
            "Sign up",
            style: TextStyle(fontSize: 18, color: Colors.white),
          )),
    );
  }

  backToLogin() {
    return Container(
      margin: const EdgeInsets.all(12.6),
      child: ElevatedButton(
          style: ButtonStyle(
              elevation: MaterialStateProperty.all<double>(1.3),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.amber),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ))),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
              (Route<dynamic> route) => false,
            );
          },
          child: const Text(
            "Login",
            style: TextStyle(fontSize: 18, color: Colors.white),
          )),
    );
  }

  badge() {
    return Container(
        margin: const EdgeInsets.all(12.3),
        height: 40,
        decoration: BoxDecoration(
            color: Colors.brown, borderRadius: BorderRadius.circular(15.3)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Sign up",
              style: TextStyle(color: Colors.white, fontSize: 19),
            )
          ],
        ));
  }

  validate(String password) {
    bool passValid = RegExp("^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.{8,})")
        .hasMatch(password);

    if (passValid) {
      return true;
    } else {
      return false;
    }
  }

  validatePhone(String phone) {
    bool passValid = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(phone);

    if (passValid) {
      return true;
    } else {
      return false;
    }
  }
}
