import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manager_apps/data/models/user_arguments_model.dart';
import 'package:manager_apps/presentations/features/root/widgets/home_project_item.dart';
import 'package:manager_apps/presentations/features/root/widgets/home_task_item.dart';
import 'package:manager_apps/presentations/view_models/feedItem/feedItem_model.dart';
import 'package:manager_apps/presentations/view_models/project/project_model.dart';
import 'package:manager_apps/core/const/app_constants.dart';
import 'package:manager_apps/core/repositories/get_data_collection_doc.dart';
import 'package:manager_apps/core/repositories/list_state.dart';

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
        leading: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: getDataDoc(currentUser.uid, "users"),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            var document = snapshot.data?.data();
            var image = document!["profileImage"];
            return InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/EditProfile',
                    arguments: UserArguments(userModel: document));
              },
              child: Container(
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
              ),
            );
          },
        ),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(
                future: getListNotification(_auth.currentUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  if (snapshot.hasData) {
                    List? listNotification = snapshot.data;

                    List? isChecked = listNotification?.map(
                      (e) {
                        FeedItemModel feedItemModel = FeedItemModel.fromMap(e);
                        return feedItemModel.isChecked;
                      },
                    ).toList();
                    List? isCheckedTrue = isChecked?.where(
                      (element) {
                        return element == true;
                      },
                    ).toList();

                    return InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed('/Notification',
                            arguments: listNotification);
                      },
                      child: Stack(
                        alignment: AlignmentDirectional.topCenter,
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                right: Dimension.padding.medium),
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
                          isCheckedTrue!.isNotEmpty
                              ? Positioned(
                                  top: 0,
                                  right: 6,
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.red,
                                      child: Text(
                                        '${isCheckedTrue.length}',
                                        style: const TextStyle(
                                            fontSize: 10, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )
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
            int? taskLength = snapshot.data?.length;
            return HomeTaskItem(
              toIndex: index,
              toNameList: nameList,
              toTaskLength: taskLength,
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

              return HomeProjectItem(
                projectModel: projectModel,
                toListUsers: listUsers,
                toFilterState: filterState,
                toIndex: index,
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

  Future<List?> getNumTasks(String? query) async {
    final result = await FirebaseFirestore.instance
        .collection('tasks')
        .where('state', isEqualTo: query)
        .get();

    filterState = result.docs.map((e) => e.data()).toList();

    return filterState;
  }

  Future<List?> getListNotification(String? query) async {
    List? filterFeed;

    final result = await FirebaseFirestore.instance
        .collection('feedItems')
        .where('userId', isEqualTo: query)
        .get();

    filterFeed = result.docs.map((e) => e.data()).toList();
    return filterFeed;
  }
}
