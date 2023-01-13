import 'package:flutter/material.dart';

import 'account_page.dart';
import 'home_page.dart';
import 'news_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<Widget> _children = [HomePage(), NewsPage(), AccountPage()];
  int selectedItem = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _children[selectedItem], bottomNavigationBar: BottomNavBar());
  }

  Theme BottomNavBar() {
    return Theme(
      data: ThemeData(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: [
            BottomNavItem('Home', Icon(Icons.home)),
            BottomNavItem('News', Icon(Icons.feed)),
            BottomNavItem('Account', Icon(Icons.account_circle)),
          ],
          currentIndex: selectedItem,
          onTap: _onTap,
        ),
      ),
    );
  }

  BottomNavigationBarItem BottomNavItem(String addressPage, Icon iconName) {
    return BottomNavigationBarItem(
      icon: iconName,
      label: addressPage,
    );
  }

  _onTap(int index) {
    setState(() {
      selectedItem = index;
    });
  }
}
