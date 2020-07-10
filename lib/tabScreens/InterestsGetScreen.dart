import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualclass/services/fStoreCollection.dart';

import '../constants.dart';

class InterestsGetScreen extends StatefulWidget {
  @override
  _InterestsGetScreenState createState() => _InterestsGetScreenState();
}

class _InterestsGetScreenState extends State<InterestsGetScreen> {
  bool _graphicDesign = false,
      _computerNetwork = false,
      _AI = false,
      _python = false;

  FirebaseUser user;
  List<String> _interests = [];
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
                  Text("Graphic Design"),
                  Checkbox(
                    activeColor: kPrimaryColor,
                    value: _graphicDesign,
                    onChanged: (bool value) {
                      setState(() {
                        _graphicDesign = value;
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Artificial Intelligence"),
                  Checkbox(
                    activeColor: kPrimaryColor,
                    value: _AI,
                    onChanged: (bool value) {
                      setState(() {
                        _AI = value;
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Computer Networking"),
                  Checkbox(
                    activeColor: kPrimaryColor,
                    value: _computerNetwork,
                    onChanged: (bool value) {
                      setState(() {
                        _computerNetwork = value;
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Python programing"),
                  Checkbox(
                    activeColor: kPrimaryColor,
                    value: _python,
                    onChanged: (bool value) {
                      setState(() {
                        _python = value;
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
                  print(_python);
                  print(_AI);
                  print(_computerNetwork);
                  print(_graphicDesign);

                  if (_python) _interests.add('Python Programing');
                  if (_AI) _interests.add('Artificial Intelligence');
                  if (_computerNetwork) _interests.add('Computer Networking');
                  if (_graphicDesign) _interests.add('Graphic Design');

                  new DbUserCollection(user.uid)
                      .updateUserInterests(_interests)
                      .then((onValue) {
                    showAlertDialog(context);
                  });
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
