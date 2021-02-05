import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'file:///C:/Users/shrey/StudioProjects/Collab/lib/app/profile/profile.dart';

class DrawerMain extends StatefulWidget {
  @override
  _DrawerMainState createState() => _DrawerMainState();
}

class _DrawerMainState extends State<DrawerMain> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool mode = false;
  File _image;
  String imageurl =
      "https://firebasestorage.googleapis.com/v0/b/collab-627c8.appspot.com/o/images%2Fdownload.jpg?alt=media&token=a4f8c09d-af58-45f2-a34c-5c05eb007334";

  void initState() {
    super.initState();
    getImage();
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  void getImage() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    _image = File(appDocDir.path + '/' + auth.currentUser.email);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: EdgeInsets.zero,
            child: DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 35.0,
                    backgroundImage: (_image != null)
                        ? FileImage(_image)
                        : NetworkImage(
                            imageurl,
                          ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'someone',
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    auth.currentUser.email,
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
            ),
            title: Text(
              'Home',
            ),
            onTap: () {
              Navigator.popUntil(context, ModalRoute.withName("homepage"));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.account_circle,
            ),
            title: Text(
              'Your Profile',
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage()),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
            ),
            title: Text(
              'Setting',
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.feedback,
            ),
            title: Text(
              'Feedback',
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
            ),
            title: Text(
              'Logout',
            ),
            onTap: () {
              signOut();
              Navigator.popUntil(context, ModalRoute.withName("login"));
            },
          ),
        ],
      ),
    );
  }
}
