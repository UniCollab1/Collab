import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unicollab/app/student/home/cardview.dart';
import 'package:unicollab/services/firestore_service.dart';

class NoticeHome extends StatefulWidget {
  final dynamic data;
  const NoticeHome(this.data);
  @override
  _NoticeHomeState createState() => _NoticeHomeState();
}

class _NoticeHomeState extends State<NoticeHome> {
  var fireStore = FirebaseFirestore.instance;

  getData() {
    var lol = Provider.of<FireStoreService>(context, listen: false);
    var data = lol.getSubjectData(code: widget.data['class code']);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            CupertinoSliverNavigationBar(
              largeTitle: Text(widget.data['subject']),
              middle: Text(widget.data['title']),
              leading: CupertinoNavigationBarBackButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ].toList();
        },
        body: Container(
          color: Colors.black12,
          padding: EdgeInsets.all(5.0),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: getData(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CupertinoActivityIndicator(),
                    );
                  } else {
                    return Flexible(
                      child: ListView(
                        children:
                            snapshot.data.docs.map((DocumentSnapshot document) {
                          var data = document.data();
                          if (data['type'] == 1) {
                            return NoticeCard(
                                document, widget.data['class code']);
                          }
                          return null;
                        }).toList(),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
