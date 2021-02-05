import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app/profile/profile.dart';
import 'assignments.dart';
import 'notices.dart';
import 'recents.dart';
import 'resources.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(items: [
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.home), label: "Recent"),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.book), label: "Resources"),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.bell), label: "Notice"),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.doc_chart), label: "Assignment"),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.person_crop_square),
                label: "Profile"),
          ]),
          tabBuilder: (context, index) {
            switch (index) {
              case 0:
                return CupertinoTabView(
                    builder: (BuildContext context) => Recent());
                break;
              case 1:
                return CupertinoTabView(
                    builder: (BuildContext context) => Resource());
                break;
              case 2:
                return CupertinoTabView(
                    builder: (BuildContext context) => Notice());
                break;
              case 2:
                return CupertinoTabView(
                    builder: (BuildContext context) => Assignment());
                break;
              default:
                return CupertinoTabView(
                    builder: (BuildContext context) => EditProfilePage());
                break;
            }
          },
        ),
        body: Recent(),
      ),
    );
  }
}
