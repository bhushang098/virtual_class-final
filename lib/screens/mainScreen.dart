import 'package:flutter/material.dart';
import 'package:virtualclass/constants.dart';
import 'package:virtualclass/screens/teamPage.dart';
import 'package:virtualclass/screens/homeScreen.dart';
import 'package:virtualclass/screens/skillsPage.dart';
import 'package:virtualclass/screens/studentPage.dart';
import 'package:virtualclass/screens/clasesPage.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedItem = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageController _pageController = PageController();

  List<Widget> _screens = [
    HomePage(),
    SkillsPage(),
    TeamPage(),
    ClassesPage(),
    StudentPage()
  ];

  Widget appBarTitle = new Text('Virtual Class');
  Icon actionIcon = new Icon(Icons.search);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
            _pageController.jumpToPage(val);
          });
        },
        defaultSelectedIndex: 0,
      ),
      body: PageView(
        controller: _pageController,
        children: _screens,
        onPageChanged: _onpageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }

  void _onpageChanged(int index) {
    setState(() {
      _selectedItem = index;
    });
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
        height: 50,
        width: MediaQuery.of(context).size.width / _iconList.length,
        decoration: index == _selectedIndex
            ? BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 3, color: kPrimaryColor),
                ),
              )
            : BoxDecoration(),
        child: Column(
          children: <Widget>[
            Icon(
              icon,
              color: index == _selectedIndex ? kPrimaryColor : Colors.grey,
            ),
            Text(
              name,
              style: TextStyle(
                  color: index == _selectedIndex ? kPrimaryColor : Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
