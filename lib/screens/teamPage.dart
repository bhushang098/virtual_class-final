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

class TeamPage extends StatefulWidget {
  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
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
      floatingActionButton: FloatingActionButton(
        heroTag: 'fabCreateTeam',
        backgroundColor: PrimaryColor,
        child: Icon(Icons.group_add),
        onPressed: () {
          navTpGrtPostDetails();
        },
      ),
      endDrawer: MyDrawer(),
      appBar: AppBar(
        title: Text("Team Page"),
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
              }),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(2.0),
        child: FutureBuilder(
          future: getTeams(),
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
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/TeamDetailsMain',
                            arguments: snapShot.data[index].data['team_id']);
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              snapShot.data[index].data['team_name'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24.0),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Image.network(
                                snapShot.data[index].data['team_image']),
                            Text(
                              '${snapShot.data[index].data['members'].length} Members',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: PrimaryColor,
                                  fontStyle: FontStyle.italic),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.location_on,
                                  color: Colors.black,
                                  size: 15,
                                ),
                                SizedBox(width: 10),
                                Text(snapShot.data[index].data['location']),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Hosted By  : ",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: snapShot.data[index].data['host'],
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }
          },
        ),
      ),
    );
  }

  getTeams() async {
    var fireStore = Firestore.instance;
    QuerySnapshot qn = await fireStore.collection('teams').getDocuments();
    return qn.documents;
  }

  void navTpGrtPostDetails() {
    Navigator.pushNamed(context, '/GetTeamDetails');
  }
}
