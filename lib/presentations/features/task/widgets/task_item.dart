import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manager_apps/core/extensions/date_format.dart';
import 'package:manager_apps/data/models/task_arguments_model.dart';
import 'package:manager_apps/presentations/view_models/task/task_model.dart';

class TaskItem extends StatefulWidget {
  final TaskModel? filterTaskModel;
  final TaskModel? taskModel;
  final int? index;
  final String? selectedState;
  final List? filter;

  const TaskItem(
      {super.key,
      this.filterTaskModel,
      this.taskModel,
      this.index,
      this.filter,
      this.selectedState});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  String? selectedStateValue;
  List? filterState;

  @override
  Widget build(BuildContext context) {
    selectedStateValue = widget.selectedState;
    filterState = widget.filter;
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          onTap: () {
            Navigator.of(context)
                .pushNamed('/CreateTask',
                    arguments:
                        TaskArguments(taskModel: filterState![widget.index!]))
                .then(
                  (value) => setState(() {
                    if (value != null) {
                      widget.filterTaskModel?.updatedAt;
                      selectedStateValue = value as String?;
                      filterStateFromFb(selectedStateValue);
                    }
                  }),
                );
          },
          title: Text(
            widget.filterTaskModel?.title ?? widget.taskModel?.title ?? '',
            style: const TextStyle(
              fontSize: 18,
            ),
            maxLines: 1,
          ),
          subtitle: Container(
            margin: const EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.filterTaskModel?.description ??
                      widget.taskModel?.description ??
                      '',
                  style: const TextStyle(fontSize: 14),
                  maxLines: 4,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.only(top: 5),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${widget.filterTaskModel?.state}'),
                      widget.filterTaskModel?.updatedAt == null
                          ? Text(
                              '${getFormatedDate(widget.filterTaskModel?.createdAt)}')
                          : Text(
                              'updated ${getFormatedDate(widget.filterTaskModel?.updatedAt)}')
                    ],
                  ),
                )
              ],
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward,
            color: Colors.deepPurple,
            size: 25,
          ),
        ),
      ),
    );
  }

  void filterStateFromFb(String? query) async {
    selectedStateValue = query;
    final result = await FirebaseFirestore.instance
        .collection('tasks')
        .where('state', isEqualTo: query)
        .get();

    setState(() {
      filterState = result.docs.map((e) => e.data()).toList();
    });
  }
}
