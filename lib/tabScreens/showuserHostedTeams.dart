import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualclass/constants.dart';

class ShowUserHostedTeams extends StatefulWidget {
  ShowUserHostedTeams({Key key, this.hostedTeamsList}) : super(key: key);

  var hostedTeamsList;
  @override
  _ShowUserHostedTeamsState createState() => _ShowUserHostedTeamsState();
}

class _ShowUserHostedTeamsState extends State<ShowUserHostedTeams> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      backgroundColor: primaryLight,
      key: _scaffoldKey,
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
                    return widget.hostedTeamsList
                            .contains(snapShot.data[index].data['team_id'])
                        ? InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/TeamDetailsMain',
                                  arguments:
                                      snapShot.data[index].data['team_id']);
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
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24.0),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Image.network(
                                    snapShot.data[index].data['team_image'],
                                    height:
                                        MediaQuery.of(context).size.height / 5,
                                  ),
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
                                      Text(snapShot
                                          .data[index].data['location']),
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
                                          text:
                                              snapShot.data[index].data['host'],
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
                          )
                        : Container();
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

  void navToMakenewTeams() {
    Navigator.pushNamed(context, '/GetTeamDetails');
  }
}
