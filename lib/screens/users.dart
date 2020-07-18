import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualclass/constants.dart';
import 'package:virtualclass/modals/userModal.dart';
import 'package:virtualclass/screens/deawer.dart';
import 'package:virtualclass/screens/professsorsPage.dart';
import 'package:virtualclass/screens/studentsPage.dart';
import 'package:virtualclass/services/fStoreCollection.dart';
import 'package:virtualclass/services/serchdeligate.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Myusers _myusers;
  FirebaseUser user;
  TabController _controller;
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
  void initState() {
    _controller = TabController(
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      backgroundColor: primaryLight,
      key: _scaffoldKey,
      endDrawer: MyDrawer(),
      appBar: AppBar(
        title: Text(" Users "),
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
        bottom: TabBar(
          controller: _controller,
          indicatorWeight: 3.0,
          indicatorColor: Colors.green,
          labelPadding: EdgeInsets.all(0.0),
          tabs: <Widget>[
            Tab(
              text: 'Students',
            ),
            Tab(
              text: 'Professors',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [StudentsPage(), ProfessorPage()],
      ),
    );
  }
}
