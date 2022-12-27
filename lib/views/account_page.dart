import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account page')),
      body: Center(
        child: Text(
          'Account page',
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
