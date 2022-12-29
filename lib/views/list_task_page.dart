import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:manager_apps/models/task_model.dart';
import '../net/data.dart';
import 'widgets/task_item.dart';

class ListTaskPage extends StatelessWidget {
  late List<Task> allTasks;
  ListTaskPage() {
    allTasks = prepareData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Task'),
      ),
      body: Center(
        child: ListView.builder(
            itemCount: allTasks.length,
            itemBuilder: ((context, index) {
              return TaskItem(
                listedTask: allTasks[index],
              );
            })),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/CreateTask');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  List<Task> prepareData() {
    List<Task> all = [];
    int lenght = DataTasks.Task_Title.length;
    for (int i = 0; i < lenght - 1; i++) {
      int taskId = i + 1;
      var taskTitle = DataTasks.Task_Title[i];
      var taskDesciption = DataTasks.Task_Description[i];
      var taskEstimateTime = DataTasks.Task_EstimateTime[i];
      var taskCompleteTime = DataTasks.Task_CompleteTime[i];
      String taskDate = DateFormat('yyyy-MM-dd hh:mm').format(DateTime.now());
      Task addTask = Task(taskId, taskTitle, taskDesciption, taskEstimateTime,
          taskCompleteTime, taskDate);
      all.add(addTask);
    }
    return all;
  }
}