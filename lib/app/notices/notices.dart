import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:unicollab/app/notices/NoticesHome.dart';
import 'package:unicollab/services/firestore_service.dart';

class Notice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var fireStore = Provider.of<FireStoreService>(context, listen: false);
    return SafeArea(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text(
            'Notices',
          ),
        ),
        child: Container(
          color: Colors.black12,
          child: StreamBuilder(
            stream: fireStore.getStudentSubject(),
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
                          CupertinoPageRoute(builder: (_) => NoticeHome(data)),
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
                                  data['created by'],
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
        ),
      ),
    );
  }
}
