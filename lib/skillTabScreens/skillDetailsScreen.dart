import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:virtualclass/constants.dart';
import 'package:virtualclass/services/fStoreCollection.dart';

class SkillDetailsScreen extends StatefulWidget {
  SkillDetailsScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SkillDetailsScreenState createState() => _SkillDetailsScreenState();
}

class _SkillDetailsScreenState extends State<SkillDetailsScreen> {
  Future<File> imageFile;
  bool _showProgress = false;
  FirebaseUser user;

  getskillsDetails(String skillId) async {
    var fireStore = Firestore.instance;
    DocumentSnapshot dsn =
        await fireStore.collection('skills').document(skillId).get();
    for (var uid in dsn.data['members'].keys) {
      _members.add(uid);
    }
    return dsn;
  }

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
      print(" Skill Picture uploaded");
    });
    new DbUserCollection(user.uid)
        .updateSkillPicture(fileName, uuid, widget.title)
        .then((onValue) {
      setState(() {
        _showProgress = false;
      });
      showAlertDialog(context, 'Picture Changed',
          'BackGround sKill Image Changed Successfully');
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

  List<String> _members = [];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snackBar = SnackBar(content: Text('Leaved Skill'));
    user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      body: FutureBuilder(
        future: getskillsDetails(widget.title),
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
                            snapShot.data['skill_image'],
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
                                      child: Text(
                                        'Leave',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        new DbUserCollection(user.uid)
                                            .updateUserLeavedSkills(
                                                snapShot.data['skill_id'])
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
                                      child: Text(
                                        'Join',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        new DbUserCollection(user.uid)
                                            .makeSkillsMember(
                                                snapShot.data['skill_id'])
                                            .then((onValue) {
                                          setState(() {});
                                          showAlertDialog(
                                              context,
                                              'Congratulations !!',
                                              'You Are Now member Of  ${snapShot.data['skill_name']}');
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
                    snapShot.data['skill_name'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
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
                  Text(
                    'Members :' + snapShot.data['members'].length.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.blue),
                  ),
                  ListTile(
                    leading: Icon(Icons.date_range),
                    title: Text('since'),
                    subtitle: Text(snapShot.data['date_created']
                            .toDate()
                            .day
                            .toString() +
                        '/' +
                        snapShot.data['date_created']
                            .toDate()
                            .month
                            .toString() +
                        '/' +
                        snapShot.data['date_created'].toDate().year.toString()),
                  ),
                  Text('Hosted By  : ' + snapShot.data['host'].toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                      )),
                  RatingBar(
                    initialRating: 3,
                    minRating: 5,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.green,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
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
