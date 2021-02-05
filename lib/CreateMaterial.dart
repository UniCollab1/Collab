import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:unicollab/services/firestore_service.dart';

class CreateMaterial extends StatefulWidget {
  const CreateMaterial(this.data);
  final dynamic data;
  @override
  _CreateMaterialState createState() => _CreateMaterialState();
}

class _CreateMaterialState extends State<CreateMaterial> {
  var title = TextEditingController(), description = TextEditingController();
  List<PlatformFile> result = [];

  adjustText(String text) {
    if (text.length > 45) {
      return text.substring(0, 45) + "...";
    }
    return text;
  }

  Future<void> _createMaterial() async {
    var fireStore = Provider.of<FireStoreService>(context, listen: false);
    try {
      await fireStore.createMaterial(
          code: widget.data['class code'],
          title: title.text,
          description: description.text,
          files: result);
    } catch (e) {
      print(e);
    }
  }

  takeFile() async {
    FilePickerResult res =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    setState(() {
      if (res != null) {
        res.files.forEach((element) {
          result.add(element);
          print(element.path);
          print(element.name +
              " " +
              element.size.toString() +
              " " +
              element.extension);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        middle: Text('Create a class'),
        trailing: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => takeFile(),
              child: Icon(CupertinoIcons.paperclip),
            ),
            TextButton(
              onPressed: () {
                _createMaterial();
                Navigator.pop(context);
              },
              child: Icon(CupertinoIcons.paperplane),
            ),
          ],
        ),
      ),
      child: Container(
        margin: EdgeInsets.fromLTRB(10.0, 80.0, 10.0, 80.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: EdgeInsets.all(10.0),
              child: CupertinoTextField(
                autofocus: true,
                controller: title,
                placeholder: 'Title',
                textCapitalization: TextCapitalization.words,
              ),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              child: CupertinoTextField(
                controller: description,
                placeholder: 'Description',
                maxLines: null,
                minLines: null,
                expands: true,
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
            Flexible(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: result != null ? result.length : 0,
                    itemBuilder: (context, index) {
                      print(result[index].name + " " + result[index].path);
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Container(
                              margin: EdgeInsets.all(12.0),
                              child: Text(
                                  adjustText(result[index].name.toString())),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              print(index);
                              setState(() {
                                print('deleted');
                                result.removeAt(index);
                              });
                            },
                            child: Icon(CupertinoIcons.clear_circled),
                          ),
                        ],
                      );
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
