import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualclass/services/userClassesArgs.dart';
import 'package:virtualclass/tabScreens/showUserJoinedClasses.dart';
import 'package:virtualclass/tabScreens/showUsersHostedClasses.dart';

import '../constants.dart';

class ShowUserMadeClassesMain extends StatefulWidget {
  @override
  _ShowUserMadeClassesMainState createState() =>
      _ShowUserMadeClassesMainState();
}

class _ShowUserMadeClassesMainState extends State<ShowUserMadeClassesMain>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  UserClassesArgs classArgs;
  @override
  void initState() {
    _controller = TabController(
      length: 2,
      vsync: this,
    );

    classArgs = new UserClassesArgs();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);
    classArgs = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Classes'),
        bottom: TabBar(
          controller: _controller,
          indicatorWeight: 3.0,
          indicatorColor: Colors.green,
          labelPadding: EdgeInsets.all(0.0),
          tabs: <Widget>[
            Tab(
              text: 'Joined Classes',
            ),
            Tab(
              text: 'Hosted Classes',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          ShowUserJoinedClasses(
            joinedClassesList: classArgs.joinedClasses,
          ),
          ShowUserHostedClasses(
            hostedClassList: classArgs.hostedClasses,
          )
        ],
      ),
    );
  }
}
