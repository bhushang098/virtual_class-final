import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:virtualclass/constants.dart';
import 'package:virtualclass/modals/teamModal.dart';
import 'package:virtualclass/services/fStoreCollection.dart';

class GetTeamDetails extends StatefulWidget {
  @override
  _GetTeamDetailsState createState() => _GetTeamDetailsState();
}

class _GetTeamDetailsState extends State<GetTeamDetails> {
  String teamName, classLocation, about;
  String whoCanPostToTeam, whoCanSeePost, whoCanSeMessage;

  TextEditingController teamNameController = new TextEditingController();
  TextEditingController classLocationController = new TextEditingController();
  TextEditingController aboutController = new TextEditingController();
  FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Make New Team'),
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
                      Icons.group_add,
                      color: PrimaryColor,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: teamNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                        hintText: "Team Name",
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
                      Icons.location_on,
                      color: PrimaryColor,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: classLocationController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                        hintText: "Class Location",
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
                  Icon(Icons.image, color: PrimaryColor),
                  Spacer(),
                  DropdownButton(
                    hint: Text('Who Can Post on Team'),
                    value: whoCanPostToTeam,
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
                        whoCanPostToTeam = value;
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
                teamName = teamNameController.text;
                classLocation = classLocationController.text;
                print(about +
                    teamName +
                    classLocation +
                    whoCanSeMessage +
                    whoCanPostToTeam +
                    whoCanSeePost);

                if (about.isEmpty ||
                    teamName.isEmpty ||
                    classLocation.isEmpty ||
                    whoCanPostToTeam.isEmpty ||
                    whoCanSeePost.isEmpty ||
                    whoCanSeMessage.isEmpty) {
                  showDialog(
                      context: context,
                      child: AlertDialog(
                          title: Text(
                        'Fill All Fields',
                        style: TextStyle(color: Colors.black38, fontSize: 16),
                      )));
                } else {
                  Team _team = new Team();
                  _team.userId = user.uid;
                  _team.about = about;
                  _team.location = classLocation;
                  _team.teamName = teamName;
                  _team.whoCanSeePost = whoCanSeePost;
                  _team.whoCanSendMessage = whoCanSeMessage;
                  _team.whoCnaPost = whoCanPostToTeam;
                  _team.teamId = new Uuid().v1();
                  new DbUserCollection(user.uid)
                      .makeNewTeam(_team)
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
                      " Create Team",
                      style: Theme.of(context).textTheme.button.copyWith(
                            color: Colors.black,
                          ),
                    ),
                    SizedBox(width: 20),
                    Icon(
                      Icons.group_add,
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
      child: Text("See Team"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Team Created"),
      content: Text('Thanks For Making Team'),
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
