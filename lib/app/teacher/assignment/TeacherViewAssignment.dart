import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class ViewAssignment extends StatefulWidget {
  final DocumentSnapshot document;
  final String code;
  const ViewAssignment(this.document, this.code);
  @override
  _ViewAssignmentState createState() => _ViewAssignmentState();
}

class _ViewAssignmentState extends State<ViewAssignment> {
  var files, date, data;
  FirebaseStorage storage = FirebaseStorage.instance;

  void openFile(index) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File downloadToFile = File('${appDocDir.path}/${files[index].toString()}');

    try {
      DownloadTask task = storage
          .ref('${widget.code}/general/${files[index].toString()}')
          .writeToFile(downloadToFile);
      task.snapshotEvents.listen((event) {
        if (event.state.toString() == "TaskState.success") {}
      });
      await task;
    } catch (e) {
      print(e);
    }
    OpenFile.open('${appDocDir.path}/${files[index].toString()}');
  }

  adjustText(String text) {
    if (text.length > 45) {
      return text.substring(0, 45) + "...";
    }
    return text;
  }

  @override
  void initState() {
    super.initState();
    data = widget.document.data();
    files = data["files"];
    date = data['created at'].toDate();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.black12,
        child: Flexible(
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
              itemCount: files.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                        child: Text(
                          data["edited"] == true
                              ? ("Edited at:")
                              : ("Created at:"),
                          style: GoogleFonts.sourceSansPro(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                        child: Text(
                          date.toString(),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                        child: Text(
                          'Marks:',
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
                        child: Text(
                          data["marks"].toString() + " marks",
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                        child: Text(
                          'Description:',
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
                        child: Text(
                          data["description"].toString(),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10.0),
                        child: Text(
                          'Deadline of assignment: ',
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
                        child: Text(
                          data["due date"].toDate().toString(),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10.0),
                        child: Text(
                          'Attachments: ',
                          style: GoogleFonts.sourceSansPro(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return Container(
                  margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          openFile(index - 1);
                        },
                        child: Card(
                          elevation: 0.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          shadowColor: Colors.white,
                          child: Container(
                            margin: EdgeInsets.all(12.0),
                            child: Text(
                              adjustText(files[index - 1].toString()),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
