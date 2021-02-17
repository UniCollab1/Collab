import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unicollab/app/teacher/assignment/TeacherSubmittedAssignment.dart';
import 'package:unicollab/app/teacher/assignment/TeacherViewAssignment.dart';

class AssignmentPage extends StatefulWidget {
  final DocumentSnapshot document;
  final String code;
  const AssignmentPage(this.document, this.code);
  @override
  _AssignmentPageState createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  int _sliding = 0;
  var _children = {
    0: Container(
      child: Text("Instructions"),
    ),
    1: Container(
      child: Text("Students' work"),
    )
  };

  Widget _body() {
    var lol = [
      ViewAssignment(widget.document, widget.code),
      SubmittedAssignment(widget.document, widget.code),
    ];
    return lol[_sliding];
  }

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
        ),
        child: _body(),
      ),
    );
  }
}
