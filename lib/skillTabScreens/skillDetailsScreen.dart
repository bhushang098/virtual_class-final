import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:virtualclass/constants.dart';

class SkillDetailsScreen extends StatefulWidget {
  SkillDetailsScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SkillDetailsScreenState createState() => _SkillDetailsScreenState();
}

class _SkillDetailsScreenState extends State<SkillDetailsScreen> {
  getskillsDetails(String skillId) async {
    var fireStore = Firestore.instance;
    DocumentSnapshot dsn =
        await fireStore.collection('skills').document(skillId).get();
    return dsn;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getskillsDetails(widget.title),
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
                            snapShot.data['skill_image'],
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
                    snapShot.data['skill_name'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('   Fees : ' + snapShot.data['fees'].toString() + '    ',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          backgroundColor: PrimaryColor)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Members :' + snapShot.data['members'].length.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.blue),
                  ),
                  ListTile(
                    leading: Icon(Icons.date_range),
                    title: Text('since'),
                    subtitle: Text(snapShot.data['date_created']
                            .toDate()
                            .day
                            .toString() +
                        '/' +
                        snapShot.data['date_created']
                            .toDate()
                            .month
                            .toString() +
                        '/' +
                        snapShot.data['date_created'].toDate().year.toString()),
                  ),
                  Text('Hosted By  : ' + snapShot.data['host'].toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                      )),
                  RatingBar(
                    initialRating: 3,
                    minRating: 5,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.green,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
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
