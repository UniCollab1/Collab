import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:unicollab/CreateMaterial.dart';
import 'package:unicollab/EditMaterial.dart';
import 'package:unicollab/services/firestore_service.dart';

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
              trailing: IconButton(
                icon: Icon(CupertinoIcons.plus),
                onPressed: () {
                  showCupertinoModalPopup(
                      context: context,
                      builder: (context) => TeacherCreate(widget.data));
                },
              ),
            )
          ].toList();
        },
        body: Container(
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
                      child: TextButton(
                        onPressed: () {
                          /*
                          setState(() {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (_) => EditMaterial(
                                      document, widget.data['class code']),
                                  fullscreenDialog: true),
                            );
                          });*/
                        },
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(CupertinoIcons.book),
                                title: Text(
                                    'Material: ' + document.data()["title"]),
                                subtitle: Text(
                                    adjustText(document.data()["description"])),
                                isThreeLine: true,
                                trailing: TextButton(
                                  onPressed: () {
                                    showCupertinoModalPopup(
                                        context: context,
                                        builder: (context) => ContextMenu(
                                            document,
                                            widget.data['class code']));
                                  },
                                  child: Icon(CupertinoIcons.ellipsis_vertical),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
          onPressed: () {},
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
          onPressed: () {},
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

class ContextMenu extends StatelessWidget {
  const ContextMenu(this.data, this.code);
  final DocumentSnapshot data;
  final String code;
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
                  builder: (_) => EditMaterial(data, code),
                  fullscreenDialog: true),
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

class THome extends StatefulWidget {
  final dynamic code;
  const THome(this.code);
  @override
  _THomeState createState() => _THomeState();
}

class _THomeState extends State<THome> {
  FirebaseAuth auth = FirebaseAuth.instance;
  var fireStore = FirebaseFirestore.instance;

  getData() {
    var lol = fireStore
        .collection('classes')
        .doc(widget.code["class code"])
        .collection('general')
        .snapshots();
    return lol;
  }

  getNotice() {
    var lol = fireStore
        .collection('classes')
        .doc(widget.code["class code"])
        .collection('notice')
        .snapshots();
    return lol;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Center(child: Text(widget.code['subject'])),
                Center(child: Text(widget.code['class code'])),
              ],
            ),
          ),
          Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: getData(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      semanticsLabel: 'loading your Material',
                    ),
                    // ignore: missing_return
                  );
                } else {
                  return SizedBox(
                    height: 250.0,
                    child: ListView(
                      children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                        return Container(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        EditMaterial(
                                            document,
                                            widget.code["class code"]
                                                .toString()),
                                  ),
                                );
                              });
                            },
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.description),
                                    title: Text('Material: ' +
                                        document.data()["title"]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
              },
            ),
          ),
          Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: getNotice(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data.docs;
                  var now = DateTime.now().millisecondsSinceEpoch / 1000;
                  for (var d in data) {
                    if (now > d.data()['time'].seconds) {
                      fireStore
                          .collection('classes')
                          .doc(widget.code['class code'])
                          .collection('notice')
                          .doc(d.id)
                          .delete();
                    }
                  }
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      semanticsLabel: 'loading your Notice',
                    ),
                    // ignore: missing_return
                  );
                } else {
                  return SizedBox(
                    height: 200.0,
                    child: ListView(
                      children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                        return Container(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        EditNotice(
                                            document.data(),
                                            document.id,
                                            widget.code["class code"]
                                                .toString()),
                                  ),
                                );
                              });
                            },
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.description),
                                    title: Text(
                                        'Notice: ' + document.data()["title"]),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
