import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:unicollab/Join.dart';
import 'package:unicollab/create.dart';
import 'package:unicollab/services/firestore_service.dart';
import 'package:unicollab/teacherSubject.dart';

class Recent extends StatefulWidget {
  @override
  _RecentState createState() => _RecentState();
}

class _RecentState extends State<Recent> {
  var _children = {
    0: Container(
      margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
      child: Text("I'm student"),
    ),
    1: Container(
      margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
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
          middle: CupertinoSegmentedControl<int>(
            onValueChanged: (value) {
              setState(() {
                _sliding = value;
              });
            },
            groupValue: _sliding,
            children: _children,
          ),
          trailing: TextButton(
            child: Icon(CupertinoIcons.plus),
            onPressed: () {
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

class Student extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var studentSubject = Provider.of<FireStoreService>(context);
    return Container(
      child: StreamBuilder(
        stream: studentSubject.getStudentSubject(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final subject = snapshot.data.docs;
            //print(subject);
            if (subject == null || subject.length == 0) {
              return Center(
                child: Text('No classroom'),
              );
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: subject.length,
              itemBuilder: (context, index) {
                var data = subject[index];
                return new Card(
                  child: new GridTile(
                    footer: new Text(data['created by']),
                    child: new CircleAvatar(
                      child: Text(data['title']),
                      radius: 25.0,
                    ),
                  ),
                );
              },
            );
          }
          return Scaffold(
            body: Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        },
      ),
    );
  }
}

class Teacher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var teacherSubject = Provider.of<FireStoreService>(context);
    return Container(
      child: StreamBuilder(
        stream: teacherSubject.getTeacherSubject(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final subject = snapshot.data.docs;
            if (subject == null || subject.length == 0) {
              return Center(
                child: Text('No classroom'),
              );
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: subject.length,
              itemBuilder: (context, index) {
                var data = subject[index];
                return TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (_) => TeacherHome(data)),
                    );
                  },
                  child: new Card(
                    shadowColor: Colors.white,
                    child: new GridTile(
                      footer: Container(
                        margin: EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Text(
                              data['title'],
                            ),
                            Text(
                              data['created by'],
                            ),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.all(10.0),
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: new Text(
                              data['short name'],
                              style: GoogleFonts.sourceSansPro(
                                fontSize: 80.0,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Scaffold(
            body: Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        },
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
          onPressed: () {},
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

/*FirebaseAuth auth = FirebaseAuth.instance;
var fireStore = FirebaseFirestore.instance;*/
/*

class Recent extends StatefulWidget {
  @override
  _RecentState createState() => _RecentState();
}

class _RecentState extends State<Recent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Classes joined by you',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListPage('join'),
          TextButton(
            onPressed: () {},
            child: Text(
              'Classes created by you',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListPage('create'),
        ],
      ),
    );
  }
}

class ListPage extends StatefulWidget {
  final String which;
  const ListPage(this.which);
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<TextButton> l1 = [];
  getClass() {
    var lol;
    if (widget.which == 'join') {
      lol = fireStore
          .collection('classes')
          .where("students", arrayContains: auth.currentUser.email)
          .snapshots();
    } else {
      lol = fireStore
          .collection('classes')
          .where("teachers", arrayContains: auth.currentUser.email)
          .snapshots();
    }
    return lol;
  }

  TextButton textButton(data) {
    return TextButton(
      onPressed: () async {
        if (widget.which == 'join') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => StudentHome(
                data.data(),
              ),
            ),
          );
        } else {
          // print(data.data());
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => TeacherHome(
                data.data(),
              ),
            ),
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(5.0),
            width: 130.0,
            height: 130.0,
            color: Colors.grey,
          ),
          Container(
            width: 130.0,
            child: Text(
              data.data()['subject'],
              maxLines: 1,
            ),
          ),
          Container(
            width: 130.0,
            child: Text(
              data.data()['created by'],
              maxLines: 1,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: getClass(),
        builder: (context, snapshot) {
          l1 = [];
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                semanticsLabel: 'loading your classes',
              ),
            );
          } else {
            final allData = snapshot.data.docs;
            for (var data in allData) {
              var tb = textButton(data);
              l1.add(tb);
            }
            return SizedBox(
              height: 200.0,
              child: Container(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: l1.length,
                  itemBuilder: (context, index) {
                    return l1[index];
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class RecentFloat extends StatefulWidget {
  @override
  _RecentFloatState createState() => _RecentFloatState();
}

class _RecentFloatState extends State<RecentFloat> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: Text('I want to'),
              children: [
                ListTile(
                  leading: Icon(Icons.create),
                  title: Text('Create a class'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => CreateDialog(),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.add),
                  title: Text('Join a class'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => JoinDialog(),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
      child: Icon(Icons.add),
    );
  }
}
*/
