import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unicollab/services/firestore_service.dart';

import '../assignments/assignments.dart';
import '../notices/notices.dart';
import '../profile/profile.dart';
import '../recent/recents.dart';
import '../resources/resources.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _array = [
    Recent(),
    Resource(),
    Notice(),
    Assignment(),
    EditProfilePage(),
  ];
  var ind = 0;
  _addUserToFireStore() async {
    try {
      final fireStore = Provider.of<FireStoreService>(context, listen: false);
      await fireStore.addUserToFireStore();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    _addUserToFireStore();
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(items: [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: "Recent",
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.book),
              label: "Resources",
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.bell),
              label: "Notice",
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.doc_chart),
              label: "Assignment",
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_crop_square),
              label: "Profile",
            ),
          ]),
          tabBuilder: (context, index) {
            ind = index;
            return CupertinoTabView(
                builder: (BuildContext context) => _array[index]);
          },
        ),
        body: Resource(),
      ),
    );
  }
}
