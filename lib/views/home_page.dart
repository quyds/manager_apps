import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manager_apps/models/colors_model.dart';
import 'package:manager_apps/models/project/project_model.dart';
import 'package:manager_apps/models/task/task_model.dart';

import '../core/extensions/date_format.dart';
import '../core/repositories/get_data_collection_doc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final List<Color> colors = <Color>[
    Colors.blue.shade900,
    Colors.pink.shade900,
    Colors.green.shade900,
    Colors.yellow.shade900,
    Colors.red.shade900,
  ];
  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: AppBar(
          toolbarHeight: 150,
          title: Container(
            margin: EdgeInsets.only(left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: getDataDoc(currentUser!.uid, "users"),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      var document = snapshot.data;
                      return Text(
                        document!["name"] ?? 'Your Name',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      );
                    }),
                SizedBox(
                  height: 5,
                ),
                StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: getDataDoc(currentUser.uid, "users"),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      var document = snapshot.data;
                      return Text(
                        document!["level"] ?? 'Your Level',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      );
                    }),
              ],
            ),
          ),
          leadingWidth: 90,
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('/EditProfile');
            },
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: getDataDoc(currentUser.uid, "users"),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  var document = snapshot.data;
                  var image = document!["profileImage"];
                  return Container(
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.white),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.35),
                          spreadRadius: 5,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        )
                      ],
                      shape: BoxShape.circle,
                      image: image == null
                          ? DecorationImage(
                              image: AssetImage('assets/images/avatar.png'),
                              fit: BoxFit.contain)
                          : DecorationImage(
                              image: NetworkImage(image),
                              fit: BoxFit.contain,
                            ),
                    ),
                  );
                }),
          ),
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 30, right: 10),
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.deepPurple.shade900,
                  ),
                  child: Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                  alignment: Alignment.center,
                ),
              ],
            )
          ],
          backgroundColor: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            homeTitle(context, 'Dự án hiện tại', '/FormProject', Icons.add),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              height: 160,
              child: homeListProject(context),
            ),
            homeTitle(context, 'Trạng thái', '', null),
            Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                height: 80,
                child: Container(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 30,
                    children: [
                      FilterChip(
                        showCheckmark: false,
                        label: Text('Thực hiện'),
                        labelStyle: TextStyle(),
                        onSelected: (bool selected) {
                          setState(() {});
                        },
                        selectedColor: Colors.green.shade500,
                        backgroundColor: Colors.grey.shade500,
                      ),
                      FilterChip(
                        showCheckmark: false,
                        label: Text('Đang thực hiện'),
                        labelStyle: TextStyle(),
                        onSelected: (bool selected) {
                          setState(() {});
                        },
                        selectedColor: Colors.green.shade500,
                        backgroundColor: Colors.grey.shade500,
                      ),
                      FilterChip(
                        showCheckmark: false,
                        label: Text('Hoàn thành'),
                        labelStyle: TextStyle(),
                        onSelected: (bool selected) {
                          setState(() {});
                        },
                        selectedColor: Colors.green.shade500,
                        backgroundColor: Colors.grey.shade500,
                      ),
                      FilterChip(
                        showCheckmark: false,
                        label: Text('Đã đóng'),
                        labelStyle: TextStyle(),
                        onSelected: (bool selected) {
                          setState(() {});
                        },
                        selectedColor: Colors.green.shade500,
                        backgroundColor: Colors.grey.shade500,
                      ),
                    ],
                  ),
                )),
            homeTitle(context, 'Công việc của tôi', '/CreateTask', Icons.add),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              height: 160,
              child: homeListTask(context),
            )
          ],
        ),
      ),
    );
  }

  Container homeTitle(BuildContext context, String title, String route, icons) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Container(
            margin: EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(route).then((value) => setState(
                      () {},
                    ));
              },
              icon: Icon(
                icons,
                color: Colors.deepPurple.shade900,
              ),
            ),
          ),
        ],
      ),
      margin: EdgeInsets.only(top: 20, left: 10, bottom: 10),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> homeListTask(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('tasks').get().asStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.hasData) {
          if (snapshot.data!.docs.length == 0) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [Text('No Tasks')],
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              TaskModel? taskModel =
                  TaskModel.fromMap(snapshot.data!.docs[index].data());
              print('task leght ${snapshot.data!.docs.length}');

              return ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed('/ListTask');
                },
                leading: Container(
                  height: 46,
                  width: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.deepPurple.shade900,
                  ),
                  child: Icon(
                    Icons.format_list_bulleted,
                    color: Colors.white,
                  ),
                  alignment: Alignment.center,
                ),
                title: Text(
                  'To Do',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Text('10 task'),
              );
            },
          );
        }
        return Center(
          child: new CircularProgressIndicator(),
        );
      },
    );

    // ListTile(
    //   onTap: () {
    //     Navigator.of(context).pushNamed('/ListTask');
    //   },
    //   leading: Container(
    //     height: 46,
    //     width: 46,
    //     decoration: BoxDecoration(
    //       shape: BoxShape.circle,
    //       color: Colors.deepPurple.shade900,
    //     ),
    //     child: Icon(
    //       Icons.format_list_bulleted,
    //       color: Colors.white,
    //     ),
    //     alignment: Alignment.center,
    //   ),
    //   title: Text(
    //     'To Do',
    //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    //   ),
    //   subtitle: Text('10 task'),
    // );
  }

  StreamBuilder<QuerySnapshot<Object?>> homeListProject(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection('projects').get().asStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.hasData) {
          if (snapshot.data!.docs.length == 0) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [Text('No Project')],
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              ProjectModel? projectModel =
                  ProjectModel.fromMap(snapshot.data!.docs[index].data());
              print(' qwe ${snapshot.data!.docs.length} ');
              return SingleChildScrollView(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed('/ListProject');
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    margin: EdgeInsets.only(right: 10),
                    height: 160,
                    width: 160,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '${projectModel.taskArray!.length} Task',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          projectModel.title ?? '',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          getFormatedMonthYear(projectModel.createdAt),
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        Container(
                          width: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/avatar.png'),
                                      fit: BoxFit.contain),
                                ),
                              ),
                              Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/avatar.png'),
                                      fit: BoxFit.contain),
                                ),
                              ),
                              Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/avatar.png'),
                                      fit: BoxFit.contain),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: colors[index],
                    ),
                  ),
                ),
              );
            },
          );
        }
        return Center(
          child: new CircularProgressIndicator(),
        );
      },
    );
  }
}
