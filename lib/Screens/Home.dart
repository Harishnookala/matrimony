import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matrimony/repositories/authentication.dart';

import 'Login/login.dart';
import 'MainPage.dart';
import 'add_profile.dart';

class Home extends StatefulWidget {
  User? user;
  String? name;
  String? email;
  Home({Key? key, this.user, this.name, this.email}) : super(key: key);

  @override
  HomeState createState() => HomeState(name: this.name, email: this.email);
}

class HomeState extends State<Home> {
  String? name;
  String? email;

  User? user;
  User? current_user = FirebaseAuth.instance.currentUser;
  var providerId="";
  HomeState({this.name, this.email});
  @override
  Widget build(BuildContext context) {
    providerId = current_user!.providerData[0].providerId;
    print(providerId);
    print(current_user);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Home"),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 33,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.3),color: Colors.indigoAccent.shade200),
                        child: TextButton(onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AddProfile(current_user:current_user,uid:current_user!.uid)));
                          },
                            child: Row(
                          children: [
                            Icon(Icons.add,size: 19,color: Colors.white,),
                            Container(
                                margin: EdgeInsets.only(left: 3.3),
                                child: Text("Add Profile",style: TextStyle(color: Colors.pink,fontSize: 15),)),
                          ],
                        )),
                      ),

                    ],
                  )
                ],
              ),
            ),
            drawer: Drawer(
              child: DrawerHeader(
                  child: Column(
                children: [
                  build_drawer(current_user,providerId)],
              )),
            ),
            body: Center(
                child: providerId == "google.com"
                    ? MainPage(current_user: current_user)
                    : providerId == "phone"
                        ? MainPage(current_user: current_user)
                        : MainPage(current_user: current_user))));
  }

  build_drawer(User? current_user, String providerId) {
    return new Container(
      //margin: EdgeInsets.all(12.3),
      child: ListView(
        shrinkWrap: true,
        children: [
          Center(
            child: ClipOval(
              child: current_user!.photoURL!=null?Image.network(
                current_user.photoURL!,
                height: 70,
                width: 70,
              ):Container(child: Icon(Icons.photo,size: 70,),),
            ),
          ),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 15.6),
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 17.6),
                      child:current_user.displayName!=null? Text(
                        "Name  : - ",
                        style: TextStyle(color: Colors.deepOrange.shade400),
                      ):Text("Phone Number : -",style: TextStyle(color: Colors.deepOrange.shade400)),
                    ),
                    Container(
                      child: current_user.displayName!=null?Text(
                        current_user.displayName!,
                        style: TextStyle(color: Colors.purpleAccent.shade200),
                      ):Text(current_user.phoneNumber!,
                      style:TextStyle(color: Colors.purpleAccent.shade100,),
                    )),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15.6),
                child: Row(
                  children: [
                    current_user.email!=null?Container(
                      margin: EdgeInsets.only(right: 17.6),
                      child: Text(
                        "Email  : - ",
                        style: TextStyle(color: Colors.deepOrange.shade400),
                      ),
                    ):Container(),
                   current_user.email!=null?Container(
                      child: Text(
                        current_user.email!,
                        style: TextStyle(
                          color: Colors.purpleAccent.shade200,
                        ),
                      ),
                    ):Container(),
                  ],
                ),
              ),
              Logoutbutton(current_user,providerId),
            ],
          ),

        ],
      ),
    );
  }

  Logoutbutton(User current_user, String providerId) {
    return Container(
      width: MediaQuery.of(context).size.width/2.8,
      margin: const EdgeInsets.only(top: 15.6),
      child: TextButton(
          style: ButtonStyle(
              backgroundColor:
              MaterialStateProperty.all<Color>(Colors.green.shade500),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
          onPressed: () {
            if (providerId == "google.com") {
              print("Success");
              Authentication().signOutFromGoogle();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Login()));
            } else if (providerId == "phone") {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Login()));
            } else if (providerId == "password") {
              Authentication().signOut();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const Login()));
            }
          },
          child: const Text(
            "Log out",
            style: TextStyle(color: Colors.deepOrange, fontSize: 16),
          )),
    );
  }


}
