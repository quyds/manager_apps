import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? file;

  @override
  Widget build(BuildContext context) {
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
              InkWell(
                onTap: () {
                  chooseImage();
                },
                child: Container(
                  height: 160,
                  width: 160,
                  decoration: BoxDecoration(
                    border: Border.all(width: 3, color: Colors.black),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: file == null
                            ? AssetImage('assets/images/avatar.png')
                            : AssetImage(''),
                        fit: BoxFit.cover),
                  ),
                  child: Container(
                      height: 160,
                      width: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(left: 120, top: 120),
                      child: Icon(
                        Icons.edit,
                        size: 20,
                      )),
                  alignment: Alignment.center,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                decoration: InputDecoration(
                    labelText: "Name",
                    hintText: "Enter name",
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Enter email",
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                decoration: InputDecoration(
                    labelText: "Phone",
                    hintText: "Enter phone",
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                decoration: InputDecoration(
                    labelText: "Level",
                    hintText: "Enter level",
                    border: OutlineInputBorder()),
              ),
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
                        onPressed: () {},
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
    XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
    print('File + ${file?.path}');
  }
}
