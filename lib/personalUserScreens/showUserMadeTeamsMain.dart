import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualclass/services/teamArgs.dart';
import 'package:virtualclass/services/userClassesArgs.dart';
import 'package:virtualclass/tabScreens/showUserJoinedClasses.dart';
import 'package:virtualclass/tabScreens/showUserJoinedTeams.dart';
import 'package:virtualclass/tabScreens/showUsersHostedClasses.dart';
import 'package:virtualclass/tabScreens/showuserHostedTeams.dart';

import '../constants.dart';

class ShowUserMadeTeamsMain extends StatefulWidget {
  @override
  _ShowUserMadeTeamsMainState createState() => _ShowUserMadeTeamsMainState();
}

class _ShowUserMadeTeamsMainState extends State<ShowUserMadeTeamsMain>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  UserTeamArgs teamArgs;
  @override
  void initState() {
    _controller = TabController(
      length: 2,
      vsync: this,
    );

    teamArgs = new UserTeamArgs();
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
    teamArgs = ModalRoute.of(context).settings.arguments;
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
              text: 'Joined Teams',
            ),
            Tab(
              text: 'Hosted Teams',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          ShowUserJoinedTeams(
            joinedTeamList: teamArgs.joinedTeam,
          ),
          ShowUserHostedTeams(
            hostedTeamsList: teamArgs.hostedTeams,
          )
        ],
      ),
    );
  }
}
