import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:virtualclass/modals/skillModal.dart';
import 'package:virtualclass/services/fStoreCollection.dart';

import '../constants.dart';

class CreateSkills extends StatefulWidget {
  @override
  _CreateSkillsState createState() => _CreateSkillsState();
}

class _CreateSkillsState extends State<CreateSkills> {
  String skillName, about, fess;
  String whoCanPostToSkill, whoCanSeePost, whoCanSeMessage;

  TextEditingController skillNameController = new TextEditingController();
  TextEditingController aboutController = new TextEditingController();
  TextEditingController feesController = new TextEditingController();
  FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Skill'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Icon(
                      Icons.computer,
                      color: PrimaryColor,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: skillNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                        hintText: "Skill Name",
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.public, color: PrimaryColor),
                  Spacer(),
                  DropdownButton(
                    hint: Text('Who Can  Post to skill'),
                    value: whoCanPostToSkill,
                    items: <DropdownMenuItem>[
                      DropdownMenuItem(
                        child: Text('Members'),
                        value: 'Members',
                      ),
                      DropdownMenuItem(
                        child: Text('Everyone'),
                        value: 'Everyone',
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        whoCanPostToSkill = value;
                        FocusScope.of(context).unfocus();
                      });
                    },
                  ),
                  Spacer(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.public, color: PrimaryColor),
                  Spacer(),
                  DropdownButton(
                    hint: Text('Who Can See Post'),
                    value: whoCanSeePost,
                    items: <DropdownMenuItem>[
                      DropdownMenuItem(
                        child: Text('Members'),
                        value: 'Members',
                      ),
                      DropdownMenuItem(
                        child: Text('Everyone'),
                        value: 'Everyone',
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        whoCanSeePost = value;
                        FocusScope.of(context).unfocus();
                      });
                    },
                  ),
                  Spacer(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.message, color: PrimaryColor),
                  Spacer(),
                  DropdownButton(
                    hint: Text('Who Can Send Messages'),
                    value: whoCanSeMessage,
                    items: <DropdownMenuItem>[
                      DropdownMenuItem(
                        child: Text('Members'),
                        value: 'Members',
                      ),
                      DropdownMenuItem(
                        child: Text('Everyone'),
                        value: 'Everyone',
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        whoCanSeMessage = value;
                        FocusScope.of(context).unfocus();
                      });
                    },
                  ),
                  Spacer(),
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
                      Icons.attach_money,
                      color: PrimaryColor,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: feesController,
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                          hintText: "INR 0",
                          helperText: 'Joining Fees'),
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
                  Expanded(
                    child: TextFormField(
                      controller: aboutController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                        hintText: "About ",
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    ),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                about = aboutController.text;
                skillName = skillNameController.text;
                fess = feesController.text;

                if (about.isEmpty ||
                    skillName.isEmpty ||
                    whoCanPostToSkill.isEmpty ||
                    whoCanSeePost.isEmpty ||
                    whoCanSeMessage.isEmpty ||
                    fess.isEmpty) {
                  showDialog(
                      context: context,
                      child: AlertDialog(
                          title: Text(
                        'Fill All Fields',
                        style: TextStyle(color: Colors.black38, fontSize: 16),
                      )));
                } else {
                  Skill _skill = new Skill();
                  _skill.userId = user.uid;
                  _skill.about = about;
                  _skill.skillName = skillName;
                  _skill.whoCanSeePost = whoCanSeePost;
                  _skill.whoCanSendMessage = whoCanSeMessage;
                  _skill.whoCnaPost = whoCanPostToSkill;
                  _skill.price = double.parse(fess);
                  _skill.skillId = new Uuid().v1();
                  new DbUserCollection(user.uid)
                      .makeNewSkill(_skill)
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
                      " Create Skill",
                      style: Theme.of(context).textTheme.button.copyWith(
                            color: Colors.black,
                          ),
                    ),
                    SizedBox(width: 20),
                    Icon(
                      Icons.computer,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 70,
            )
          ],
        ),
      ),
    );
  }

  void showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("See Skill"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Skill Created"),
      content: Text('Thanks For Creating  Skill'),
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
