import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualclass/constants.dart';
import 'package:virtualclass/modals/userModal.dart';
import 'package:virtualclass/screens/deawer.dart';
import 'package:virtualclass/services/fStoreCollection.dart';
import 'package:virtualclass/services/serchdeligate.dart';

class StudentPage extends StatefulWidget {
  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

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
    return Scaffold(
      backgroundColor: primaryLight,
      key: _scaffoldKey,
      endDrawer: MyDrawer(),
      appBar: AppBar(
        title: Text("Students "),
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
      ),
      body: FutureBuilder(
        future: getStudents(),
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
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0, left: 10),
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 35,
                                backgroundImage: NetworkImage(
                                    snapShot.data[index].data['profile_url']),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                snapShot.data[index].data['name'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          ),
                        ),
                        Text(
                            'Location ${snapShot.data[index].data['location']}'),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Skills'),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: SingleChildScrollView(
                            child: skillBuilder(
                                snapShot.data[index].data['skills']),
                          ),
                        ),
                      ],
                    ),
                  );
                });
          }
        },
      ),
    );
  }

  getStudents() async {
    var fireStore = Firestore.instance;
    QuerySnapshot qn = await fireStore.collection('students').getDocuments();
    return qn.documents;
  }

  Widget skillBuilder(List<dynamic> skills) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: skills.length,
        itemBuilder: (BuildContext context, int index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  skills[index],
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          );
        });
  }
}
