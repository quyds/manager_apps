import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ListTaskPage extends StatefulWidget {
  const ListTaskPage({super.key});

  @override
  State<ListTaskPage> createState() => _ListTaskPageState();
}

class _ListTaskPageState extends State<ListTaskPage> {
  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[500, 300, 100];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Task'),
      ),
      body: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.blue[colorCodes[index]],
            child: ListTile(
              leading: const Icon(Icons.list),
              trailing: Icon(Icons.edit),
              title: Text("List item ${entries[index]}"),
              subtitle: Text('list detail'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/CreateTask');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
