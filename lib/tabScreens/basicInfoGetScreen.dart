import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualclass/services/fStoreCollection.dart';

import '../constants.dart';

class BasicinfoGetScreen extends StatefulWidget {
  @override
  _BasicinfoGetScreenState createState() => _BasicinfoGetScreenState();
}

class _BasicinfoGetScreenState extends State<BasicinfoGetScreen> {
  String _name, _email, _location, _skill;

  FirebaseUser user;

  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();
  TextEditingController skillController = new TextEditingController();

  getPofile(String uid) async {
    var fireStore = Firestore.instance;
    DocumentSnapshot dsn =
        await fireStore.collection('users').document(uid).get();
    return dsn;
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      body: FutureBuilder(
        future: getPofile(user.uid),
        builder: (_, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            // ignore: missing_return
            return Center(
              child: Text('Loading ....'),
            );
          } else {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Icon(
                              Icons.account_circle,
                              color: PrimaryColor,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: nameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15.0),
                                  ),
                                ),
                                hintText: snapShot.data['name'],
                                helperText: 'Name',
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Icon(
                              Icons.email,
                              color: PrimaryColor,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15.0),
                                  ),
                                ),
                                hintText: snapShot.data['email'],
                                helperText: 'Email',
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Icon(
                              Icons.location_on,
                              color: PrimaryColor,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: locationController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15.0),
                                  ),
                                ),
                                hintText: snapShot.data['location'],
                                helperText: 'Location',
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Icon(
                              Icons.view_compact,
                              color: PrimaryColor,
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: skillController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15.0),
                                  ),
                                ),
                                hintText: snapShot.data['skill'],
                                helperText: 'Skill',
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        _name = nameController.text;
                        _email = emailController.text;
                        _location = locationController.text;
                        _skill = skillController.text;

                        if (_name == null)
                          _name = snapShot.data['name'].toString();
                        if (_email == null)
                          _email = snapShot.data['email'].toString();
                        if (_location == null)
                          _location = snapShot.data['location'].toString();
                        if (_skill == null)
                          _skill = snapShot.data['skill'].toString();

                        if (_name.isEmpty ||
                            _email.isEmpty ||
                            _location.isEmpty ||
                            _skill.isEmpty) {
                          showDialog(
                              context: context,
                              child: Dialog(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text('Provide All Information '),
                                ),
                              ));
                        } else {
                          new DbUserCollection(user.uid)
                              .updateBasicUserData(
                                  _name, _email, _location, _skill, user.uid)
                              .then((onValue) {
                            showAlertDialog(context);
                          });
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 80),
                        padding:
                            EdgeInsets.symmetric(horizontal: 26, vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: PrimaryColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              " Update",
                              style:
                                  Theme.of(context).textTheme.button.copyWith(
                                        color: Colors.black,
                                      ),
                            ),
                            SizedBox(width: 20),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("profile Updated"),
      content: Text('Thanks For Sharing Your Data'),
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
}
