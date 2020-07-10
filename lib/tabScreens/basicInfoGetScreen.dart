import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualclass/modals/userModal.dart';
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

  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      body: Container(
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
                        color: kPrimaryColor,
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
                          // hintText: _myusers.name,
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
                        color: kPrimaryColor,
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
                          // hintText: _myusers.name,
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
                        color: kPrimaryColor,
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
                          // hintText: _myusers.name,
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
                        color: kPrimaryColor,
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
                          // hintText: _myusers.name,
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
                    //Check Internet Connection
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
                  padding: EdgeInsets.symmetric(horizontal: 26, vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: kPrimaryColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        " Update",
                        style: Theme.of(context).textTheme.button.copyWith(
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
