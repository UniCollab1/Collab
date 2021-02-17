import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

GlobalKey<_SubmitAssignmentState> globalKey = GlobalKey();

class SubmitAssignment extends StatefulWidget {
  final DocumentSnapshot document;
  final String code;
  const SubmitAssignment(this.document, this.code);
  @override
  _SubmitAssignmentState createState() => _SubmitAssignmentState();
}

class _SubmitAssignmentState extends State<SubmitAssignment> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return null;
  }
}
