import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualclass/constants.dart';

class ProfessorPage extends StatefulWidget {
  @override
  _ProfessorPageState createState() => _ProfessorPageState();
}

class _ProfessorPageState extends State<ProfessorPage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    return Scaffold(
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
                  return snapShot.data[index].data['is_teacher']
                      ? user.uid == snapShot.data[index].documentID
                          ? Container()
                          : Stack(
                              children: <Widget>[
                                Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 12.0, left: 10),
                                        child: Row(
                                          children: <Widget>[
                                            CircleAvatar(
                                              radius: 35,
                                              backgroundImage: NetworkImage(
                                                  snapShot.data[index]
                                                      .data['profile_url']),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(context,
                                                    '/OtherUserProfile',
                                                    arguments: snapShot
                                                        .data[index]
                                                        .documentID);
                                              },
                                              child: Text(
                                                snapShot
                                                    .data[index].data['name'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    color: PrimaryColor),
                                              ),
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
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: SingleChildScrollView(
                                          child: skillBuilder(snapShot
                                              .data[index].data['skills']),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                      : Container();
                });
          }
        },
      ),
    );
  }

  getStudents() async {
    var fireStore = Firestore.instance;
    QuerySnapshot qn = await fireStore.collection('users').getDocuments();
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
