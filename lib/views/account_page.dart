import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account page')),
      body: Column(
        children: [
          ListTile(
            title: Text('Log in'),
            onTap: () {
              Navigator.of(context).pushNamed('/LogIn');
            },
          )
        ],
      ),
    );
  }
}
