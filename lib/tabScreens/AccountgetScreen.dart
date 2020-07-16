import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualclass/services/authentication.dart';
import 'package:virtualclass/services/fStoreCollection.dart';

import '../constants.dart';

class AccountgetScreen extends StatefulWidget {
  @override
  _AccountgetScreenState createState() => _AccountgetScreenState();
}

class _AccountgetScreenState extends State<AccountgetScreen> {
  bool _obsCureText = true;
  bool _isPrivate = false;
  FirebaseUser user;
  Auth _auth = new Auth();
  bool CheckCurrentPassValid = true;
  String _currentpass, _newpass, _newPass2;
  TextEditingController _currentPassController = new TextEditingController();
  TextEditingController _newPassController = new TextEditingController();
  TextEditingController _newtPassController2 = new TextEditingController();

  void _toggle() {
    setState(() {
      _obsCureText = !_obsCureText;
    });
  }

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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Private Account"),
                  Checkbox(
                    activeColor: PrimaryColor,
                    value: _isPrivate,
                    onChanged: (bool value) {
                      setState(() {
                        _isPrivate = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () {
                  if (_isPrivate) {
                    new DbUserCollection(user.uid)
                        .makeAccountPrivate()
                        .then((onValue) {
                      showAlertDialog(context, 'Your Account Is Private Now');
                    });
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 80),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
              Divider(
                thickness: 2.0,
              ),
              SizedBox(
                height: 20,
              ),
              Text('Password Update'),
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
                        controller: _currentPassController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                          hintText: 'Current Password',
                          // helperText: 'Current Password',
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Icon(
                        Icons.lock,
                        color: PrimaryColor,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        obscureText: _obsCureText,
                        controller: _newPassController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                          hintText: "New Password",
                        ),
                      ),
                    ),
                    IconButton(
                      icon: _obsCureText
                          ? Icon(
                              Icons.visibility_off,
                              color: PrimaryColor,
                            )
                          : Icon(
                              Icons.visibility,
                              color: PrimaryColor,
                            ),
                      onPressed: _toggle,
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Icon(
                        Icons.lock,
                        color: PrimaryColor,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        obscureText: _obsCureText,
                        controller: _newtPassController2,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                          hintText: "Conform New  Password",
                        ),
                      ),
                    ),
                    IconButton(
                      icon: _obsCureText
                          ? Icon(
                              Icons.visibility_off,
                              color: PrimaryColor,
                            )
                          : Icon(
                              Icons.visibility,
                              color: PrimaryColor,
                            ),
                      onPressed: _toggle,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () async {
                  _currentpass = _currentPassController.text;
                  _newpass = _newPassController.text;
                  _newPass2 = _newtPassController2.text;

                  if (_currentpass.isEmpty ||
                      _newpass.isEmpty ||
                      _newPass2.isEmpty) {
                    showDialog(
                        context: context,
                        child: Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text('provide All info'),
                          ),
                        ));
                  } else {
                    if (_newPass2 == _newpass) {
                      _changePassward(_newpass);
                    } else {
                      showDialog(
                          context: context,
                          child: Dialog(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text('Password Not Matched'),
                            ),
                          ));
                    }
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 80),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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

  void showAlertDialog(BuildContext context, String textmess) {
    Widget okButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(textmess),
      content: Text('Thank You .. '),
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

  void _changePassward(String newpass) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    //Pass in the password to updatePassword.
    user.updatePassword(newpass).then((_) {
      showAlertDialog(context, 'Password Changed Successful');
    }).catchError((error) {
      showAlertDialog(context, 'Error Changing Password');
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
  }
}
