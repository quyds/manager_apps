import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../core/repositories/get_data_collection_doc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
                        return new CircularProgressIndicator();
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
                        return new CircularProgressIndicator();
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
                    return new CircularProgressIndicator();
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
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Project',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/FormProject');
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.deepPurple.shade900,
                      ),
                    ),
                  ),
                ],
              ),
              margin: EdgeInsets.only(top: 20, left: 10, bottom: 10),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              height: 160,
              child: ListView(
                // This next line does the trick.
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('/ListProject');
                    },
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '10 Task',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          Text(
                            'App Weather',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            'August 2022',
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
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.blue.shade900,
                      ),
                      width: 160.0,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '10 Task',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        Text(
                          'App Weather',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          'August 2022',
                          style: TextStyle(fontSize: 14, color: Colors.white),
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
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.pink.shade900,
                    ),
                    width: 160.0,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '10 Task',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        Text(
                          'App Weather',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          'August 2022',
                          style: TextStyle(fontSize: 14, color: Colors.white),
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
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.green.shade900,
                    ),
                    width: 160.0,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '10 Task',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        Text(
                          'App Weather',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          'August 2022',
                          style: TextStyle(fontSize: 14, color: Colors.white),
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
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.yellow.shade900,
                    ),
                    width: 160.0,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '10 Task',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                        Text(
                          'App Weather',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          'August 2022',
                          style: TextStyle(fontSize: 14, color: Colors.white),
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
                        )
                      ],
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.orange.shade900,
                    ),
                    width: 160.0,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'My Tasks',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('/CreateTask');
                            },
                            icon: Icon(
                              Icons.add,
                              color: Colors.deepPurple.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('10 task'),
                  ),
                  ListTile(
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
                        Icons.autorenew,
                        color: Colors.white,
                      ),
                      alignment: Alignment.center,
                    ),
                    title: Text(
                      'In Progress',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '10 task',
                      // style: TextStyle(fontSize: 14),
                    ),
                  ),
                  ListTile(
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
                        Icons.done,
                        color: Colors.white,
                      ),
                      alignment: Alignment.center,
                    ),
                    title: Text(
                      'Done',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('10 task',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade500)),
                  )
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Tài khoản',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              margin: EdgeInsets.only(top: 10, left: 10, bottom: 10),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Container(
                color: Colors.grey.shade100,
                child: const ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Đăng xuất',
                    textScaleFactor: 1.0,
                    style: TextStyle(color: Colors.black),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward,
                    color: Colors.black,
                  ),
                  selected: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
