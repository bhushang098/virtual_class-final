import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualclass/services/userSkillsArgs.dart';
import 'package:virtualclass/tabScreens/showuserHostedSkills.dart';
import 'package:virtualclass/tabScreens/showuserjoinedSkills.dart';

class ShowUserMadeSkillsMain extends StatefulWidget {
  @override
  _ShowUserMadeSkillsMainState createState() => _ShowUserMadeSkillsMainState();
}

class _ShowUserMadeSkillsMainState extends State<ShowUserMadeSkillsMain>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  UserSkillsArgs skillArgs;
  @override
  void initState() {
    _controller = TabController(
      length: 2,
      vsync: this,
    );

    skillArgs = new UserSkillsArgs();
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
    skillArgs = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Skills'),
        bottom: TabBar(
          controller: _controller,
          indicatorWeight: 3.0,
          indicatorColor: Colors.green,
          labelPadding: EdgeInsets.all(0.0),
          tabs: <Widget>[
            Tab(
              text: 'Joined Skills',
            ),
            Tab(
              text: 'Hosted Skills',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          ShowUserJoinedSkills(
            joinedSkillsList: skillArgs.joinedSkills,
          ),
          ShowuserHostedSkills(
            hostedSkillList: skillArgs.hostedSkills,
          )
        ],
      ),
    );
  }
}
