import 'package:flutter/material.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Page')),
      body: Center(
        child: Container(
          child: Text('Content'),
        ),
      ),
    );
  }
}
