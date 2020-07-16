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
    String skillid = ModalRoute.of(context).settings.arguments;
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
}
