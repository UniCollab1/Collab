import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:unicollab/services/firebase_auth_service.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  Future<void> _signOut(context) async {
    try {
      var auth = Provider.of<FirebaseAuthService>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context, listen: false);
    print(user.photoURL);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Your Profile'),
        trailing: TextButton(
          onPressed: () => _signOut(context),
          child: Text(
            'Sign Out',
            style: GoogleFonts.sourceSansPro(color: Colors.red),
          ),
        ),
      ),
      child: Container(
        margin: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    user.photoURL != null ? NetworkImage(user.photoURL) : null,
              ),
            ),
            SizedBox(
              height: 35,
            ),
            Container(
              margin: EdgeInsets.all(5.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "First name",
                  filled: true,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(5.0),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  labelText: "Last name",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(5.0),
              child: TextField(
                decoration: InputDecoration(
                  enabled: false,
                  labelText: "Email",
                  filled: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
