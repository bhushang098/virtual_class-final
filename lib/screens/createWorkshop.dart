import 'package:flutter/material.dart';

class CreateWorkshop extends StatefulWidget {
  @override
  _CreateWorkshopState createState() => _CreateWorkshopState();
}

class _CreateWorkshopState extends State<CreateWorkshop> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Class '),
      ),
      body: Center(
        child: Text(
          'Create A new Class / Workshop ',
          style: TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
    );
  }
}
