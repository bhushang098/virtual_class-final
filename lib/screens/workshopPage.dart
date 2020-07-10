import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualclass/modals/userModal.dart';
import 'package:virtualclass/screens/deawer.dart';
import 'package:virtualclass/services/fStoreCollection.dart';
import 'package:virtualclass/services/serchdeligate.dart';

class WorkshopPage extends StatefulWidget {
  @override
  _WorkshopPageState createState() => _WorkshopPageState();
}

class _WorkshopPageState extends State<WorkshopPage> {
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
      key: _scaffoldKey,
      endDrawer: MyDrawer(),
      appBar: AppBar(
        title: Text("Workshop Page"),
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
        future: getWorkshops(),
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
                  return Column(
                    children: <Widget>[
                      SizedBox(
                        height: 3,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.network(snapShot
                                      .data[index].data['image_url']
                                      .toString()),
                                ),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 3,
                                      blurRadius: 10,
                                      offset: Offset(
                                          0, 0), // changes position of shadow
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                snapShot.data[index].data['name'],
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                  'INR ${snapShot.data[index].data['price']} '),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                  'Location ${snapShot.data[index].data['location']} '),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                  'Timing ${snapShot.data[index].data['timing']} '),
                              SizedBox(
                                height: 8,
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.date_range,
                                  color: Colors.blue,
                                ),
                                title: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Date ",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blue,
                                        ),
                                      ),
                                      TextSpan(
                                        text: snapShot.data[index].data['date']
                                            .toString()
                                            .split('=')
                                            .first,
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                    ],
                  );
                });
          }
        },
      ),
    );
  }

  getWorkshops() async {
    var fireStore = Firestore.instance;
    QuerySnapshot qn = await fireStore.collection('workshops').getDocuments();
    return qn.documents;
  }
}
