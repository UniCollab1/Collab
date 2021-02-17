import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:unicollab/app/student/home/studentSubject.dart';
import 'package:unicollab/services/firestore_service.dart';

class JoinDialog extends StatefulWidget {
  @override
  _JoinDialogState createState() => _JoinDialogState();
}

class _JoinDialogState extends State<JoinDialog> {
  var _code = TextEditingController();

  Future<void> _joinClass() async {
    var fireStore = Provider.of<FireStoreService>(context, listen: false);
    try {
      var event = await fireStore.doesClassExist(code: _code.text);
      if (event.exists) {
        var users = await fireStore.getUsers(code: _code.text);
        var studentOf = users.data()['student of'];
        if (studentOf.contains(_code.text)) {
          //already joined
          var data = await fireStore.getClass(code: _code.text);
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (_) => StudentHome(data)),
          );
/*          var title = "Already joined a class",
              message = "Looks like you are already joined the class.";
          showCupertinoModalPopup(
              context: context,
              builder: (context) => DisplayAlertDialog(title, message));*/
        } else {
          await fireStore.joinClass(code: _code.text);
        }
      } else {
        //class does not exist at all
        var title = "Class does'nt exist",
            message =
                "Try to reach your teacher for correct class code because provided class doesn't exist.";
        showCupertinoModalPopup(
            context: context,
            builder: (context) => DisplayAlertDialog(title, message));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: CupertinoNavigationBarBackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          middle: Text(
            'Join a class',
            style: GoogleFonts.sourceSansPro(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          trailing: TextButton(
            onPressed: () {
              _joinClass();
              //Navigator.pop(context);
            },
            child: Icon(CupertinoIcons.paperplane),
          ),
        ),
        child: Container(
          margin: EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(10.0),
                child: Text(
                  'Enter the code given by your teacher',
                  style: GoogleFonts.sourceSansPro(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: CupertinoTextField(
                  controller: _code,
                  placeholder: 'Class code',
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DisplayAlertDialog extends StatelessWidget {
  const DisplayAlertDialog(this.title, this.message);
  final String title, message;
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        CupertinoDialogAction(
          child: Text('OK'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
