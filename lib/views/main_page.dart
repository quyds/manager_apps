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
    var screenSizeWidth = MediaQuery.of(context).size.width;
    var screenSizeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: PageStorage(bucket: bucket, child: currentPage),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showPopupMenuAdd(screenSizeWidth, screenSizeHeight);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          child: SizedBox(
            height: screenSizeWidth < 600
                ? screenSizeWidth / 7
                : screenSizeWidth / 13,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MaterialButtonCustom(
                        _children[0], Icons.home, 0, 'Trang chủ'),
                    MaterialButtonCustom(
                        _children[1], Icons.group, 1, 'Nhân viên'),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MaterialButtonCustom(
                        _children[2], Icons.mark_unread_chat_alt, 2, 'Tin tức'),
                    MaterialButtonCustom(
                        _children[3], Icons.settings, 3, 'Cài đặt'),
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
      minWidth: 85,
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
                fontSize: 10),
          )
        ],
      ),
    );
  }

  void _showPopupMenuAdd(screenSizeWidth, screenSizeHeight) async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB((screenSizeWidth - 168) / 2,
          screenSizeHeight - 200, (screenSizeWidth - 168) / 2, 0),
      items: [
        const PopupMenuItem(value: 1, child: Text("Tạo dự án")),
        const PopupMenuItem(
          value: 2,
          child: Text("Tạo công việc"),
        ),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value == 1) {
        Navigator.of(context).pushNamed('/FormProject').then((value) {
          setState(() {});
        });
      }
      if (value == 2) {
        Navigator.of(context).pushNamed('/CreateTask').then((value) {
          setState(() {});
        });
      }
    });
  }
}
