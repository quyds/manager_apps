import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manager_apps/presentations/features/task/widgets/task_item.dart';
import 'package:manager_apps/presentations/view_models/task/task_model.dart';

import 'package:manager_apps/core/extensions/custom_style.dart';
import 'package:manager_apps/core/repositories/list_state.dart';

class ListTaskPage extends StatefulWidget {
  final String? currentState;
  const ListTaskPage({super.key, this.currentState});

  @override
  State<ListTaskPage> createState() => _ListTaskPageState();
}

class _ListTaskPageState extends State<ListTaskPage> {
  var selectedStateValue;
  List filterState = [];

  @override
  void initState() {
    if (widget.currentState != null) {
      selectedStateValue = widget.currentState;
      filterStateFromFb(widget.currentState);
    } else {
      selectedStateValue = list.first;
      filterStateFromFb(list.first);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamed('/Main');
          },
        ),
        title: const Text('Danh sách công việc'),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 1),
                  blurRadius: 5,
                  color: Colors.black.withOpacity(0.3),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Trạng thái'),
                  SizedBox(
                    height: 20,
                    child: DropdownButton<String>(
                      value: selectedStateValue,
                      underline: null,
                      elevation: 16,
                      style: CustomTextStyle.subOfTextStyle,
                      onChanged: (value) {
                        filterStateFromFb(value!);
                      },
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
                color: Colors.grey.shade300,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('tasks')
                      .get()
                      .asStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    if (snapshot.hasData) {
                      if (filterState.isEmpty) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [Text('No Tasks')],
                        );
                      }
                      return ListView.builder(
                        itemCount: filterState.isEmpty
                            ? snapshot.data!.docs.length
                            : filterState.length,
                        itemBuilder: ((context, index) {
                          TaskModel filterTaskModel =
                              TaskModel.fromMap(filterState[index]);

                          TaskModel taskModel = TaskModel.fromMap(
                              snapshot.data!.docs[index].data());
                          return Container(
                              margin: const EdgeInsets.all(5),
                              child: TaskItem(
                                filterTaskModel: filterTaskModel,
                                taskModel: taskModel,
                                index: index,
                                filter: filterState,
                                selectedState: selectedStateValue,
                              ));
                        }),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                )),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/CreateTask');
        },
        child: const Icon(Icons.add),
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
