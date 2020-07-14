import 'package:flutter/material.dart';

class CreateSkills extends StatefulWidget {
  @override
  _CreateSkillsState createState() => _CreateSkillsState();
}

class _CreateSkillsState extends State<CreateSkills> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Skill'),
      ),
      body: Center(
        child: Text(
          'Create A new Skill ',
          style: TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
    );
  }
}
