import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:random_string/random_string.dart';

class FireStoreService {
  FireStoreService({@required this.email}) : assert(email != null);

  final String email;
  final fireStore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  Stream<QuerySnapshot> getTeacherSubject() {
    var snapshots = fireStore
        .collection('classes')
        .where("teachers", arrayContains: email)
        .snapshots();
    return snapshots;
  }

  Stream<QuerySnapshot> getStudentSubject() {
    var snapshots = fireStore
        .collection('classes')
        .where("students", arrayContains: email)
        .snapshots();
    return snapshots;
  }

  Future<void> addUserToFireStore() async {
    await FirebaseFirestore.instance.collection('users').doc(email).update({
      'teacher of': [],
      'student of': [],
    });
  }

  Future<void> addNewClass(
      {@required String title,
      @required String subject,
      @required String shortName,
      @required String description}) async {
    var code = randomAlphaNumeric(7);
    try {
      while (true) {
        var event = await fireStore
            .collection('classes')
            .where("code", isEqualTo: code)
            .get();
        if (event.docs.isNotEmpty) {
          code = randomAlphaNumeric(7);
        } else {
          break;
        }
      }
    } catch (e) {
      print(e);
    }

    await fireStore.collection('classes').doc(code).set({
      'class code': code,
      'title': title,
      'subject': subject,
      'short name': shortName,
      'description': description,
      'teachers': [email],
      'students': [],
      'created by': email,
      'created at': DateTime.now(),
    }).then((value) => (print('Class added successfully!')));
    await fireStore.collection('users').doc(email).update({
      'teacher of': [code]
    }).then((value) => print("Users successfully updated!"));
  }

  Future<void> createMaterial(
      {@required String code,
      @required String title,
      String description,
      List<PlatformFile> files}) async {
    var id;
    try {
      await fireStore
          .collection('classes')
          .doc(code)
          .collection('general')
          .add({
        'title': title,
        'description': description,
        'created at': DateTime.now(),
        'files': [],
      }).then((value) => id = value.id);
    } catch (e) {
      print(e);
    }
    if (files != null) {
      files.forEach((element) async {
        print(element.path);
        File file = File(element.path);
        try {
          await fireStore
              .collection('classes')
              .doc(code)
              .collection('general')
              .doc(id)
              .update({
            'files': FieldValue.arrayUnion([element.name])
          });
          await storage.ref(code + "/general/" + element.name).putFile(file);
        } catch (e) {
          print(e);
        }
      });
    }
  }

  Future<void> editMaterial(
      {@required String code,
      @required String id,
      @required String title,
      String description,
      List<PlatformFile> files,
      List<String> temp}) async {
    try {
      await fireStore
          .collection('classes')
          .doc(code)
          .collection('general')
          .doc(id)
          .update({
        'title': title,
        'description': description,
        'files': temp,
        'created at': DateTime.now(),
      });
    } catch (e) {
      print(e);
    }
    if (files != null) {
      files.forEach((element) async {
        print("uploading from " + element.path);
        File file = File(element.path);
        try {
          if (temp.contains(element.name)) {
            await storage.ref(code + "/general/" + element.name).putFile(file);
          }
        } catch (e) {
          print(e);
        }
      });
    }
  }

  Stream<QuerySnapshot> getSubjectData({@required String code}) {
    var lol = fireStore
        .collection('classes')
        .doc(code)
        .collection('general')
        .snapshots();
    return lol;
  }

  Future<void> joinClass({@required String code}) async {
    try {
      await fireStore.collection('users').doc(email).update({
        'student of': FieldValue.arrayUnion([code])
      });
      await fireStore.collection('classes').doc(code).update({
        'students': FieldValue.arrayUnion([email])
      });
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentSnapshot> doesClassExist({@required String code}) async {
    return await fireStore.collection('classes').doc(code).get();
  }
}
