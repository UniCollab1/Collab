import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unicollab/app/recent/create.dart';
import 'package:unicollab/app/recent/join.dart';
import 'package:unicollab/app/recent/student.dart';
import 'package:unicollab/app/recent/teacher.dart';

class Recent extends StatefulWidget {
  @override
  _RecentState createState() => _RecentState();
}

class _RecentState extends State<Recent> {
  var _children = {
    0: Container(
      child: Text("I'm student"),
    ),
    1: Container(
      child: Text("I'm teacher"),
    )
  };
  final _body = [
    Student(),
    Teacher(),
  ];
  int _sliding = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: CupertinoSlidingSegmentedControl<int>(
            onValueChanged: (value) {
              setState(() {
                _sliding = value;
              });
            },
            groupValue: _sliding,
            children: _children,
          ),
          trailing: GestureDetector(
            child: Icon(CupertinoIcons.plus),
            onTap: () {
              showCupertinoModalPopup(
                  context: context, builder: (context) => CreateOrJoinDialog());
            },
          ),
        ),
        child: Center(
          child: _body[_sliding],
        ),
      ),
    );
  }
}

class CreateOrJoinDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: Text("I want to"),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (_) => JoinDialog(), fullscreenDialog: true),
            );
          },
          child: Text('Join a class'),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (_) => CreateDialog(), fullscreenDialog: true),
            );
          },
          child: Text('Create a class'),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(
          'Cancel',
          style: TextStyle(color: Colors.red),
        ),
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (_) => JoinDialog(), fullscreenDialog: true),
          );
        },
      ),
    );
  }
}
