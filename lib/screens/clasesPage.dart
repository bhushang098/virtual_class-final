import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualclass/modals/userModal.dart';
import 'package:virtualclass/services/fStoreCollection.dart';
import 'package:virtualclass/services/serchdeligate.dart';

import '../constants.dart';

class ClassesPage extends StatefulWidget {
  @override
  _ClassesPageState createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
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

  Future<bool> isTeacher(FirebaseUser user) async {
    DocumentSnapshot reference =
        await Firestore.instance.collection('users').document(user.uid).get();
    if (reference.data['is_teacher']) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      backgroundColor: primaryLight,
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        heroTag: 'fabCreateWorkshop',
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
                    content: Text('students can not create Classes'),
                  );
                },
              );
            } else {
              navToCreateWorkshop();
            }
          });
          // navTpGrtPostDetails();
        },
      ),
      appBar: AppBar(
        title: Text("Class Page"),
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
        ],
      ),
      body: FutureBuilder(
        future: getClasses(),
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
                      navToDetailsPage(snapShot.data[index].data['class_id']);
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
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  snapShot.data[index].data['class_name'],
                                  style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Image.network(
                                snapShot.data[index].data['class_image'],
                                height: MediaQuery.of(context).size.height / 5,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                  ' Location : ${snapShot.data[index].data['location']} '),
                              SizedBox(
                                height: 8,
                              ),
                              snapShot.data[index].data['fees'] == null
                                  ? Text(
                                      '    Free Class    ',
                                      style: TextStyle(
                                          backgroundColor: PrimaryColor,
                                          fontSize: 17),
                                    )
                                  : Text(
                                      '   INR ${snapShot.data[index].data['fees']}   ',
                                      style: TextStyle(
                                          backgroundColor: PrimaryColor,
                                          fontSize: 17),
                                    ),
                              SizedBox(
                                height: 5,
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.date_range,
                                  color: PrimaryColor,
                                ),
                                title: Text(snapShot
                                        .data[index].data['start_date']
                                        .toDate()
                                        .day
                                        .toString() +
                                    '/' +
                                    snapShot.data[index].data['start_date']
                                        .toDate()
                                        .month
                                        .toString() +
                                    '/' +
                                    snapShot.data[index].data['start_date']
                                        .toDate()
                                        .year
                                        .toString()),
                              ),
                              snapShot.data[index].data['is_daily']
                                  ? ListTile(
                                      leading: Icon(
                                        Icons.access_time,
                                        color: PrimaryColor,
                                      ),
                                      title: Text('Daily ' +
                                          snapShot.data[index].data['timing']
                                              .toDate()
                                              .hour
                                              .toString() +
                                          ' : ' +
                                          snapShot.data[index].data['timing']
                                              .toDate()
                                              .minute
                                              .toString()),
                                    )
                                  : ListTile(
                                      leading: Icon(
                                        Icons.access_time,
                                        color: PrimaryColor,
                                      ),
                                      title: Text('At ' +
                                          snapShot.data[index].data['timing']
                                              .toDate()
                                              .hour
                                              .toString() +
                                          ' : ' +
                                          snapShot.data[index].data['timing']
                                              .toDate()
                                              .minute
                                              .toString()),
                                    ),
                              SizedBox(
                                height: 5,
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

  getClasses() async {
    var fireStore = Firestore.instance;
    QuerySnapshot qn = await fireStore
        .collection('classes')
        .orderBy('time_created', descending: true)
        .getDocuments();
    return qn.documents;
  }

  void navToCreateWorkshop() {
    Navigator.pushNamed(context, '/CreateWorkshop');
  }

  void navToDetailsPage(String classId) {
    Navigator.pushNamed(context, '/ClassDetailsPage', arguments: classId);
  }
}
