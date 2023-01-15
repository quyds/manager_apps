import 'package:flutter/material.dart';

class MyTaskPage extends StatelessWidget {
  const MyTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Task page')),
      body: Center(
        child: Text(
          'My Task page',
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
