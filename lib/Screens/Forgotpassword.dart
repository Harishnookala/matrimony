import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:matrimony/repositories/authentication.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotpasswordState createState() {
    // TODO: implement createState
     return _ForgotpasswordState();
  }


}

class _ForgotpasswordState extends State<ForgotPassword> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool securedValue = true;
  bool isChecked = false;
  Icon fab = const Icon(
    Icons.visibility_off,
    color: Colors.grey,
  );
  bool login_success = false;
  final form_key = GlobalKey<FormState>();
   Authentication authentication = Authentication();
  @override
  Widget build(BuildContext context) {
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
           margin: EdgeInsets.all(12.6),
           child: Form(
             key: form_key,
             child: Column(
               children: [
                 emailField(),
                 SizedBox(height: 20,),
                 passwordField(),
                 const SizedBox(
                   height: 10,
                 ),
                 confirmPasswordField(),
                 confirmButton(),
               ],
             ),
           ),
         ),
       ),
     );
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

  passwordField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.9),
      child: SizedBox(
          child: Stack(
            children: [
              TextFormField(
               // autovalidateMode: AutovalidateMode.onUserInteraction,
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
               // autovalidateMode: AutovalidateMode.onUserInteraction,
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
  confirmButton() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.6,
      margin: const EdgeInsets.only(top: 5.6),
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
              MaterialStateProperty.all<Color>(Colors.lightGreenAccent),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
          onPressed: ()async {
            Future<bool?> future =
            Future(() => authentication.getEmail(emailController.text));
            var value = await future;
            print(value);
              if(value==true){
                var email = emailController.text;
                var password = passwordController.text;
                authentication.update_password(email,password);
              }
            },

          child: const Text(
            "Confirm",
            style: TextStyle(fontSize: 18, color: Colors.black45,fontWeight: FontWeight.bold),
          )),
    );
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
}



