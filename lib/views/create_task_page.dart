import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manager_apps/const/app_constants.dart';
import 'package:manager_apps/core/extensions/custom_style.dart';
import 'package:manager_apps/core/repositories/get_data_collection_doc.dart';

import '../core/repositories/list_state.dart';
import '../models/task/task_model.dart';

class CreateTaskPage extends StatefulWidget {
  final TaskModel? dataTask;
  final String? projectId;
  const CreateTaskPage({super.key, this.dataTask, this.projectId});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var selectedEmployee, selectedState, selectedProject;
  late bool validation = false;

  late TextEditingController titleController;
  late TextEditingController desController;
  late TextEditingController estimateTimeController;
  late TextEditingController completeTimeController;

  @override
  void initState() {
    if (widget.dataTask == null) {
      titleController = TextEditingController();
      desController = TextEditingController();
      estimateTimeController = TextEditingController();
      completeTimeController = TextEditingController();
    } else {
      titleController = TextEditingController(text: widget.dataTask?.title);
      desController = TextEditingController(text: widget.dataTask?.description);
      estimateTimeController =
          TextEditingController(text: widget.dataTask?.estimateTime);
      completeTimeController =
          TextEditingController(text: widget.dataTask?.completeTime);
      selectedEmployee = widget.dataTask?.employee;
      selectedState = widget.dataTask?.state;
      selectedProject = widget.dataTask?.project;
    }

    if (widget.projectId == null) {
      titleController = TextEditingController(text: widget.dataTask?.title);
      desController = TextEditingController(text: widget.dataTask?.description);
      estimateTimeController =
          TextEditingController(text: widget.dataTask?.estimateTime);
      completeTimeController =
          TextEditingController(text: widget.dataTask?.completeTime);
    } else {
      selectedProject = widget.projectId;
    }

    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    desController.dispose();
    estimateTimeController.dispose();
    completeTimeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.dataTask?.project);
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            Container(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.dataTask == null
                      ? Text(
                          'Tạo công việc mới',
                          style: CustomTextStyle.topTitleOfTextStyle,
                        )
                      : Text(
                          'Chỉnh sửa công việc',
                          style: CustomTextStyle.topTitleOfTextStyle,
                        )
                ],
              ),
            ),
            Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius:
                          BorderRadius.circular(Dimension.radius.medium),
                    ),
                    labelText: 'Tiêu đề',
                    errorText: validation ? 'Tiêu đề không được trống' : null,
                    labelStyle: CustomTextStyle.labelOfTextStyle,
                  ),
                  minLines: 1,
                  maxLines: 2,
                  onChanged: (text) {},
                ),
                kSpacingHeight10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: estimateTimeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.grey,
                          )),
                          contentPadding: EdgeInsets.only(
                              top: Dimension.padding.huge,
                              bottom: Dimension.padding.huge),
                          labelText: 'Thời gian dự kiến',
                          labelStyle: CustomTextStyle.labelOfTextStyle,
                        ),
                        onChanged: (text) {},
                      ),
                    ),
                    kSpacingWidth24,
                    Expanded(
                      child: TextField(
                        controller: completeTimeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                          contentPadding: EdgeInsets.only(
                              top: Dimension.padding.huge,
                              bottom: Dimension.padding.huge),
                          labelText: 'Thời gian hoàn thành',
                          labelStyle: CustomTextStyle.labelOfTextStyle,
                        ),
                        onChanged: (text) {},
                      ),
                    ),
                  ],
                ),
                kSpacingHeight10,
                TextField(
                  controller: desController,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.grey,
                    )),
                    labelText: 'Nội dung',
                    labelStyle: CustomTextStyle.labelOfTextStyle,
                  ),
                  minLines: 2,
                  maxLines: 5,
                  onChanged: (text) {},
                ),
                kSpacingHeight18,
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            child: Text(
                              'Trạng thái',
                              overflow: TextOverflow.ellipsis,
                              style: CustomTextStyle.labelOfTextStyle,
                            ),
                          ),
                          DropdownButton<String>(
                            hint: const Text('Chọn trạng thái'),
                            value: selectedState,
                            elevation: 16,
                            style: CustomTextStyle.subOfTextStyle,
                            underline: Container(
                              height: 1,
                              color: Colors.grey,
                            ),
                            onChanged: (value) {
                              setState(() {
                                selectedState = value!;
                              });
                            },
                            items: list
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          )
                        ],
                      ),
                      kSpacingWidth12,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 80,
                            child: Text(
                              'Nhân viên',
                              overflow: TextOverflow.ellipsis,
                              style: CustomTextStyle.labelOfTextStyle,
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: getDataCollection('users'),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const CircularProgressIndicator();
                              } else {
                                List<DropdownMenuItem> currencyItems = [];
                                for (int i = 0;
                                    i < snapshot.data!.docs.length;
                                    i++) {
                                  DocumentSnapshot snap =
                                      snapshot.data!.docs[i];
                                  currencyItems.add(
                                    DropdownMenuItem(
                                      child: Text(
                                        snap['name'],
                                        style: CustomTextStyle.subOfTextStyle,
                                      ),
                                      value: "${snap.id}",
                                    ),
                                  );
                                }
                                return Row(
                                  children: [
                                    DropdownButton(
                                      hint: Text('Chọn nhân viên'),
                                      elevation: 16,
                                      style: CustomTextStyle.subOfTextStyle,
                                      underline: Container(
                                        height: 1,
                                        color: Colors.grey,
                                      ),
                                      value: selectedEmployee,
                                      isExpanded: false,
                                      items: currencyItems,
                                      onChanged: (currencyValue) {
                                        const snackBar = SnackBar(
                                          content: Text(
                                            'Da chon !',
                                            style: TextStyle(
                                              color: Color(0xff11b719),
                                            ),
                                          ),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                        setState(() {
                                          selectedEmployee = currencyValue;
                                        });
                                      },
                                    )
                                  ],
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      kSpacingWidth12,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              'Dự án',
                              style: CustomTextStyle.labelOfTextStyle,
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: getDataCollection('projects'),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return new CircularProgressIndicator();
                              } else {
                                List<DropdownMenuItem> currencyItems = [];
                                for (int i = 0;
                                    i < snapshot.data!.docs.length;
                                    i++) {
                                  DocumentSnapshot snap =
                                      snapshot.data!.docs[i];
                                  currencyItems.add(
                                    DropdownMenuItem(
                                      value: "${snap.id}",
                                      child: SizedBox(
                                        width: 80,
                                        child: Text(
                                          snap['title'],
                                          overflow: TextOverflow.ellipsis,
                                          style: CustomTextStyle.subOfTextStyle,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return Row(
                                  children: [
                                    DropdownButton(
                                      hint: Text('Chọn dự án'),
                                      elevation: 16,
                                      style: CustomTextStyle.subOfTextStyle,
                                      underline: Container(
                                        height: 1,
                                        color: Colors.grey,
                                      ),
                                      value: selectedProject,
                                      isExpanded: false,
                                      items: currencyItems,
                                      onChanged: (currencyValue) {
                                        const snackBar = SnackBar(
                                          content: Text(
                                            'Da chon !',
                                            style: TextStyle(
                                              color: Color(0xff11b719),
                                            ),
                                          ),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                        setState(() {
                                          selectedProject = currencyValue;
                                          print(
                                              'selectedProject ${selectedProject}');
                                        });
                                      },
                                    )
                                  ],
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                          child: const Text('Trở lại'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                          child: widget.dataTask == null
                              ? const Text('Tạo mới')
                              : const Text('Chỉnh sửa'),
                          onPressed: () {
                            setState(() {});
                            widget.dataTask == null
                                ? postTaskDetailsToFirestore()
                                : updateTaskDetail(context);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  updateTaskDetail(BuildContext context) async {
    Map<String, dynamic> map = Map();

    map['title'] = titleController.text;
    map['description'] = desController.text;
    map['estimateTime'] = estimateTimeController.text;
    map['completeTime'] = completeTimeController.text;
    map['state'] = selectedState;
    map['employee'] = selectedEmployee;
    map['updatedAt'] = FieldValue.serverTimestamp();
    map['project'] = selectedProject;

    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(widget.dataTask?.id)
        .update(map);

    await FirebaseFirestore.instance
        .collection('projects')
        .doc(selectedProject)
        .update({
      'taskArray': FieldValue.arrayUnion([widget.dataTask?.id]),
      'employeeArray': FieldValue.arrayUnion([selectedEmployee])
    });

    Navigator.pop(context, widget.dataTask?.state);
  }

  void postTaskDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final idTask = firebaseFirestore.collection('tasks').doc().id;

    TaskModel taskModel = TaskModel(
      id: idTask,
      title: titleController.text,
      description: desController.text,
      estimateTime: estimateTimeController.text,
      completeTime: completeTimeController.text,
      state: selectedState,
      employee: selectedEmployee,
      project: selectedProject,
    );

    await firebaseFirestore
        .collection('tasks')
        .doc(idTask)
        .set(taskModel.toMap());

    await FirebaseFirestore.instance
        .collection('projects')
        .doc(selectedProject)
        .update({
      'taskArray': FieldValue.arrayUnion([idTask]),
      'employeeArray': FieldValue.arrayUnion([selectedEmployee])
    });

    const snackBar = SnackBar(
      content: Text('Đăng ký thành công !'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    if (widget.projectId == null) {
      Navigator.of(context).pushNamed('/ListTask');
    } else {
      Navigator.of(context).pop();
    }
  }
}
