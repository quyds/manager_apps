import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manager_apps/core/extensions/validator.dart';
import 'package:manager_apps/presentations/view_models/user/user_model.dart';

import '../../core/extensions/update_info.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final formGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
          child: Form(
            key: formGlobalKey,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Ứng dụng quản lý',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Đăng ký',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: nameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Vui lòng nhập Họ và tên!";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Opacity(
                        opacity: 0.3,
                        child: Container(
                          padding: EdgeInsets.only(left: 8, right: 8),
                          width: 50,
                          child: Image.asset(
                            "assets/images/ic_user.png",
                          ),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      labelText: 'Họ và tên',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (!isEmail(value!)) {
                        return 'Vui lòng nhập Email!';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Opacity(
                        opacity: 0.5,
                        child: Container(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          width: 50,
                          child: Image.asset(
                            "assets/images/ic_mail.png",
                          ),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      labelText: 'Email',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Vui lòng nhập mật khẩu!";
                      } else if (value.length < 5) {
                        return "Vui lòng nhập mật khẩu trên 5 ký tự!";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Opacity(
                        opacity: 0.2,
                        child: Container(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          width: 50,
                          child: Image.asset(
                            "assets/images/ic_password.png",
                          ),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      labelText: 'Mật khẩu',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                  child: TextFormField(
                    obscureText: true,
                    controller: confirmPasswordController,
                    validator: (value) {
                      if (value != passwordController.text) {
                        return "Vui lòng nhập mật khẩu trùng nhau!";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Opacity(
                        opacity: 0.2,
                        child: Container(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          width: 50,
                          child: Image.asset(
                            "assets/images/ic_password.png",
                          ),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      labelText: 'Nhập lại mật khẩu',
                    ),
                  ),
                ),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: const Text(
                        'Đăng ký',
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        if (formGlobalKey.currentState!.validate()) {
                          formGlobalKey.currentState!.save();
                          FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passwordController.text)
                              .then(
                            (value) {
                              if (value.additionalUserInfo != null) {
                                postDetailsToFirestore();
                              }
                            },
                          ).onError((error, stackTrace) {
                            print('Error ${error.toString()}');
                          });
                        }
                      },
                    )),
                Row(
                  // ignore: sort_child_properties_last
                  children: <Widget>[
                    const Text(
                      'Đã có tài khoản?',
                    ),
                    TextButton(
                      child: const Text(
                        'Đăng nhập',
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/LogIn');
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;

    UserModel userModel = UserModel(
      uid: user!.uid,
      email: user.email,
      name: nameController.text,
    );

    await firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .set(userModel.toMap());

    updateDisplayName(nameController.text);

    const snackBar = SnackBar(
      content: Text('Đăng ký thành công !'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.of(context).pushNamed('/LogIn');
  }
}
