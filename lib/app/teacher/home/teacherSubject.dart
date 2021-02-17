import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:unicollab/app/teacher/assignment/CreateAssignment.dart';
import 'package:unicollab/app/teacher/home/cardview.dart';
import 'package:unicollab/app/teacher/notice/CreateNotice.dart';
import 'package:unicollab/services/firestore_service.dart';

import 'file:///C:/Users/shrey/StudioProjects/Collab/lib/app/teacher/material/CreateMaterial.dart';

class TeacherHome extends StatefulWidget {
  final dynamic data;
  const TeacherHome(this.data);
  @override
  _TeacherHomeState createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {
  Stream<QuerySnapshot> _getData() {
    var fireStore = Provider.of<FireStoreService>(context);
    var data;
    try {
      data = fireStore.getSubjectData(code: widget.data['class code']);
    } catch (e) {
      print(e);
    }
    return data;
  }

  adjustText(String text) {
    if (text.length > 200) {
      return text.substring(0, 200) + "...";
    }
    return text;
  }

  Widget cardView(DocumentSnapshot document) {
    var _cardView = [
      MaterialCard(document, widget.data['class code']),
      NoticeCard(document, widget.data['class code']),
      AssignmentCard(document, widget.data['class code'])
    ];
    return _cardView[document.data()['type']];
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            CupertinoSliverNavigationBar(
              largeTitle: Text(widget.data['subject']),
              middle: TextButton(
                onPressed: () {
                  Clipboard.setData(
                      new ClipboardData(text: widget.data['class code']));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.data['class code']),
                    Icon(CupertinoIcons.doc_on_clipboard)
                  ],
                ),
              ),
              leading: CupertinoNavigationBarBackButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              trailing: GestureDetector(
                child: Icon(CupertinoIcons.plus),
                onTap: () {
                  showCupertinoModalPopup(
                      context: context,
                      builder: (context) => TeacherCreate(widget.data));
                },
              ),
            )
          ].toList();
        },
        body: Container(
          color: Colors.black12,
          padding: EdgeInsets.all(5.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: _getData(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              }
              return Expanded(
                child: ListView(
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return Container(
                      child: cardView(document),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class TeacherCreate extends StatelessWidget {
  const TeacherCreate(this.data);
  final dynamic data;
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
                  builder: (_) => CreateNotice(data), fullscreenDialog: true),
            );
          },
          child: Text('Create a notice'),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (_) => CreateMaterial(data), fullscreenDialog: true),
            );
          },
          child: Text('Create a material'),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (_) => CreateAssignment(data),
                  fullscreenDialog: true),
            );
          },
          child: Text('Create a assignment'),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(
          'Cancel',
          style: TextStyle(color: Colors.red),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
