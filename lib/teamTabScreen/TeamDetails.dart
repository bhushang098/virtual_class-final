import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../constants.dart';

class TeamDetails extends StatefulWidget {
  TeamDetails({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _TeamDetailsState createState() => _TeamDetailsState();
}

class _TeamDetailsState extends State<TeamDetails> {
  getClassesDetails(String skillId) async {
    var fireStore = Firestore.instance;
    DocumentSnapshot dsn =
        await fireStore.collection('teams').document(skillId).get();
    return dsn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getClassesDetails(widget.title),
        builder: (_, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            // ignore: missing_return
            return Center(
              child: Text('Loading ....'),
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Card(
                    elevation: 4,
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            snapShot.data['team_image'],
                            fit: BoxFit.fill,
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                        Positioned(
                          bottom: 30,
                          right: 30,
                          child: GestureDetector(
                            child: Icon(
                              Icons.add_a_photo,
                              color: PrimaryColor,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    snapShot.data['team_name'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '   Location : ' +
                        snapShot.data['location'].toString() +
                        '    ',
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '   Members : ' +
                        snapShot.data['members'].length.toString() +
                        '    ',
                    style: TextStyle(fontSize: 15, color: Colors.blue),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '   Hosted By : ' +
                        snapShot.data['host'].toString() +
                        '    ',
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text(snapShot.data['about']),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
