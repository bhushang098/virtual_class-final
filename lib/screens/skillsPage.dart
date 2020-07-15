import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualclass/modals/userModal.dart';
import 'package:virtualclass/screens/deawer.dart';
import 'package:virtualclass/services/fStoreCollection.dart';
import 'package:virtualclass/services/serchdeligate.dart';
import 'package:virtualclass/tabScreens/AccountgetScreen.dart';
import 'package:virtualclass/tabScreens/InterestsGetScreen.dart';
import 'package:virtualclass/tabScreens/RoleGetScreen.dart';
import 'package:virtualclass/tabScreens/basicInfoGetScreen.dart';

import '../constants.dart';

class SkillsPage extends StatefulWidget {
  @override
  _SkillsPageState createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage> {
//  List<Widget> childrens = [
//    BasicinfoGetScreen(),
//    InterestsGetScreen(),
//    RoleGetScreen(),
//    AccountgetScreen(),
//  ];

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
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        heroTag: 'fabCreateSkill',
        backgroundColor: kPrimaryColor,
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
      endDrawer: MyDrawer(),
      appBar: AppBar(
        title: Text("Skills Page"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context, delegate: DeligateLectures(new List()));
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
          IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                _scaffoldKey.currentState.openEndDrawer();
                print("u tapped menu");
              })
        ],
//          bottom: TabBar(
//            indicatorWeight: 3.0,
//            indicatorColor: Colors.green,
//            labelPadding: EdgeInsets.all(0.0),
//            tabs: <Widget>[
//              Tab(
//                text: 'Basic Info',
//              ),
//              Tab(
//                text: 'Interests',
//              ),
//              Tab(
//                text: 'Role',
//              ),
//              Tab(
//                text: 'Account',
//              ),
//            ],
//          ),
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
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '     INR ${snapShot.data[index].data['fees']}      ',
                                style: TextStyle(
                                    backgroundColor: kPrimaryColor,
                                    fontSize: 17),
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
//        body: TabBarView(
//          children: childrens,
//        ),
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
