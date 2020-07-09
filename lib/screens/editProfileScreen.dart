import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualclass/constants.dart';
import 'package:virtualclass/modals/userModal.dart';
import 'package:virtualclass/services/fStoreCollection.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Myusers _myusers;
  String _name, _email, _location, _skill, _role;
  bool _isPrivateAccount = false;

  FirebaseUser user;
  bool _gender;
  List<String> _intrests;
  bool _graphicDesign = false,
      _computerNetwork = false,
      _AI = false,
      _python = false;

  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();
  TextEditingController skillController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    _myusers = ModalRoute.of(context).settings.arguments;
    user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Your Profile'),
      ),
      body: SingleChildScrollView(
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
                        hintText: _myusers.name,
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
                      Icons.mail,
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
                        hintText: _myusers.email,
                        helperText: 'E_Mail',
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
                        hintText: 'location',
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
                        hintText: 'Skill',
                        helperText: 'Skill',
                      ),
                    ),
                  )
                ],
              ),
            ),
            OutlineButton(
              child: Text('Update'),
              color: kPrimaryColor,
              onPressed: () {
                _name = nameController.text;
                _email = emailController.text;
                _location = locationController.text;
                _skill = skillController.text;

                if (_name.isEmpty) _name = _myusers.name;
                if (_email.isEmpty) _email = _myusers.email;

                if (_name.isEmpty ||
                    _email.isEmpty ||
                    _location.isEmpty ||
                    _skill.isEmpty) {
                  showDialog(
                      context: context,
                      child: Dialog(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text('Provide All details'),
                        ),
                      ));
                } else {
                  //ToDo : Upadte profile
                  new DbUserCollection(user.uid)
                      .updateuserData1(
                          _name, _email, _location, _skill, user.uid)
                      .then((onValue) {
                    showAlertDialog(context);
                  });
                }
              },
            ),
            Divider(
              height: 5,
              thickness: 3,
            ),
            SizedBox(height: 10),
            Text('Interests'),
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
                Text("Artificial intelligence "),
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
                Text("Computer Network"),
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
                Text("Programing In Python"),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Programing In Python"),
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
            OutlineButton(
              child: Text('Update'),
              color: kPrimaryColor,
              onPressed: () {
                //ToDo : Upadte profile
              },
            ),
            Divider(
              height: 5,
              thickness: 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Private Account"),
                Checkbox(
                  activeColor: kPrimaryColor,
                  value: _isPrivateAccount,
                  onChanged: (bool value) {
                    setState(() {
                      _isPrivateAccount = value;
                    });
                  },
                ),
              ],
            ),
            OutlineButton(
              child: Text('Update'),
              color: kPrimaryColor,
              onPressed: () {
                //ToDo : Upadte profile
              },
            ),
            Divider(
              height: 5,
              thickness: 3,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.group, color: kPrimaryColor),
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
            OutlineButton(
              child: Text('Update'),
              color: kPrimaryColor,
              onPressed: () {
                //ToDo : Upadte profile
              },
            ),
            Divider(
              height: 5,
              thickness: 3,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.group, color: kPrimaryColor),
                  Spacer(),
                  DropdownButton(
                    hint: Text('              Gender           '),
                    value: _gender,
                    items: <DropdownMenuItem>[
                      DropdownMenuItem(
                        child: Text('Male'),
                        value: true,
                      ),
                      DropdownMenuItem(
                        child: Text('Female'),
                        value: false,
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                        FocusScope.of(context).unfocus();
                      });
                    },
                  ),
                  Spacer(),
                ],
              ),
            ),
            OutlineButton(
              child: Text('Update'),
              color: kPrimaryColor,
              onPressed: () {
                //ToDo : Upadte profile
              },
            ),
          ],
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
