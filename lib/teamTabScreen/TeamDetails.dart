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

class TeamDetails extends StatefulWidget {
  TeamDetails({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _TeamDetailsState createState() => _TeamDetailsState();
}

class _TeamDetailsState extends State<TeamDetails> {
  Future<File> imageFile;
  bool _showProgress = false;
  FirebaseUser user;
  List<String> _members = [];

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
      print(" Team Picture uploaded");
    });
    new DbUserCollection(user.uid)
        .updateTeamsPicture(fileName, uuid, widget.title)
        .then((onValue) {
      setState(() {
        _showProgress = false;
      });
      showAlertDialog(context, 'Picture Updated',
          'Teams Background Picture Updated Successfully');
    });
  }

  void showAlertDialog(BuildContext context, String title, String mess) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(mess),
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

  getTeamDetails(String teamIdId) async {
    var fireStore = Firestore.instance;
    DocumentSnapshot dsn =
        await fireStore.collection('teams').document(teamIdId).get();
    for (var uid in dsn.data['members'].keys) {
      _members.add(uid);
    }
    return dsn;
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);
    final snackBar = SnackBar(content: Text('You Left Team'));
    return Scaffold(
      body: FutureBuilder(
        future: getTeamDetails(widget.title),
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
                            snapShot.data['team_image'],
                            height: 150,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                        _showProgress
                            ? Center(child: CircularProgressIndicator())
                            : Container(),
                        snapShot.data['user_id'] == user.uid
                            ? Positioned(
                                bottom: 30,
                                right: 30,
                                child: GestureDetector(
                                  onTap: () {
                                    pickImageFromGallery();
                                  },
                                  child: Icon(
                                    Icons.add_a_photo,
                                    color: PrimaryColor,
                                  ),
                                ),
                              )
                            : _members.contains(user.uid)
                                ? Positioned(
                                    bottom: 30,
                                    right: 30,
                                    child: RaisedButton(
                                      color: PrimaryColor,
                                      child: Text('Leave'),
                                      onPressed: () {
                                        new DbUserCollection(user.uid)
                                            .updateUserLeavedTeams(
                                                snapShot.data['team_id'])
                                            .then((onValue) {
                                          Scaffold.of(context)
                                              .showSnackBar(snackBar);
                                          Future.delayed(
                                                  Duration(milliseconds: 500))
                                              .then((onValue) {
                                            Navigator.pop(context);
                                          });
                                          //Navigator.pop(context);
                                        });
                                      },
                                    ),
                                  )
                                : Positioned(
                                    bottom: 30,
                                    right: 30,
                                    child: RaisedButton(
                                      color: PrimaryColor,
                                      child: Text('Join'),
                                      onPressed: () {
                                        new DbUserCollection(user.uid)
                                            .makeTeamMember(
                                                snapShot.data['team_id'])
                                            .then((onValue) {
                                          setState(() {});
                                          showAlertDialog(
                                              context,
                                              'Congratulations !!',
                                              'You Are Now member of  ${snapShot.data['team_name']}');
                                        });
                                      },
                                    ),
                                  ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    snapShot.data['team_name'],
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
                  Text(
                    '   Members : ' +
                        snapShot.data['members'].length.toString() +
                        '    ',
                    style: TextStyle(fontSize: 15, color: Colors.blue),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '   Hosted By : ' +
                        snapShot.data['host'].toString() +
                        '    ',
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(
                    height: 10,
                  ),
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
