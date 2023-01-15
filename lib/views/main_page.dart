import 'package:flutter/material.dart';

import 'account_page.dart';
import 'home_page.dart';
import 'my_task_page.dart';
import 'news_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> _children = [
    const HomePage(),
    const MyTaskPage(),
    const NewsPage(),
    const AccountPage()
  ];
  int selectedItem = 0;

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentPage = const HomePage();

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: _children[selectedItem],
    //   bottomNavigationBar: BottomNavBar(),
    // );

    return Scaffold(
      body: PageStorage(bucket: bucket, child: currentPage),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MaterialButtonCustom(_children[0], Icons.home, 0, 'Home'),
                    MaterialButtonCustom(
                        _children[1], Icons.event_note, 1, 'My Task'),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MaterialButtonCustom(
                        _children[2], Icons.mark_unread_chat_alt, 2, 'News'),
                    MaterialButtonCustom(
                        _children[3], Icons.person, 3, 'Account'),
                  ],
                ),
              ],
            ),
          )),
    );
  }

  MaterialButton MaterialButtonCustom(
      addressPage, IconData iconName, int num, String namePage) {
    return MaterialButton(
      minWidth: 40,
      onPressed: () {
        setState(() {
          currentPage = addressPage;
          selectedItem = num;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconName,
            color: selectedItem == num ? Colors.blue : Colors.grey,
          ),
          Text(
            namePage,
            style: TextStyle(
              color: selectedItem == num ? Colors.blue : Colors.grey,
            ),
          )
        ],
      ),
    );
  }

  // // Theme BottomNavBar() {
  // //   return Theme(
  // //     data: ThemeData(),
  // //     child: Container(
  // //       decoration: BoxDecoration(
  // //         color: Colors.white,
  // //         borderRadius: BorderRadius.circular(10),
  // //         boxShadow: [
  // //           BoxShadow(
  // //             color: Colors.grey.withOpacity(0.8),
  // //             spreadRadius: 2,
  // //             blurRadius: 5,
  // //             offset: const Offset(0, 2), // changes position of shadow
  // //           ),
  // //         ],
  // //       ),
  // //       child: BottomNavigationBar(
  // //         items: [
  // //           BottomNavItem('Home', Icon(Icons.home)),
  // //           BottomNavItem('News', Icon(Icons.feed)),
  // //           BottomNavItem('Account', Icon(Icons.account_circle)),
  // //         ],
  // //         currentIndex: selectedItem,
  // //         onTap: _onTap,
  // //       ),
  // //     ),
  // //   );
  // // }

  // BottomNavigationBarItem BottomNavItem(String addressPage, Icon iconName) {
  //   return BottomNavigationBarItem(
  //     icon: iconName,
  //     label: addressPage,
  //   );
  // }

  // _onTap(int index) {
  //   setState(() {
  //     selectedItem = index;
  //   });
  // }
}
