import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class ShowUserJoinedSkills extends StatefulWidget {
  ShowUserJoinedSkills({Key key, this.joinedSkillsList}) : super(key: key);

  var joinedSkillsList;
  @override
  _ShowUserJoinedSkillsState createState() => _ShowUserJoinedSkillsState();
}

class _ShowUserJoinedSkillsState extends State<ShowUserJoinedSkills> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      backgroundColor: primaryLight,
      key: _scaffoldKey,
      body: FutureBuilder(
        future: getSkills(),
        builder: (_, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            // ignore: missing_return
            return Center(
              child: Text('Loading ....'),
            );
          } else {
            return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapShot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return widget.joinedSkillsList
                          .contains(snapShot.data[index].data['skill_id'])
                      ? GestureDetector(
                          onTap: () {
                            navToDetailsPage(
                                snapShot.data[index].data['skill_id']);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        snapShot.data[index].data['skill_name'],
                                        style: TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Image.network(
                                      snapShot.data[index].data['skill_image'],
                                      height: 150,
                                      fit: BoxFit.fill,
                                      width: MediaQuery.of(context).size.width,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '     INR ${snapShot.data[index].data['fees']}      ',
                                      style: TextStyle(
                                          backgroundColor: primaryDark,
                                          fontSize: 17,
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                        'Members ${snapShot.data[index].data['members'].length} '),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      'Hosted By :  ${snapShot.data[index].data['host']} ',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container();
                });
          }
        },
      ),
    );
  }

  getSkills() async {
    var fireStore = Firestore.instance;
    QuerySnapshot qn = await fireStore
        .collection('skills')
        .orderBy('date_created', descending: true)
        .getDocuments();
    return qn.documents;
  }

  Future<bool> isTeacher(FirebaseUser user) async {
    DocumentSnapshot reference =
        await Firestore.instance.collection('users').document(user.uid).get();
    if (reference.data['is_teacher']) {
      return true;
    } else {
      return false;
    }
  }

  void navToCreateSkill() {
    Navigator.pushNamed(context, '/CreateSkills');
  }

  Future<String> getUsername(String uid) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('users').document(uid).get();

    var userName = snapshot.data['name'];
  }

  void navToDetailsPage(String skillId) {
    Navigator.pushNamed(context, '/SkillDetailsPage', arguments: skillId);
  }
}
