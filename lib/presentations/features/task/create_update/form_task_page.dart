// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manager_apps/core/const/app_constants.dart';
import 'package:manager_apps/core/extensions/custom_style.dart';
import 'package:manager_apps/core/repositories/get_data_collection_doc.dart';
import 'package:manager_apps/presentations/view_models/feedItem/feedItem_model.dart';
import 'package:manager_apps/presentations/view_models/task/task_model.dart';

import 'package:manager_apps/core/repositories/list_state.dart';

class FormTaskPage extends StatefulWidget {
  final TaskModel? dataTask;
  final String? projectId;
  const FormTaskPage({super.key, this.dataTask, this.projectId});

  @override
  State<FormTaskPage> createState() => _FormTaskPageState();
}

class _FormTaskPageState extends State<FormTaskPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var selectedEmployee, selectedState, selectedProject;
  late bool validation = false;

  late TextEditingController titleController;
  late TextEditingController desController;
  late TextEditingController estimateTimeController;
  late TextEditingController completeTimeController;

  final formGlobalKey = GlobalKey<FormState>();

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
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(
            left: Dimension.padding.medium, right: Dimension.padding.medium),
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.dataTask == null
                      ? const Text(
                          'T???o c??ng vi???c m???i',
                          style: CustomTextStyle.topTitleOfTextStyle,
                        )
                      : const Text(
                          'Ch???nh s???a c??ng vi???c',
                          style: CustomTextStyle.topTitleOfTextStyle,
                        )
                ],
              ),
            ),
            Form(
              key: formGlobalKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius:
                            BorderRadius.circular(Dimension.radius.medium),
                      ),
                      labelText: 'Ti??u ?????',
                      labelStyle: CustomTextStyle.labelOfTextStyle,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Vui l??ng nh???p Ti??u ?????!';
                      }
                      return null;
                    },
                    minLines: 1,
                    maxLines: 2,
                    onChanged: (text) {},
                  ),
                  kSpacingHeight10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextFormField(
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
                            labelText: 'Th???i gian d??? ki???n',
                            labelStyle: CustomTextStyle.labelOfTextStyle,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Vui l??ng nh???p Th???i gian!';
                            }
                            return null;
                          },
                          onChanged: (text) {},
                        ),
                      ),
                      kSpacingWidth24,
                      Expanded(
                        child: TextFormField(
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
                            labelText: 'Th???i gian ho??n th??nh',
                            labelStyle: CustomTextStyle.labelOfTextStyle,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Vui l??ng nh???p Th???i gian!';
                            }
                            return null;
                          },
                          onChanged: (text) {},
                        ),
                      ),
                    ],
                  ),
                  kSpacingHeight10,
                  TextFormField(
                    controller: desController,
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.grey,
                      )),
                      labelText: 'N???i dung',
                      labelStyle: CustomTextStyle.labelOfTextStyle,
                    ),
                    minLines: 2,
                    maxLines: 5,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Vui l??ng nh???p N???i dung!';
                      }
                      return null;
                    },
                    onChanged: (text) {},
                  ),
                  kSpacingHeight18,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tr???ng th??i',
                              style: CustomTextStyle.labelOfTextStyle,
                            ),
                            DropdownButtonFormField<String>(
                              hint: const Text(
                                'Ch???n tr???ng th??i',
                                style: TextStyle(fontSize: 12),
                              ),
                              value: selectedState,
                              elevation: 16,
                              style: CustomTextStyle.subOfTextStyle,
                              decoration: const InputDecoration(
                                  border: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black))),
                              validator: (value) {
                                if (widget.dataTask == null) {
                                  if (value != 'To Do') {
                                    return 'L???i tr???ng th??i';
                                  }
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  selectedState = value!;
                                });
                              },
                              // widget.dataTask == null ?
                              items: list.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )
                          ],
                        ),
                      ),
                      kSpacingWidth12,
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Nh??n vi??n',
                              style: CustomTextStyle.labelOfTextStyle,
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
                                        value: snap.id,
                                        child: SizedBox(
                                          width: 80,
                                          child: Text(
                                            snap['name'],
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                CustomTextStyle.subOfTextStyle,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return DropdownButtonFormField(
                                    hint: const Text(
                                      'Ch???n nh??n vi??n',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    elevation: 16,
                                    style: CustomTextStyle.subOfTextStyle,
                                    decoration: const InputDecoration(
                                        border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black))),
                                    value: selectedEmployee,
                                    isExpanded: false,
                                    items: currencyItems,
                                    validator: (value) {
                                      if (value == null) {
                                        return 'L???i nh??n vi??n';
                                      }
                                      return null;
                                    },
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
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      kSpacingWidth12,
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'D??? ??n',
                              style: CustomTextStyle.labelOfTextStyle,
                            ),
                            StreamBuilder<QuerySnapshot>(
                              stream: getDataCollection('projects'),
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
                                        value: snap.id,
                                        child: SizedBox(
                                          width: 80,
                                          child: Text(
                                            snap['title'],
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                CustomTextStyle.subOfTextStyle,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return DropdownButtonFormField(
                                    hint: const Text(
                                      'Ch???n d??? ??n',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    elevation: 16,
                                    style: CustomTextStyle.subOfTextStyle,
                                    decoration: const InputDecoration(
                                        border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black))),
                                    value: selectedProject,
                                    isExpanded: false,
                                    items: currencyItems,
                                    validator: (value) {
                                      if (value == null) {
                                        return 'L???i d??? ??n';
                                      }
                                      return null;
                                    },
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
                                      });
                                    },
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  kSpacingHeight12,
                  Row(
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
                          child: const Text('Tr??? l???i'),
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
                              ? const Text('T???o m???i')
                              : const Text('Ch???nh s???a'),
                          onPressed: () {
                            if (formGlobalKey.currentState!.validate()) {
                              formGlobalKey.currentState!.save();
                              widget.dataTask == null
                                  ? postTaskDetailsToFirestore()
                                  : updateTaskDetail(context);
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
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

    await firebaseFirestore.collection('projects').doc(selectedProject).update({
      'taskArray': FieldValue.arrayUnion([idTask]),
      'employeeArray': FieldValue.arrayUnion([selectedEmployee])
    });

    addTaskToNotificationFeed();

    const snackBar = SnackBar(
      content: Text('????ng k?? th??nh c??ng !'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    if (widget.projectId == null) {
      Navigator.of(context).pushNamed('/ListTask');
    } else {
      Navigator.of(context).pop();
    }
  }

  addTaskToNotificationFeed() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var currentUser = FirebaseAuth.instance.currentUser;
    final idFeed = firebaseFirestore.collection('feedItems').doc().id;

    FeedItemModel feedItemModel = FeedItemModel(
      id: idFeed,
      username: currentUser?.displayName,
      userId: currentUser?.uid,
      userProgileImage: currentUser?.photoURL,
      type: 'c??ng vi???c',
      title: titleController.text,
      employeeId: selectedEmployee,
      isChecked: true,
    );

    await firebaseFirestore
        .collection("feedItems")
        .doc(idFeed)
        .set(feedItemModel.toMap());
  }
}
