import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:virtualclass/services/fStoreCollection.dart';

import '../constants.dart';

class ClassDetails extends StatefulWidget {
  ClassDetails({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _ClassDetailsState createState() => _ClassDetailsState();
}

class _ClassDetailsState extends State<ClassDetails> {
  Future<File> imageFile;
  bool _showProgress = false;
  FirebaseUser user;

  pickImageFromGallery() {
    setState(() {
      imageFile = ImagePicker.pickImage(source: ImageSource.gallery);
      if (imageFile != null) {
        uploadPic(context);
      } else {
        setState(() {
          _showProgress = false;
        });
      }
    });
  }

  Future uploadPic(BuildContext context) async {
    _showProgress = true;
    String fileName;
    File img;
    Uuid uuid = new Uuid();
    await imageFile.then((onValue) {
      fileName = uuid.v1() + onValue.path.split('/').last;
      print('>>>>>>>>>>> File NAMe' + fileName);
      img = onValue;
    });
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('images/').child(fileName);

    final StorageUploadTask uploadTask = storageReference.putFile(img);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    setState(() {
      print("Class  Picture uploaded");
    });
    new DbUserCollection(user.uid)
        .updateclassPicture(fileName, uuid, widget.title)
        .then((onValue) {
      setState(() {
        _showProgress = false;
      });
      showAlertDialog(context);
    });
  }

  void showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(" Class Image Updated "),
      content: Text('Updated Successfully'),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  getClassesDetails(String skillId) async {
    var fireStore = Firestore.instance;
    DocumentSnapshot dsn =
        await fireStore.collection('classes').document(skillId).get();
    return dsn;
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      body: FutureBuilder(
        future: getClassesDetails(widget.title),
        builder: (_, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            // ignore: missing_return
            return Center(
              child: Text('Loading ....'),
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Card(
                    elevation: 4,
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            snapShot.data['class_image'],
                            fit: BoxFit.fill,
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                        Positioned(
                          bottom: 30,
                          right: 30,
                          child: InkWell(
                            splashColor: PrimaryColor,
                            onTap: () {
                              pickImageFromGallery();
                            },
                            child: Icon(
                              Icons.add_a_photo,
                              color: PrimaryColor,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    snapShot.data['class_name'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '   Location : ' +
                        snapShot.data['location'].toString() +
                        '    ',
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('   Fees : ' + snapShot.data['fees'].toString() + '    ',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          backgroundColor: PrimaryColor)),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading: Icon(Icons.date_range),
                    title: Text(snapShot.data['start_date']
                            .toDate()
                            .day
                            .toString() +
                        '/' +
                        snapShot.data['start_date'].toDate().month.toString() +
                        '/' +
                        snapShot.data['start_date'].toDate().year.toString()),
                  ),
                  snapShot.data['is_daily'] == null
                      ? ListTile(
                          leading: Icon(Icons.access_time),
                          title: Text('At : ' +
                              snapShot.data['timing'].toDate().toString()),
                        )
                      : Text('Hosted By  : ' + snapShot.data['host'].toString(),
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                          )),
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text(snapShot.data['about']),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
