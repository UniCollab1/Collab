import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:unicollab/app/teacher/home/teacherSubject.dart';
import 'package:unicollab/services/firestore_service.dart';

class Teacher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var teacherSubject = Provider.of<FireStoreService>(context);
    return Container(
      color: Colors.black12,
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
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (_) => TeacherHome(data)),
                    );
                  },
                  child: new Card(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    shadowColor: Colors.white,
                    child: new GridTile(
                      footer: Container(
                        margin: EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Text(
                              data['title'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),
                            Text(
                              data['subject'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                              ),
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
