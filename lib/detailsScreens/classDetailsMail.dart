import 'package:flutter/material.dart';
import 'package:virtualclass/classTabScreens/classDetails.dart';
import 'package:virtualclass/classTabScreens/classsPosts.dart';

class ClassDetailsMain extends StatefulWidget {
  @override
  _ClassDetailsMainState createState() => _ClassDetailsMainState();
}

class _ClassDetailsMainState extends State<ClassDetailsMain>
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
    String classId = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(classId.split('??.??').last),
        bottom: TabBar(
          controller: _controller,
          indicatorWeight: 3.0,
          indicatorColor: Colors.green,
          labelPadding: EdgeInsets.all(0.0),
          tabs: <Widget>[
            Tab(
              text: 'class',
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
          ClassDetails(
            title: classId,
          ),
          ClassPosts(
            title: classId,
          )
        ],
      ),
    );
  }
}
