import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:virtualclass/modals/skillModal.dart';
import 'package:virtualclass/modals/userModal.dart';
import 'package:virtualclass/services/fStoreCollection.dart';
import 'package:virtualclass/services/searchDeligateSkilll.dart';

import '../constants.dart';

class SkillsPage extends StatefulWidget {
  @override
  _SkillsPageState createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage> {
  List<Skill> _skillList = [];
  Myusers _myusers;
  FirebaseUser user;
  _showDialog(title, text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void navToprofilePage(Myusers user) {
    Navigator.pushNamed(context, '/ProfilePage', arguments: user);
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    _skillList.clear();
    return Scaffold(
      backgroundColor: primaryLight,
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        heroTag: 'fabCreateSkill',
        backgroundColor: PrimaryColor,
        child: Icon(Icons.add),
        onPressed: () {
          bool istechher = false;
          isTeacher(user).then((value) async {
            istechher = value;
            if (!istechher) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    // Retrieve the text the that user has entered by using the
                    // TextEditingController.
                    content: Text('students can not create Skills'),
                  );
                },
              );
            } else {
              navToCreateSkill();
            }
          });
          // navTpGrtPostDetails();
        },
      ),
      appBar: AppBar(
        title: Text("Skills Page"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                getSkillList();
                showSearch(
                    context: context,
                    delegate: DeligateSkill(_skillList, context));
                print("u tapped search");
              }),
          IconButton(
              icon: Icon(Icons.person),
              onPressed: () async {
                var result = await Connectivity().checkConnectivity();
                if (result == ConnectivityResult.none) {
                  _showDialog(
                      'No internet', "You're not connected to a network");
                } else if (result == ConnectivityResult.mobile ||
                    result == ConnectivityResult.wifi) {
                  _myusers = await new DbUserCollection(user.uid)
                      .getUserDeta(user.uid);
                  navToprofilePage(_myusers);
                }
                print("u tapped profile");
              }),
        ],
      ),
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
                  return GestureDetector(
                    onTap: () {
                      navToDetailsPage(snapShot.data[index].data['skill_id']);
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
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
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

  void getSkillList() {
    _skillList = getSkillsData();
  }

  List<Skill> getSkillsData() {
    Firestore.instance
        .collection('skills')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => _skillList.add(buildSkillClass(f)));
    });
    return _skillList;
  }

  Skill buildSkillClass(DocumentSnapshot f) {
    Skill _skill = new Skill();
    _skill.skillName = f.data['skill_name'];
    _skill.about = f.data['about'];
    _skill.public_comment = f.data['public_comment'];
    _skill.public_post = f.data['public_post'];
    _skill.public_see_post = f.data['public_see_post'];
    _skill.userId = f.data['user_id'];
    _skill.skillId = f.data['skill_id'];
    _skill.hosted_by = f.data['host'];
    _skill.skill_image = f.data['skill_image'];
    _skill.price = f.data['fees'];
    _skill.members = f.data['members'];

    return _skill;
  }
}
