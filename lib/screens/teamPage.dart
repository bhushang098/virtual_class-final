import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'package:virtualclass/constants.dart';
import 'package:virtualclass/screens/deawer.dart';
import 'package:virtualclass/services/serchdeligate.dart';

class TeamPage extends StatefulWidget {
  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  RandomColor _randomColor = RandomColor();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        child: Icon(Icons.add),
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
              onPressed: () {
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
        padding: const EdgeInsets.all(10.0),
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
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            snapShot.data[index].data['team_name'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 21.0),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            '${snapShot.data[index].data['members'].length} Members',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16.0,
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
                                  text: "Hosted By   ",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Virtual Skill',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 21,
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
