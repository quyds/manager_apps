import 'package:flutter/material.dart';
import 'package:manager_apps/models/task/task_model.dart';

class TaskItem extends StatelessWidget {
  final Task listedTask;
  const TaskItem({required this.listedTask, super.key});

  @override
  Widget build(BuildContext context) {
    var myTextStyle = Theme.of(context).textTheme;
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          onTap: () {
            Navigator.of(context)
                .pushNamed('/TaskDetail', arguments: listedTask);
          },
          // leading: Icon(Icons.task),
          title: Text(
            listedTask.title,
            style: myTextStyle.headline6,
          ),
          subtitle: Container(
            margin: EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  listedTask.description,
                  style: myTextStyle.subtitle1,
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("In Progress"), Text('${listedTask.date}')],
                  ),
                )
              ],
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward,
            color: Colors.deepPurple,
            size: 25,
          ),
        ),
      ),
    );
  }
}
