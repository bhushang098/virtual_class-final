import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualclass/messageTabScreens/usersInMessage.dart';
import 'package:virtualclass/services/userClassesArgs.dart';
import 'package:virtualclass/tabScreens/showUserJoinedClasses.dart';
import 'package:virtualclass/tabScreens/showUsersHostedClasses.dart';

import '../constants.dart';
import 'messageInMessage.dart';

class MessageTabHolder extends StatefulWidget {
  @override
  _MessageTabHolderState createState() => _MessageTabHolderState();
}

class _MessageTabHolderState extends State<MessageTabHolder>
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
      body: Column(
        children: <Widget>[
          Container(
            color: primaryDark,
            height: MediaQuery.of(context).size.height / 10,
            child: Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: TabBar(
                controller: _controller,
                indicatorWeight: 5.0,
                indicatorColor: PrimaryColor,
                labelPadding: EdgeInsets.all(0.0),
                tabs: <Widget>[
                  Tab(
                    text: 'Users',
                  ),
                  Tab(
                    text: 'Messages',
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _controller,
              children: [UsersInMessages(), MessageInMessage()],
            ),
          ),
        ],
      ),
    );
  }
}
