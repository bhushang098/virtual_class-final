import 'package:flutter/material.dart';
import 'package:virtualclass/teamTabScreen/TeamDetails.dart';
import 'package:virtualclass/teamTabScreen/TeamsPosts.dart';

class TeamDetailsMain extends StatefulWidget {
  @override
  _TeamDetailsMainState createState() => _TeamDetailsMainState();
}

class _TeamDetailsMainState extends State<TeamDetailsMain>
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
              text: 'Team',
            ),
            Tab(
              text: 'Posts',
              //child: Text(skillid),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [
          TeamDetails(
            title: skillid,
          ),
          TeamPosts(
            title: skillid,
          ),
        ],
      ),
    );
  }
}
