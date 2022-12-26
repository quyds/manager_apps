import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedItem = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          toolbarHeight: 100,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Trần Ngọc Quý',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Email: quy@gmail.com',
                style: TextStyle(fontSize: 14),
              )
            ],
          ),
          leading: Container(
            padding: EdgeInsets.only(left: 10),
            child: CircleAvatar(
              child: CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage('assets/images/user_icon.jpg')),
            ),
          ),
          backgroundColor: Colors.purple,
        ),
      ),
      body: new Column(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Tiện ích',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            margin: EdgeInsets.only(top: 10, left: 10, bottom: 10),
          ),
          Container(
            child: GridView.count(
              crossAxisCount: 4,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed('/Task');
                  },
                  child: Container(
                    color: Colors.green,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.home,
                          color: Colors.white,
                        ),
                        Text("Home", style: TextStyle(color: Colors.white))
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.green,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.account_circle,
                        color: Colors.white,
                      ),
                      Text("Account", style: TextStyle(color: Colors.white))
                    ],
                  ),
                ),
                Container(
                  color: Colors.green,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.message,
                        color: Colors.white,
                      ),
                      Text("Messages", style: TextStyle(color: Colors.white))
                    ],
                  ),
                ),
                Container(
                  color: Colors.green,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.list_alt,
                        color: Colors.white,
                      ),
                      Text("Orders", style: TextStyle(color: Colors.white))
                    ],
                  ),
                ),
              ],
              padding: EdgeInsets.all(10),
              shrinkWrap: true,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
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
      bottomNavigationBar: BottomNavBar(),
    );
  }

  Theme BottomNavBar() {
    return Theme(
      data: ThemeData(canvasColor: Colors.grey.shade300),
      child: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: 'Call',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Camera',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedItem,
        onTap: (index) {
          setState(() {
            selectedItem = index;
          });
        },
      ),
    );
  }
}
