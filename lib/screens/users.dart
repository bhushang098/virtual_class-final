import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualclass/constants.dart';
import 'package:virtualclass/modals/userModal.dart';
import 'package:virtualclass/screens/professsorsPage.dart';
import 'package:virtualclass/screens/studentsPage.dart';
import 'package:virtualclass/services/fStoreCollection.dart';
import 'package:virtualclass/services/searchDeligateUser.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Myusers _myusers;
  FirebaseUser user;
  TabController _controller;
  List<Myusers> _userList = [];
  _showDialog(title, text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void navToprofilePage(Myusers user) {
    Navigator.pushNamed(context, '/ProfilePage', arguments: user);
  }

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
    user = Provider.of<FirebaseUser>(context);
    _userList.clear();
    return Scaffold(
      backgroundColor: primaryLight,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(" Users "),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                getUsersList();
                showSearch(
                    context: context,
                    delegate: DeligateUsers(_userList, context));
                print("u tapped search");
              }),
          IconButton(
              icon: Icon(Icons.person),
              onPressed: () async {
                var result = await Connectivity().checkConnectivity();
                if (result == ConnectivityResult.none) {
                  _showDialog(
                      'No internet', "You're not connected to a network");
                } else if (result == ConnectivityResult.mobile ||
                    result == ConnectivityResult.wifi) {
                  _myusers = await new DbUserCollection(user.uid)
                      .getUserDeta(user.uid);
                  navToprofilePage(_myusers);
                }
                print("u tapped profile");
              }),
        ],
        bottom: TabBar(
          controller: _controller,
          indicatorWeight: 3.0,
          indicatorColor: Colors.green,
          labelPadding: EdgeInsets.all(0.0),
          tabs: <Widget>[
            Tab(
              text: 'Students',
            ),
            Tab(
              text: 'Professors',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: [StudentsPage(), ProfessorPage()],
      ),
    );
  }

  void getUsersList() {
    _userList = getUsersData();
  }

  List<Myusers> getUsersData() {
    Firestore.instance
        .collection('users')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => _userList.add(buildUsersClass(f)));
    });
    return _userList;
  }

  Myusers buildUsersClass(DocumentSnapshot f) {
    Myusers _user = new Myusers();

    _user.name = f.data['name'];
    _user.profile_url = f.data['profile_url'];
    _user.location = f.data['location'];
    _user.skills = f.data['skills'];
    _user.isTeacher = f.data['is_teacher'];
    _user.userId = f.data['user_id'];

    return _user;
  }
}
