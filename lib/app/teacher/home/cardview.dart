import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unicollab/app/student/material/StudentMaterialPage.dart';
import 'package:unicollab/app/teacher/assignment/EditAssignment.dart';
import 'package:unicollab/app/teacher/assignment/TeacherAssignmentPage.dart';
import 'package:unicollab/app/teacher/material/EditMaterial.dart';
import 'package:unicollab/app/teacher/notice/EditNotice.dart';
import 'package:unicollab/app/teacher/notice/TeacherNoticePage.dart';

class MaterialCard extends StatelessWidget {
  MaterialCard(this.document, this.code);
  final String code;
  final DocumentSnapshot document;
  @override
  Widget build(BuildContext context) {
    var data = document.data();
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (_) => StudentMaterialPage(data, code)),
          );
        },
        onLongPress: () {
          showCupertinoModalPopup(
              context: context,
              builder: (context) => ContextMenu(document, code, 0));
        },
        child: Card(
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shadowColor: Colors.white,
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            leading: Icon(
              CupertinoIcons.book,
              size: 40.0,
            ),
            title: Text('Material: ' + data["title"]),
            subtitle: Text(
              data["description"],
              overflow: TextOverflow.ellipsis,
            ),
            trailing: GestureDetector(
              onTap: () {
                showCupertinoModalPopup(
                    context: context,
                    builder: (context) => ContextMenu(document, code, 0));
              },
              child: Icon(CupertinoIcons.ellipsis_vertical),
            ),
          ),
        ),
      ),
    );
  }
}

class NoticeCard extends StatelessWidget {
  NoticeCard(this.document, this.code);
  final String code;
  final DocumentSnapshot document;
  @override
  Widget build(BuildContext context) {
    var data = document.data();
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (_) => TeacherNoticePage(data, code)),
          );
        },
        onLongPress: () {
          showCupertinoModalPopup(
              context: context,
              builder: (context) => ContextMenu(document, code, 1));
        },
        child: Card(
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shadowColor: Colors.white,
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            leading: Icon(
              CupertinoIcons.bell,
              size: 40.0,
            ),
            title: Text('Notice: ' + data["title"]),
            isThreeLine: data["description"] != null ? true : false,
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data["description"],
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Deadline: " + data["due date"].toDate().toString(),
                ),
              ],
            ),
            trailing: GestureDetector(
              onTap: () {
                showCupertinoModalPopup(
                    context: context,
                    builder: (context) => ContextMenu(document, code, 1));
              },
              child: Icon(CupertinoIcons.ellipsis_vertical),
            ),
          ),
        ),
      ),
    );
  }
}

class AssignmentCard extends StatelessWidget {
  AssignmentCard(this.document, this.code);
  final String code;
  final DocumentSnapshot document;
  @override
  Widget build(BuildContext context) {
    var data = document.data();
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (_) => AssignmentPage(document, code)),
          );
        },
        onLongPress: () {
          showCupertinoModalPopup(
              context: context,
              builder: (context) => ContextMenu(document, code, 2));
        },
        child: Card(
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shadowColor: Colors.white,
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            leading: Icon(
              CupertinoIcons.doc_chart,
              size: 40.0,
            ),
            title: Text('Assignment: ' + data["title"]),
            isThreeLine: data["description"] != null ? true : false,
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data["description"],
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "Marks: " + data['marks'].toString() + " marks",
                ),
                Text(
                  "Deadline: " + data['due date'].toDate().toString(),
                ),
              ],
            ),
            trailing: GestureDetector(
              onTap: () {
                showCupertinoModalPopup(
                    context: context,
                    builder: (context) => ContextMenu(document, code, 2));
              },
              child: Icon(CupertinoIcons.ellipsis_vertical),
            ),
          ),
        ),
      ),
    );
  }
}

class ContextMenu extends StatelessWidget {
  const ContextMenu(this.data, this.code, this.type);
  final DocumentSnapshot data;
  final String code;
  final int type;

  Widget pushTo() {
    var _list = [
      EditMaterial(data, code),
      EditNotice(data, code),
      EditAssignment(data, code),
    ];
    return _list[type];
  }

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
                  builder: (_) => pushTo(), fullscreenDialog: true),
            );
          },
          child: Text('Edit'),
        ),
        CupertinoActionSheetAction(
          onPressed: () {},
          child: Text(
            'Delete',
            style: TextStyle(color: Colors.red),
          ),
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
