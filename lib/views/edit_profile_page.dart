import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../services/home_services.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController levelController = TextEditingController();

  File? file;

  // @override
  // void initState() {
  //   User? currentUser = _auth.currentUser;
  //   nameController.text = streamBuilderEditInfo(currentUser);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Edit Profile',
                      style: TextStyle(fontSize: 24),
                    )
                  ],
                ),
              ),
              streamBuilderEditImage(currentUser),
              SizedBox(
                height: 30,
              ),
              streamBuilderEditInfo(currentUser, "name", "Name"),
              // TextField(
              //   controller: nameController,
              //   decoration: InputDecoration(
              //       labelText: "Name", border: OutlineInputBorder()),
              // ),
              SizedBox(
                height: 30,
              ),
              streamBuilderEditPhone(currentUser, "phone", "Phone"),
              SizedBox(
                height: 30,
              ),
              streamBuilderEditLevel(currentUser, "level", "Level"),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        child: Text('Back'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        child: Text('Update Profile'),
                        onPressed: () {
                          updateProfile(context);
                        },
                      ),
                    )
                  ],
                ),
              ),
              // ElevatedButton(onPressed: () {}, child: Text('Update profile'))
            ],
          ),
        ),
      ),
    );
  }

  void chooseImage() async {
    XFile? xfile = await ImagePicker().pickImage(source: ImageSource.gallery);
    print('xFile + ${xfile?.path}');
    file = File(xfile!.path);
    setState(() {});
  }

  updateProfile(BuildContext context) async {
    Map<String, dynamic> map = Map();
    if (file != null) {
      String url = await uploadImage();
      map['profileImage'] = url;
    }
    map['name'] = nameController.text;
    map['phone'] = phoneController.text;
    map['level'] = levelController.text;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update(map);
    Navigator.pop(context);
  }

  Future<String> uploadImage() async {
    TaskSnapshot taskSnapshot = await FirebaseStorage.instance
        .ref()
        .child('profile')
        .child(
            '${FirebaseAuth.instance.currentUser!.uid}_${basename(file!.path)}')
        .putFile(file!);

    return taskSnapshot.ref.getDownloadURL();
  }

  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>> streamBuilderEditInfo(
      User? currentUser, String name, String labelName) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: getData(currentUser!.uid, "users"),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new CircularProgressIndicator();
        }
        var document = snapshot.data;
        var data = document![name];
        debugPrint(data.toString());
        return TextField(
          controller: nameController = TextEditingController(text: data),
          decoration: InputDecoration(
              labelText: labelName, border: OutlineInputBorder()),
        );
      },
    );
  }

  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>> streamBuilderEditPhone(
      User? currentUser, String name, String labelName) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: getData(currentUser!.uid, "users"),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new CircularProgressIndicator();
        }
        var document = snapshot.data;
        var data = document![name];
        debugPrint(data.toString());
        return TextField(
          controller: phoneController = TextEditingController(text: data),
          decoration: InputDecoration(
              labelText: labelName, border: OutlineInputBorder()),
        );
      },
    );
  }

  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>> streamBuilderEditLevel(
      User? currentUser, String name, String labelName) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: getData(currentUser!.uid, "users"),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new CircularProgressIndicator();
        }
        var document = snapshot.data;
        var data = document![name];
        debugPrint(data.toString());
        return TextField(
          controller: levelController = TextEditingController(text: data),
          decoration: InputDecoration(
              labelText: labelName, border: OutlineInputBorder()),
        );
      },
    );
  }

  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>> streamBuilderEditImage(
      User? currentUser) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: getData(currentUser!.uid, "users"),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return new CircularProgressIndicator();
        }
        var document = snapshot.data;
        var data = document!["profileImage"];
        debugPrint('image ${data}');
        return InkWell(
          onTap: () {
            chooseImage();
          },
          child: Container(
            height: 160,
            width: 160,
            decoration: BoxDecoration(
              border: Border.all(width: 3, color: Colors.black),
              shape: BoxShape.circle,
              image: file == null
                  ? data == null
                      ? DecorationImage(
                          image: AssetImage('assets/images/avatar.png'),
                          fit: BoxFit.cover)
                      : DecorationImage(
                          image: NetworkImage(data), fit: BoxFit.cover)
                  : DecorationImage(image: FileImage(file!), fit: BoxFit.cover),
            ),
            child: Container(
                height: 160,
                width: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.blue,
                ),
                margin: EdgeInsets.only(left: 110, top: 120, right: 10),
                child: Icon(
                  Icons.edit,
                  size: 20,
                )),
            alignment: Alignment.center,
          ),
        );
      },
    );
  }
}
