import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:virtualclass/services/fStoreCollection.dart';
import 'package:virtualclass/services/teamArgs.dart';
import 'package:virtualclass/services/userClassesArgs.dart';
import 'package:virtualclass/services/userSkillsArgs.dart';
import '../constants.dart';

class OtherUserProfile extends StatefulWidget {
  @override
  _OtherUserProfileState createState() => _OtherUserProfileState();
}

class _OtherUserProfileState extends State<OtherUserProfile> {
  Future<File> imageFile;
  bool _showProgress = false;
  String userid;
  var followers = [];
  var following = [];

  void showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Profile Updated"),
      content: Text('Updated Succesfully'),
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

  getPofile(String uid) async {
    var fireStore = Firestore.instance;
    DocumentSnapshot dsn =
        await fireStore.collection('users').document(uid).get();
    return dsn;
  }

  @override
  Widget build(BuildContext context) {
    userid = ModalRoute.of(context).settings.arguments;
    setFollwersAndFollwing(userid);
    final user = Provider.of<FirebaseUser>(context);
    _showProgress = false;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: getPofile(userid),
          builder: (_, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              // ignore: missing_return
              return Center(
                child: Text('Loading ....'),
              );
            } else {
              if (snapShot.data['is_teacher']) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * .36,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [PrimaryColor, PrimaryColor]),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * .70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 50),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Icon(Icons.arrow_back_ios),
                                        ),
                                        elevation: 5,
                                      ),
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        //pickImageFromGallery();
                                      },
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          snapShot.data['profile_url'],
                                        ),
                                        radius: 40.0,
                                      ),
                                    ),
                                    Spacer(),
                                    userid == user.uid
                                        ? GestureDetector(
                                            onTap: () {
                                              //navToEditprofile();
                                            },
                                            child: Card(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Icon(
                                                  Icons.mode_edit,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              elevation: 5,
                                            ),
                                          )
                                        : followers.contains(user.uid)
                                            ? GestureDetector(
                                                onTap: () {
                                                  new DbUserCollection(user.uid)
                                                      .unFollowUser(userid)
                                                      .then((onValue) {
                                                    setState(() {});
                                                  });
                                                },
                                                child: Card(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text(
                                                      'UnFollow',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                  elevation: 5,
                                                ),
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                  new DbUserCollection(user.uid)
                                                      .followUser(userid)
                                                      .then((onValue) {
                                                    setState(() {});
                                                  });
                                                },
                                                child: Card(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text(
                                                      'Follow',
                                                      style: TextStyle(
                                                          color: Colors.green),
                                                    ),
                                                  ),
                                                  elevation: 5,
                                                ),
                                              ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                snapShot.data['name'],
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                snapShot.data['email'],
                                style: TextStyle(color: Colors.white),
                              ),
                              RatingBar(
                                initialRating: 3,
                                minRating: 5,
                                direction: Axis.horizontal,
                                itemCount: 5,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 2.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.green,
                                ),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                },
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height / 9,
                          left: MediaQuery.of(context).size.width / 2,
                          child: Icon(
                            Icons.verified_user,
                            color: Colors.green,
                          ),
                        ),
                        Padding(
                          padding: new EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .28,
                            left: 5,
                            right: 5,
                          ),
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            color: Colors.white,
                            elevation: 5.0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 22.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, '/ShowUsersPosts',
                                                arguments: userid);
                                          },
                                          child: Text(
                                            "Posts",
                                            style: TextStyle(
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          snapShot.data['posts'].length
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          "Followers",
                                          style: TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          snapShot.data['followers'].length
                                              .toString(),
                                          style: TextStyle(fontSize: 14.0),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          "Following",
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          snapShot.data['following'].length
                                              .toString(),
                                          style: TextStyle(fontSize: 14.0),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: new EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .42,
                            left: 5,
                            right: 5,
                          ),
                          child: Text(
                            'Personal Details',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                        ),
                        Padding(
                          padding: new EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .46,
                            left: 5,
                            right: 5,
                          ),
                          child: Text(
                            'Phone Number  ' + snapShot.data['phone'],
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 13),
                          ),
                        ),
                        Padding(
                          padding: new EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .49,
                            left: 5,
                            right: 5,
                          ),
                          child: snapShot.data['gender']
                              ? Text(
                                  'Gender  Male',
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 13),
                                )
                              : Text(
                                  'Gender  Female',
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 13),
                                ),
                        ),
                        Padding(
                          padding: new EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .52,
                            left: 5,
                            right: 5,
                          ),
                          child: Text(
                            'Location : ' + snapShot.data['location'],
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 13),
                          ),
                        ),
                        Padding(
                          padding: new EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .53,
                            left: 5,
                            right: 5,
                          ),
                          child: Column(
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  UserSkillsArgs skillArgs =
                                      new UserSkillsArgs();

                                  skillArgs.hostedSkills =
                                      snapShot.data['skills_made'];
                                  skillArgs.joinedSkills =
                                      snapShot.data['skills_joined'];
                                  //Show Skills made
                                  Navigator.pushNamed(
                                      context, '/ShowUserMadeSkillsMain',
                                      arguments: skillArgs);
                                },
                                child: ListTile(
                                  leading: Icon(
                                    Icons.desktop_mac,
                                    color: Colors.black,
                                  ),
                                  title: Text('Skills '),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  UserClassesArgs classArgs =
                                      new UserClassesArgs();
                                  classArgs.joinedClasses =
                                      snapShot.data['classes_joined'];
                                  classArgs.hostedClasses =
                                      snapShot.data['classes_made'];
                                  //Show Skills made
                                  Navigator.pushNamed(
                                      context, '/ShowUserMadeClassesMain',
                                      arguments: classArgs);
                                },
                                child: ListTile(
                                  leading: Icon(
                                    Icons.stay_current_landscape,
                                    color: Colors.black,
                                  ),
                                  title: Text('classes '),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  UserTeamArgs teamArgs = new UserTeamArgs();

                                  teamArgs.joinedTeam =
                                      snapShot.data['teams_joined'];
                                  teamArgs.hostedTeams =
                                      snapShot.data['teams_made'];

                                  Navigator.pushNamed(
                                      context, '/ShowUserMadeTeamsMain',
                                      arguments: teamArgs);
                                },
                                child: ListTile(
                                  leading: Icon(
                                    Icons.group,
                                    color: Colors.black,
                                  ),
                                  title: Text(' Teams '),
                                ),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.attach_money,
                                  color: Colors.black,
                                ),
                                title: Text('Earnings'),
                              ),
                            ],
                          ),
                        ),
                        _showProgress
                            ? Center(child: CircularProgressIndicator())
                            : Padding(
                                padding: const EdgeInsets.only(top: 45.0),
                                child: Center(child: Text('')),
                              ),
                      ],
                    ),
                  ),
                );
              } else {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * .36,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [PrimaryColor, PrimaryColor]),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * .70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 50),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Icon(Icons.arrow_back_ios),
                                        ),
                                        elevation: 5,
                                      ),
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        //pickImageFromGallery();
                                      },
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          snapShot.data['profile_url'],
                                        ),
                                        radius: 40.0,
                                      ),
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        navToEditprofile();
                                      },
                                      child: followers.contains(user.uid)
                                          ? GestureDetector(
                                              onTap: () {
                                                new DbUserCollection(user.uid)
                                                    .unFollowUser(userid)
                                                    .then((onValue) {
                                                  setState(() {});
                                                });
                                              },
                                              child: Card(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    'UnFollow',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                                elevation: 5,
                                              ),
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                new DbUserCollection(user.uid)
                                                    .followUser(userid)
                                                    .then((onValue) {
                                                  setState(() {});
                                                });
                                              },
                                              child: Card(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    'Follow',
                                                    style: TextStyle(
                                                        color: Colors.green),
                                                  ),
                                                ),
                                                elevation: 5,
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                snapShot.data['name'],
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                snapShot.data['email'],
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: new EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .28,
                            left: 5,
                            right: 5,
                          ),
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            color: Colors.white,
                            elevation: 5.0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 22.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, '/ShowUsersPosts',
                                                arguments: userid);
                                          },
                                          splashColor: PrimaryColor,
                                          child: Text(
                                            "Posts",
                                            style: TextStyle(
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          snapShot.data['posts'].length
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 14.0,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          "Followers",
                                          style: TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          snapShot.data['followers'].length
                                              .toString(),
                                          style: TextStyle(fontSize: 14.0),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          "Following",
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          snapShot.data['following'].length
                                              .toString(),
                                          style: TextStyle(fontSize: 14.0),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: new EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .42,
                            left: 5,
                            right: 5,
                          ),
                          child: Text(
                            'Personal Details',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                        ),
                        Padding(
                          padding: new EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .46,
                            left: 5,
                            right: 5,
                          ),
                          child: Text(
                            'Phone Number  ' + snapShot.data['phone'],
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 13),
                          ),
                        ),
                        Padding(
                          padding: new EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .49,
                            left: 5,
                            right: 5,
                          ),
                          child: snapShot.data['gender']
                              ? Text(
                                  'Gender  Male',
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 13),
                                )
                              : Text(
                                  'Gender  Female',
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 13),
                                ),
                        ),
                        Padding(
                          padding: new EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .52,
                            left: 5,
                            right: 5,
                          ),
                          child: Text(
                            'Location : ' + snapShot.data['location'],
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 13),
                          ),
                        ),
                        Padding(
                          padding: new EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .53,
                            left: 5,
                            right: 5,
                          ),
                          child: Column(
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  UserSkillsArgs skillArgs =
                                      new UserSkillsArgs();

                                  skillArgs.hostedSkills =
                                      snapShot.data['skills_made'];
                                  skillArgs.joinedSkills =
                                      snapShot.data['skills_joined'];
                                  //Show Skills made
                                  Navigator.pushNamed(
                                      context, '/ShowUserMadeSkillsMain',
                                      arguments: skillArgs);
                                },
                                child: ListTile(
                                  leading: Icon(
                                    Icons.desktop_mac,
                                    color: Colors.black,
                                  ),
                                  title: Text('Skills '),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  UserClassesArgs classArgs =
                                      new UserClassesArgs();
                                  classArgs.joinedClasses =
                                      snapShot.data['classes_joined'];
                                  classArgs.hostedClasses =
                                      snapShot.data['classes_made'];
                                  //Show Skills made
                                  Navigator.pushNamed(
                                      context, '/ShowUserMadeClassesMain',
                                      arguments: classArgs);
                                },
                                child: ListTile(
                                  leading: Icon(
                                    Icons.stay_current_landscape,
                                    color: Colors.black,
                                  ),
                                  title: Text('classes '),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  UserTeamArgs teamArgs = new UserTeamArgs();

                                  teamArgs.joinedTeam =
                                      snapShot.data['teams_joined'];
                                  teamArgs.hostedTeams =
                                      snapShot.data['teams_made'];

                                  Navigator.pushNamed(
                                      context, '/ShowUserMadeTeamsMain',
                                      arguments: teamArgs);
                                },
                                child: ListTile(
                                  leading: Icon(
                                    Icons.group,
                                    color: Colors.black,
                                  ),
                                  title: Text(' Teams '),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _showProgress
                            ? Center(child: CircularProgressIndicator())
                            : Padding(
                                padding: const EdgeInsets.only(top: 45.0),
                                child: Center(child: Text('')),
                              ),
                      ],
                    ),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }

  void navToEditprofile() {
    Navigator.pushNamed(
      context,
      '/EditProfile',
    );
  }

  void setFollwersAndFollwing(String otherUsersId) async {
    DocumentSnapshot dnsp = await Firestore.instance
        .collection('users')
        .document(otherUsersId)
        .get();
    followers = dnsp.data['followers'];
    following = dnsp.data['following'];
  }
}
