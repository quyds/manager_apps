import 'package:flutter/material.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News page')),
      body: const Center(
        child: Text(
          'News page',
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
