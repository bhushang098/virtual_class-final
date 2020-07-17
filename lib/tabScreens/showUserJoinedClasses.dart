import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class ShowUserJoinedClasses extends StatefulWidget {
  ShowUserJoinedClasses({Key key, this.joinedClassesList}) : super(key: key);

  var joinedClassesList;
  @override
  _ShowUserJoinedClassesState createState() => _ShowUserJoinedClassesState();
}

class _ShowUserJoinedClassesState extends State<ShowUserJoinedClasses> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      backgroundColor: primaryLight,
      key: _scaffoldKey,
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
                  return widget.joinedClassesList.length == 0
                      ? Center(child: Text('N0 Joined Classes'))
                      : widget.joinedClassesList
                              .contains(snapShot.data[index].data['class_id'])
                          ? GestureDetector(
                              onTap: () {
                                navToDetailsPage(
                                    snapShot.data[index].data['class_id']);
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
                                            snapShot
                                                .data[index].data['class_name'],
                                            style: TextStyle(
                                                fontSize: 26,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Image.network(
                                          snapShot
                                              .data[index].data['class_image'],
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              5,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                            ' Location : ${snapShot.data[index].data['location']} '),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        snapShot.data[index].data['fees'] ==
                                                null
                                            ? Text(
                                                '    Free Class    ',
                                                style: TextStyle(
                                                    backgroundColor:
                                                        PrimaryColor,
                                                    fontSize: 17),
                                              )
                                            : Text(
                                                '   INR ${snapShot.data[index].data['fees']}   ',
                                                style: TextStyle(
                                                    backgroundColor:
                                                        PrimaryColor,
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
                                          title: Text(snapShot.data[index]
                                                  .data['start_date']
                                                  .toDate()
                                                  .day
                                                  .toString() +
                                              '/' +
                                              snapShot.data[index]
                                                  .data['start_date']
                                                  .toDate()
                                                  .month
                                                  .toString() +
                                              '/' +
                                              snapShot.data[index]
                                                  .data['start_date']
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
                                                    snapShot.data[index]
                                                        .data['timing']
                                                        .toDate()
                                                        .hour
                                                        .toString() +
                                                    ' : ' +
                                                    snapShot.data[index]
                                                        .data['timing']
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
                                                    snapShot.data[index]
                                                        .data['timing']
                                                        .toDate()
                                                        .hour
                                                        .toString() +
                                                    ' : ' +
                                                    snapShot.data[index]
                                                        .data['timing']
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
                            )
                          : Container();
                });
          }
        },
      ),
    );
  }

  getClasses() async {
    var fireStore = Firestore.instance;
    QuerySnapshot qn = await fireStore.collection('classes').getDocuments();
    return qn.documents;
  }

  void navToCreateWorkshop() {
    Navigator.pushNamed(context, '/CreateWorkshop');
  }

  void navToDetailsPage(String classId) {
    Navigator.pushNamed(context, '/ClassDetailsPage', arguments: classId);
  }
}
