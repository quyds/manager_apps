import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manager_apps/core/extensions/custom_style.dart';
import 'package:manager_apps/models/project/project_model.dart';
import 'package:manager_apps/views/main_page.dart';

import '../const/app_constants.dart';
import '../core/extensions/date_format.dart';
import '../core/repositories/get_data_collection_doc.dart';
import '../core/repositories/list_state.dart';
import '../models/user/user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List filterState = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    var screenSizeWidth = MediaQuery.of(context).size.width;

    User? currentUser = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight:
            screenSizeWidth < 600 ? screenSizeWidth / 3 : screenSizeWidth / 5,
        title: Container(
          margin: EdgeInsets.only(left: Dimension.padding.small),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: getDataDoc(currentUser!.uid, "users"),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    var document = snapshot.data;
                    return Text(
                      document!["name"] ?? 'Your Name',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    );
                  }),
              const SizedBox(
                height: 5,
              ),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: getDataDoc(currentUser.uid, "users"),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    var document = snapshot.data;
                    return Text(
                      document!["level"] ?? 'Your Level',
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    );
                  }),
            ],
          ),
        ),
        leadingWidth:
            screenSizeWidth < 600 ? screenSizeWidth / 4.5 : screenSizeWidth / 8,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed('/EditProfile');
          },
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: getDataDoc(currentUser.uid, "users"),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var document = snapshot.data;
                var image = document!["profileImage"];
                return Container(
                  margin: EdgeInsets.only(left: Dimension.padding.medium),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.white),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.35),
                        spreadRadius: 5,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      )
                    ],
                    shape: BoxShape.circle,
                    image: image == null
                        ? const DecorationImage(
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
                margin: EdgeInsets.only(right: Dimension.padding.medium),
                height: screenSizeWidth < 600
                    ? screenSizeWidth / 9
                    : screenSizeWidth / 17,
                width: screenSizeWidth < 600
                    ? screenSizeWidth / 9
                    : screenSizeWidth / 17,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.shade900,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
              ),
            ],
          )
        ],
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(
              left: Dimension.padding.medium, right: Dimension.padding.medium),
          child: Column(
            children: <Widget>[
              homeTitle(context, 'Dự án hiện tại', '', null),
              SizedBox(
                height: screenSizeWidth < 600
                    ? screenSizeWidth / 2.5
                    : screenSizeWidth / 5,
                child: homeListProject(context, screenSizeWidth),
              ),
              homeTitle(context, 'Công việc', '', null),
              SizedBox(
                height: 220,
                child: homeListTask(context, screenSizeWidth),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container homeTitle(BuildContext context, String title, String route, icons) {
    return Container(
      margin: EdgeInsets.only(top: Dimension.padding.small),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          IconButton(
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
        ],
      ),
    );
  }

  homeListTask(BuildContext context, screenSizeWidth) {
    return ListView.builder(
      itemCount: list.length - 1,
      itemBuilder: (context, index) {
        return FutureBuilder(
          future: getNumTasks(list[index]),
          builder: (context, snapshot) {
            List nameList = [];
            for (int i = 0; i < list[index].length; i++) {
              if (list[index] == 'To Do') {
                nameList.add('Thực hiện');
              }
              if (list[index] == 'In Progress') {
                nameList.add('Đang thực hiện');
              }
              if (list[index] == 'Done') {
                nameList.add('Hoàn thành');
              }
              if (list[index] == 'Remove') {
                nameList.add('Đã xóa');
              }
            }

            return ListTile(
              onTap: () {
                Navigator.of(context)
                    .pushNamed('/ListTask', arguments: list[index]);
              },
              leading: Container(
                height: screenSizeWidth < 600
                    ? screenSizeWidth / 9
                    : screenSizeWidth / 17,
                width: screenSizeWidth < 600
                    ? screenSizeWidth / 9
                    : screenSizeWidth / 17,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.shade900,
                ),
                alignment: Alignment.center,
                child: Icon(
                  icons[index],
                  color: Colors.white,
                ),
              ),
              title: Text(
                nameList[index],
                style: CustomTextStyle.titleOfTextStyle,
              ),
              subtitle: Text(
                '${snapshot.data?.length} Công việc',
                style: CustomTextStyle.subOfTextStyle,
              ),
            );
          },
        );
      },
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> homeListProject(
      BuildContext context, screenSizeWidth) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collection('projects').get().asStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.hasData) {
          if (snapshot.data!.docs.isEmpty) {
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
              List? listUsers = [];
              if (projectModel.employeeArray!.isNotEmpty) {
                if (projectModel.employeeArray!.length >= 3) {
                  for (int i = 0; i < 3; i++) {
                    listUsers.add(projectModel.employeeArray![i]);
                  }
                } else {
                  for (int i = 0; i < projectModel.employeeArray!.length; i++) {
                    listUsers.add(projectModel.employeeArray![i]);
                  }
                }
              }

              return SingleChildScrollView(
                child: GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    _showPopupMenu(details.globalPosition, projectModel.id);
                  },
                  onTap: () {
                    Navigator.of(context).pushNamed('/ListProject');
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                        left: Dimension.padding.small,
                        right: Dimension.padding.small),
                    margin: EdgeInsets.only(right: Dimension.padding.small),
                    height: screenSizeWidth < 600
                        ? screenSizeWidth / 2.5
                        : screenSizeWidth / 5,
                    width: screenSizeWidth < 600
                        ? screenSizeWidth / 2.5
                        : screenSizeWidth / 5,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Dimension.radius.gigantic),
                      color: colors[index],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '${projectModel.taskArray!.length} Công việc',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                        Text(
                          projectModel.title ?? '',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Tháng ${getFormatedMonthYear(projectModel.createdAt)}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white),
                        ),
                        listUsers.isNotEmpty
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: listUsers.map((e) {
                                      return FutureBuilder(
                                        future: getUserById(e),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            return Text(
                                                snapshot.error.toString());
                                          }
                                          if (snapshot.hasData) {
                                            String? image =
                                                snapshot.data?.profileImage;
                                            return Container(
                                              width: 25,
                                              height: 25,
                                              margin: EdgeInsets.only(
                                                  left: Dimension.padding.tiny,
                                                  right:
                                                      Dimension.padding.tiny),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: image == null
                                                    ? const DecorationImage(
                                                        image: AssetImage(
                                                            'assets/images/avatar.png'),
                                                        fit: BoxFit.cover)
                                                    : DecorationImage(
                                                        image:
                                                            NetworkImage(image),
                                                        fit: BoxFit.cover,
                                                      ),
                                              ),
                                            );
                                          } else {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                        },
                                      );
                                    }).toList(),
                                  ),
                                  projectModel.employeeArray!.length > 3
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              '+${projectModel.employeeArray!.length - 3} ',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white),
                                            )
                                          ],
                                        )
                                      : Row(),
                                ],
                              )
                            : Row(),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<UserModel?> getUserById(String id) async {
    final doc = FirebaseFirestore.instance.collection("users").doc(id);

    final snapShot = await doc.get();

    if (snapShot.exists) {
      return UserModel.fromMap(snapShot.data()!);
    }
    return null;
  }

  Future<List?> getNumTasks(String? query) async {
    final result = await FirebaseFirestore.instance
        .collection('tasks')
        .where('state', isEqualTo: query)
        .get();

    filterState = result.docs.map((e) => e.data()).toList();

    return filterState;
  }

  void _showPopupMenu(Offset offset, String? id) async {
    double left = offset.dx;
    double top = offset.dy;

    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, left, top),
      items: [
        const PopupMenuItem(
          value: 1,
          child: Text("Edit"),
        ),
        const PopupMenuItem(
          value: 2,
          child: Text("Delete"),
        ),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value == 1) {
        Navigator.of(context).pushNamed('/FormaaProject').then((value) {
          setState(() {});
        });
      }
      if (value == 2) {
        showAlertDialog(context, id);
      }
    });
  }

  showAlertDialog(BuildContext context, id) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Continue"),
      onPressed: () {
        final docUser =
            FirebaseFirestore.instance.collection('projects').doc(id);
        docUser.delete();
        const snackBar = SnackBar(
          content: Text(
            'Đã xóa thành công!',
          ),
          behavior: SnackBarBehavior.floating,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context).pushNamed('/Main');
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Thông báo"),
      content: const Text("Bạn có chắc chắn muốn xóa không?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
