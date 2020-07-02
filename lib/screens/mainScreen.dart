import 'package:flutter/material.dart';
import 'package:virtualclass/constants.dart';
import 'package:virtualclass/services/serchdeligate.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedItem = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget appBarTitle = new Text('Virtual Class');
  Icon actionIcon = new Icon(Icons.search);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
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
                  onTap: () {
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
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        iconList: [
          Icons.home,
          Icons.desktop_mac,
          Icons.group,
          Icons.work,
          Icons.person,
        ],
        onChange: (val) {
          setState(() {
            _selectedItem = val;
          });
        },
        defaultSelectedIndex: 0,
      ),
      appBar: AppBar(
        title: Text("Virtual Class"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                    context: context, delegate: DeligateLectures(new List()));
                print("u tapped search");
              }),
          IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
//                _scaffoldKey.currentState.openEndDrawer();
                print("u tapped profile");
              }),
          IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                _scaffoldKey.currentState.openEndDrawer();
                print("u tapped menu");
              })
        ],
      ),
      body: Center(
        child: Text(
          "Selected Item Number is  $_selectedItem",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatefulWidget {
  final int defaultSelectedIndex;
  final Function(int) onChange;
  final List<IconData> iconList;

  CustomBottomNavigationBar(
      {this.defaultSelectedIndex = 0,
      @required this.iconList,
      @required this.onChange});

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _selectedIndex = 0;
  List<IconData> _iconList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _selectedIndex = widget.defaultSelectedIndex;
    _iconList = widget.iconList;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _navBarItemList = [];
    List<String> names = ['home', 'skills', 'group', 'workshop', 'student'];

    for (var i = 0; i < _iconList.length; i++) {
      _navBarItemList.add(buildNavBarItem(_iconList[i], i, names[i]));
    }

    return Row(
      children: _navBarItemList,
    );
  }

  Widget buildNavBarItem(IconData icon, int index, String name) {
    return GestureDetector(
      onTap: () {
        widget.onChange(index);
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width / _iconList.length,
        decoration: index == _selectedIndex
            ? BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 4, color: kPrimaryColor),
                ),
//                gradient: LinearGradient(colors: [
//                  kPrimaryColor.withOpacity(0.3),
//                  kPrimaryColor.withOpacity(0.015),
//                ], begin: Alignment.bottomCenter, end: Alignment.topCenter)
                // color: index == _selectedItemIndex ? Colors.green : Colors.white,
              )
            : BoxDecoration(),
        child: Column(
          children: <Widget>[
            Icon(
              icon,
              color: index == _selectedIndex ? kPrimaryColor : Colors.grey,
            ),
            Text(name),
          ],
        ),
      ),
    );
  }
}
