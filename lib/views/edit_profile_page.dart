import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manager_apps/const/app_constants.dart';
import 'package:manager_apps/models/user/user_model.dart';
import 'package:path/path.dart';

import '../core/extensions/update_info.dart';
import '../core/repositories/get_data_collection_doc.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel? dataUser;
  final UserModel? userAuth;
  const EditProfilePage({super.key, this.dataUser, this.userAuth});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController levelController;

  File? file;

  @override
  void initState() {
    if (widget.dataUser == null) {
      nameController = TextEditingController();
      phoneController = TextEditingController();
      levelController = TextEditingController();
    } else {
      nameController = TextEditingController(text: widget.dataUser?.name);
      phoneController = TextEditingController(text: widget.dataUser?.phone);
      levelController = TextEditingController(text: widget.dataUser?.level);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      'Chỉnh sửa thông tin',
                      style: TextStyle(fontSize: 24),
                    )
                  ],
                ),
              ),
              streamBuilderEditImage(currentUser),
              kSpacingHeight32,
              streamBuilderEditInfo(currentUser, "name", "Name"),
              kSpacingHeight32,
              streamBuilderEditPhone(currentUser, "phone", "Phone"),
              kSpacingHeight32,
              streamBuilderEditLevel(currentUser, "level", "Level"),
              Container(
                margin: const EdgeInsets.only(top: 10),
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
                        child: const Text('Trở lại'),
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
                        child: const Text('Cập nhật thông tin'),
                        onPressed: () {
                          updateProfile(context);
                        },
                      ),
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
      stream: getDataDoc(currentUser!.uid, "users"),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        var document = snapshot.data;
        var data = document![name];
        debugPrint(data.toString());
        if (widget.dataUser?.uid == currentUser.uid) {
          if (nameController.text.isNotEmpty) {
            updateDisplayName(nameController.text);
          }
        }
        return TextField(
          controller: nameController,
          decoration: InputDecoration(
              labelText: labelName, border: const OutlineInputBorder()),
        );
      },
    );
  }

  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>> streamBuilderEditPhone(
      User? currentUser, String name, String labelName) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: getDataDoc(currentUser!.uid, "users"),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        var document = snapshot.data;
        var data = document![name];
        debugPrint(data.toString());
        return TextField(
          controller: phoneController,
          decoration: InputDecoration(
              labelText: labelName, border: const OutlineInputBorder()),
        );
      },
    );
  }

  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>> streamBuilderEditLevel(
      User? currentUser, String name, String labelName) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: getDataDoc(currentUser!.uid, "users"),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        var document = snapshot.data;
        var data = document![name];
        debugPrint(data.toString());
        return TextField(
          controller: levelController,
          decoration: InputDecoration(
              labelText: labelName, border: const OutlineInputBorder()),
        );
      },
    );
  }

  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>> streamBuilderEditImage(
      User? currentUser) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: getDataDoc(currentUser!.uid, "users"),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        var data = widget.dataUser?.profileImage;
        if (widget.dataUser?.uid == currentUser.uid) {
          updatePhotoUrl(data!);
        }
        return InkWell(
          onTap: () {
            chooseImage();
          },
          child: Container(
            height: 160,
            width: 160,
            decoration: BoxDecoration(
              border: Border.all(
                  width: 3, color: const Color.fromARGB(255, 110, 76, 76)),
              shape: BoxShape.circle,
              image: file == null
                  ? data == null
                      ? const DecorationImage(
                          image: AssetImage('assets/images/avatar.png'),
                          fit: BoxFit.cover)
                      : DecorationImage(
                          image: NetworkImage(data), fit: BoxFit.cover)
                  : DecorationImage(image: FileImage(file!), fit: BoxFit.cover),
            ),
            alignment: Alignment.center,
            child: Container(
                height: 160,
                width: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.blue,
                ),
                margin: const EdgeInsets.only(left: 110, top: 120, right: 10),
                child: const Icon(
                  Icons.edit,
                  size: 20,
                )),
          ),
        );
      },
    );
  }
}
