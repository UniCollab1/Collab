import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unicollab/app/student/home/cardview.dart';
import 'package:unicollab/services/firestore_service.dart';

class StudentHome extends StatefulWidget {
  final dynamic data;
  const StudentHome(this.data);
  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  var fireStore = FirebaseFirestore.instance;

  Widget cardView(DocumentSnapshot document) {
    var _cardView = [
      MaterialCard(document, widget.data['class code']),
      NoticeCard(document, widget.data['class code']),
      AssignmentCard(document, widget.data['class code'])
    ];
    return _cardView[document.data()['type']];
  }

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
                          return cardView(document);
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
