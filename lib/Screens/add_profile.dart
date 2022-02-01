import 'dart:ffi';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:matrimony/Screens/Home.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProfile extends StatefulWidget {
  User? current_user;
  AddProfile({Key? key, this.current_user}) : super(key: key);

  @override
  _AddProfileState createState() =>
      _AddProfileState(current_user: current_user);
}

class _AddProfileState extends State<AddProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController? imageController;
  TextEditingController eduController = TextEditingController();

  User? current_user = FirebaseAuth.instance.currentUser;
  File? imageFile;
  ImagePicker imagePicker = ImagePicker();

  var state;

  String dropdownValue = "";

  String? selectedCaste ="";
  _AddProfileState({this.current_user});
  String? image;
  List genderItems = [
    'Male',
    'Female',
  ];
  List Caste = ['Padmashalli', 'Reddy', 'Kappu'];
  final _formKey = GlobalKey<FormState>();
  String? fileName;
  String?selectedGender;
  @override
  void initState() {
    // TODO: implement initState
    imageController = TextEditingController();
    String? username = current_user!.displayName;
    nameController.text = username!;

    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    imageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    fileName = imageFile != null ? imageFile!.path.split('/').last : "";

    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(35),
            child: AppBar(
              centerTitle: true,
              backgroundColor: Colors.brown,
              title: const Text(
                "Add details",
                style: TextStyle(color: Colors.white),
              ),
            )),
        body: Padding(
          padding: EdgeInsets.all(20.3),
          child: ListView(
            shrinkWrap: true,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        " Bride/groom Name : - ",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.pink.shade400,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    nameField(),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      child: Text(
                        "Enter gender : - ",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.pink.shade400,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    dropDownGenderField(),
                    SizedBox(
                      height: 8,
                    ),
                    imageSelection(),
                    SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: Text(
                        "Add Caste : - ",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.pink.shade400,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    dropDownCasteField(),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      child: Text(
                        "Education : - ",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.pink.shade400,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    educationField(),
                    SizedBox(
                      height: 8,
                    ),
                    Center(
                      child: submitButton(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Imagefield() {
    return SizedBox(
      child: Stack(
        children: [
          TextFormField(
            controller: imageController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(11.3),
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black38, width: 1.0),
                  borderRadius: BorderRadius.circular(11.3)),
            ),
            onChanged: (value) {},
          ),
          Positioned(
              right: 5,
              top: 3,
              child: TextButton(
                  child: Icon(
                    Icons.attach_file_rounded,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    var status = await Permission.photos.status;
                    if (status.isGranted) {
                      get_permissions();
                    } else if (status.isDenied) {}
                  })),
        ],
      ),
    );
  }

  get_permissions() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        _getFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  nameField() {
    return Container(
      height: 60,
      child: TextFormField(
        focusNode: FocusNode(),
        controller: nameController,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11.3),
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black38, width: 1.0),
                borderRadius: BorderRadius.circular(11.3)),
            hintStyle: const TextStyle(color: Colors.brown)),
      ),
    );
  }  dropDownGenderField() {
    return DropdownButtonFormField2(
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.3),
        ),
      ),
      isExpanded: true,
      hint: const Text(
        'Select Your Gender',
        style: TextStyle(fontSize: 14),
      ),
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.black45,
      ),
      iconSize: 30,
      buttonHeight: 60,
      buttonPadding: const EdgeInsets.only(left: 20, right: 10),
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      items: genderItems
          .map((item) => DropdownMenuItem<String>(
        value: item,
        child: Text(
          item,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
        onTap: (){
          selectedGender = item;
        },
      ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select gender.';
        }
      },
      onChanged: (value) {
        //Do something when changing the item if you want.
      },
      onSaved: (value) {
        selectedGender = value.toString();
        value = selectedGender;
      },
    );
  }

  dropDownCasteField() {
    return DropdownButtonFormField2(
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.3),
        ),
      ),
      isExpanded: true,
      hint: const Text(
        'Select your caste',
        style: TextStyle(fontSize: 14),
      ),
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.black45,
      ),
      iconSize: 30,
      buttonHeight: 60,
      buttonPadding: const EdgeInsets.only(left: 20, right: 10),
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      items: Caste
          .map((caste) => DropdownMenuItem<String>(
                value: caste,
                child: Text(
                  caste,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
        onTap: (){
          selectedCaste = caste;
        },
              ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select gender.';
        }
      },
      onChanged: (value) {
        //Do something when changing the item if you want.
      },
      onSaved: (value) {

      },
    );
  }

  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  /// Get from Camera
  _imgFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }


  educationField() {
    return Container(
      child: TextFormField(
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.values[0],
        focusNode: FocusNode(),
        controller: eduController,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(11.3),
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black38, width: 1.0),
                borderRadius: BorderRadius.circular(11.3)),
            hintStyle: const TextStyle(color: Colors.brown)),
        validator: (value) {
          if (value!.isEmpty) {
            return "please Enter text";
          }
        },
      ),
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
            var validation = _formKey.currentState!.validate();
            if (validation) {
              setState(() {
               print(nameController.text);
                Map<String, dynamic> data = {
                  'name': nameController.text,
                  'gender': selectedGender,
                  'caste': selectedCaste,
                   'imageFile':imageFile?.path,
                   'education':eduController.text,
                };
                print(current_user?.providerData[0].uid);
                FirebaseFirestore.instance
                    .collection('Users')
                    .doc(current_user?.providerData[0].uid).set(data);

              });
            }
          },
          child: const Text(
            "Submit",
            style: TextStyle(fontSize: 16, color: Colors.white),
          )),
    );
  }

  imageSelection() {
    return Center(
      child: Container(
        alignment: Alignment.bottomCenter,
        width: MediaQuery.of(context).size.width,
        height: 130,
        decoration:
            BoxDecoration(border: Border.all(color: Colors.lightBlueAccent)),
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(top: 12.6),
                child: imageFile == null
                    ? Container()
                    : Container(
                        child: Text(fileName!),
                      )),
            Expanded(
              child: Stack(
                children: [
                  imageFile != null
                      ? Container(
                          alignment: Alignment.topCenter,
                          child: SafeArea(
                            child: TextButton(
                              onPressed: () {
                                show_image(imageFile);
                              },
                              child: Text("Show"),
                            ),
                          ),
                        )
                      : Container(),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: SafeArea(
                      child: TextButton(
                        onPressed: () {
                          get_permissions();
                        },
                        child: Text("Add Image"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  show_image(File? imageFile) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            elevation: 20,
            child: Container(
              child: ListView(
                shrinkWrap: true,
                children: [Container(child: Image.file(imageFile!))],
              ),
            ),
          );
        });
  }


}
