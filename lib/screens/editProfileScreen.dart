import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualclass/constants.dart';
import 'package:virtualclass/modals/userModal.dart';
import 'package:virtualclass/services/fStoreCollection.dart';
import 'package:virtualclass/tabScreens/AccountgetScreen.dart';
import 'package:virtualclass/tabScreens/InterestsGetScreen.dart';
import 'package:virtualclass/tabScreens/RoleGetScreen.dart';
import 'package:virtualclass/tabScreens/basicInfoGetScreen.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  List<Widget> childrens = [
    BasicinfoGetScreen(),
    InterestsGetScreen(),
    RoleGetScreen(),
    AccountgetScreen(),
  ];

  Myusers _myUser;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Your Profile'),
          bottom: TabBar(
            indicatorWeight: 3.0,
            indicatorColor: Colors.green,
            labelPadding: EdgeInsets.all(0.0),
            tabs: <Widget>[
              Tab(
                text: 'Basic Info',
              ),
              Tab(
                text: 'Interests',
              ),
              Tab(
                text: 'Role',
              ),
              Tab(
                text: 'Account',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: childrens,
        ),
      ),
    );
  }
}
