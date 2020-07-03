import 'package:flutter/material.dart';
import 'package:virtualclass/services/authentication.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  Auth _auth;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth = new Auth();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 40.0,
                    backgroundImage: AssetImage('images/welcome_image.jpeg'),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "example mail",
                    style: TextStyle(
                        color: Colors.teal, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: GestureDetector(
                onTap: () {
                  print('You Tapped purchases');
                },
                child: ListTile(
                  leading: Icon(Icons.shopping_cart),
                  title: Text(
                    'menu 1',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: GestureDetector(
                onTap: () {
                  print('You Tapped Diwnbloads');
                },
                child: ListTile(
                  leading: Icon(Icons.file_download),
                  title: Text(
                    'menu 2',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: GestureDetector(
                onTap: () {},
                child: ListTile(
                  leading: Icon(Icons.share),
                  title: Text(
                    'Share App ',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: GestureDetector(
                onTap: () {},
                child: ListTile(
                  leading: Icon(Icons.contact_mail),
                  title: Text(
                    'Contact Us',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: GestureDetector(
                onTap: () {},
                child: ListTile(
                  leading: Icon(Icons.note),
                  title: Text(
                    'Terms And Conditions',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: GestureDetector(
                onTap: () async {
                  await _auth.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/Loginpage', (Route<dynamic> route) => false);
                  print('You Tapped LogOUt');
                },
                child: ListTile(
                  leading: Icon(Icons.arrow_back),
                  title: Text(
                    'Log Out',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
