import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtualclass/skillTabScreens/skillDetailsScreen.dart';
import 'package:virtualclass/skillTabScreens/skillPostScreen.dart';

class SkillDetailsMain extends StatefulWidget {
  @override
  _SkillDetailsMainState createState() => _SkillDetailsMainState();
}

class _SkillDetailsMainState extends State<SkillDetailsMain>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  String userWhoMadeSkill;
  Map<String, dynamic> members;

  @override
  void initState() {
    _controller = TabController(
      length: 2,
      vsync: this,
    );
    members = new Map();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String skillid = ModalRoute.of(context).settings.arguments;
    getmembersnasuser(skillid);
    return Scaffold(
      appBar: AppBar(
        title: Text(skillid.split('??.??').last),
        bottom: TabBar(
          controller: _controller,
          indicatorWeight: 3.0,
          indicatorColor: Colors.green,
          labelPadding: EdgeInsets.all(0.0),
          tabs: <Widget>[
            Tab(
              text: 'skill',
            ),
            Tab(
              text: 'posts',
              //child: Text(skillid),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          SkillDetailsScreen(
            title: skillid,
          ),
          SkillPostScreen(
            title: skillid,
          ),
        ],
      ),
    );
  }

  void getmembersnasuser(String skillid) {
    var snp = Firestore.instance.collection('skills').document(skillid).get();
    snp.then((onValue) {
      userWhoMadeSkill = onValue.data['user_id'];
      members = onValue.data['members'];
    });
  }
}
