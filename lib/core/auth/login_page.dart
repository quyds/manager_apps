import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manager_apps/core/const/app_constants.dart';

import 'package:manager_apps/core/extensions/validator.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  static Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    User? user;
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        const snackBar = SnackBar(
          content: Text('Tài khoản chưa đăng ký!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
    return user;
  }

  final formGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(Dimension.padding.medium),
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
                      'Đăng nhập',
                      style: TextStyle(fontSize: 20),
                    )),
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
                      labelText: 'Email',
                      prefixIcon: Opacity(
                        opacity: 0.5,
                        child: Container(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          width: 50,
                          child: Image.asset(
                            "assets/images/ic_mail.png",
                          ),
                        ),
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                      labelText: 'Mật khẩu',
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
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/ForgotPassword');
                  },
                  child: const Text(
                    'Đổi mật khẩu',
                  ),
                ),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: const Text(
                        'Đăng nhập',
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () async {
                        if (formGlobalKey.currentState!.validate()) {
                          formGlobalKey.currentState!.save();
                          User? user = await loginUsingEmailPassword(
                              email: emailController.text,
                              password: passwordController.text,
                              context: context);
                          if (user != null) {
                            Navigator.of(context).pushNamed('/Main');
                          }
                        }
                      },
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Bạn chưa có tài khoản?'),
                    TextButton(
                      child: const Text(
                        'Đăng ký',
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/Register');
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
