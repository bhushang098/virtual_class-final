import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualclass/modals/userModal.dart';
import 'package:virtualclass/services/fStoreCollection.dart';

import '../constants.dart';

class RoleGetScreen extends StatefulWidget {
  @override
  _RoleGetScreenState createState() => _RoleGetScreenState();
}

class _RoleGetScreenState extends State<RoleGetScreen> {
  String _role, _gender;
  FirebaseUser user;
  Myusers _user;
  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);
    new DbUserCollection(user.uid).getUserDeta(user.uid).then((onValue) {
      _user = onValue;
    });
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.group, color: PrimaryColor),
                    Spacer(),
                    DropdownButton(
                      hint: Text('              Role           '),
                      value: _role,
                      items: <DropdownMenuItem>[
                        DropdownMenuItem(
                          child: Text('Student'),
                          value: 'Student',
                        ),
                        DropdownMenuItem(
                          child: Text('Professor'),
                          value: 'Professor',
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _role = value;
                          FocusScope.of(context).unfocus();
                        });
                      },
                    ),
                    Spacer(),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () {
                  if (_role == null) {
                    showDialog(
                        context: context,
                        child: Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(' Select An Category '),
                          ),
                        ));
                  } else {
                    new DbUserCollection(user.uid)
                        .makeRoleUpdateRequest(user.email, _user.name)
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
                    color: PrimaryColor,
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
      title: Text("Request Made"),
      content:
          Text('Thanks For Your Interest Your Request will get Approved soon'),
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
