import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unicollab/services/firestore_service.dart';

class CreateDialog extends StatefulWidget {
  @override
  _CreateDialogState createState() => _CreateDialogState();
}

class _CreateDialogState extends State<CreateDialog> {
  var _title = TextEditingController(),
      _subject = TextEditingController(),
      _shortName = TextEditingController(),
      _description = TextEditingController();

  Future<void> _createClass(context) async {
    try {
      var fireStore = Provider.of<FireStoreService>(context, listen: false);
      await fireStore.addNewClass(
          title: _title.text,
          subject: _subject.text,
          shortName: _shortName.text,
          description: _description.text);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: CupertinoNavigationBarBackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          middle: Text('Create a class'),
          trailing: TextButton(
            onPressed: () => {_createClass(context), Navigator.pop(context)},
            child: Icon(CupertinoIcons.paperplane),
          ),
        ),
        child: Container(
          margin: EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 50.0),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(10.0),
                child: CupertinoTextField(
                  controller: _title,
                  placeholder: 'Class title',
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: CupertinoTextField(
                  controller: _subject,
                  placeholder: 'Subject',
                  textCapitalization: TextCapitalization.words,
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: CupertinoTextField(
                  controller: _shortName,
                  placeholder: 'Short name for subject',
                  textCapitalization: TextCapitalization.words,
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: CupertinoTextField(
                  controller: _description,
                  placeholder: 'Description',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
