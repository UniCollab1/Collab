import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class TeacherNoticePage extends StatefulWidget {
  TeacherNoticePage(this.data, this.code);
  final dynamic data;
  final String code;
  @override
  _TeacherNoticePageState createState() => _TeacherNoticePageState();
}

class _TeacherNoticePageState extends State<TeacherNoticePage> {
  var files, date;
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
    files = widget.data["files"];
    date = widget.data["created at"].toDate().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        middle: Text('Notice: ${widget.data['title']}'),
      ),
      body: Container(
        color: Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
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
                              widget.data["edited"] == true
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
                              widget.data["description"].toString(),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10.0),
                            child: Text(
                              'Deadline of notice: ',
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
                              widget.data["due date"].toDate().toString(),
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
            )
          ],
        ),
      ),
    );
  }
}
