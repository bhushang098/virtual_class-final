import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:virtualclass/detailsScreens/classDetailsMail.dart';
import 'package:virtualclass/detailsScreens/skillDetailsMain.dart';
import 'package:virtualclass/detailsScreens/teamDetailsMain.dart';
import 'package:virtualclass/personalUserScreens/showUSerMadeSkills.dart';
import 'package:virtualclass/personalUserScreens/showUserMadeTeamsMain.dart';
import 'package:virtualclass/personalUserScreens/showUsermadeClassesMain.dart';
import 'package:virtualclass/personalUserScreens/showUsermadeSkillsMain.dart';
import 'package:virtualclass/personalUserScreens/showuserMadeTeams.dart';
import 'package:virtualclass/screens/commentsScreen.dart';
import 'package:virtualclass/screens/createSkillpage.dart';
import 'package:virtualclass/screens/createClass.dart';
import 'package:virtualclass/screens/editProfileScreen.dart';
import 'package:virtualclass/screens/createTeamPage.dart';
import 'package:virtualclass/screens/mainScreen.dart';
import 'package:virtualclass/screens/makePostScreen.dart';
import 'package:virtualclass/screens/otherUSerprofilePage.dart';
import 'package:virtualclass/screens/profilepage.dart';
import 'package:virtualclass/screens/showFollowers.dart';
import 'package:virtualclass/screens/showFollowingusers.dart';
import 'package:virtualclass/screens/showusersPost.dart';
import 'package:virtualclass/screens/skillsPage.dart';
import 'package:virtualclass/screens/welcomeScreen.dart';
import 'package:virtualclass/screens/wrapper.dart';
import 'package:virtualclass/services/authentication.dart';
import 'constants.dart';
import 'messageTabScreens/messageTabsHolder.dart';
import 'newScreens/homePage.dart';
import 'sign_in.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value(
      value: Auth().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Virtual Class',
        theme: ThemeData(
//        brightness: Brightness.dark,
          primaryColor: PrimaryColor,
//        scaffoldBackgroundColor: kBackgroundColor,
          textTheme: TextTheme(
            display1:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            button: TextStyle(color: PrimaryColor),
            headline:
                TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
          ),
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white.withOpacity(.2),
              ),
            ),
          ),
        ),
        routes: <String, WidgetBuilder>{
          '/Loginpage': (BuildContext context) => new SignInScreen(),
          '/MainPage': (BuildContext context) => new MainScreen(),
          '/ProfilePage': (BuildContext context) => new ProfilePage(),
          '/CommentScreen': (BuildContext context) => new CommentsScreen(),
          '/MakePostScreen': (BuildContext context) => new MakePostScreen(),
          '/WelcomeScreen': (BuildContext context) => new WelcomeScreen(),
          '/GetTeamDetails': (BuildContext context) => new CreateTeamPage(),
          '/EditProfile': (BuildContext context) => new EditProfileScreen(),
          '/CreateSkills': (BuildContext context) => new CreateSkills(),
          '/CreateWorkshop': (BuildContext context) => new CreateClass(),
          '/SkillDetailsPage': (BuildContext context) => new SkillDetailsMain(),
          '/ClassDetailsPage': (BuildContext context) => new ClassDetailsMain(),
          '/ShowUsersPosts': (BuildContext context) => new ShowUsersPosts(),
          '/TeamDetailsMain': (BuildContext context) => new TeamDetailsMain(),
          '/SkillsPage': (BuildContext context) => new SkillsPage(),
          '/ShowUserMadeClassesMain': (BuildContext context) =>
              new ShowUserMadeClassesMain(),
          '/ShowUserMadeSkillsMain': (BuildContext context) =>
              new ShowUserMadeSkillsMain(),
          '/ShowUserMadeTeamsMain': (BuildContext context) =>
              new ShowUserMadeTeamsMain(),
          '/OtherUserProfile': (BuildContext context) => new OtherUserProfile(),
          '/ShowFollowingUsers': (BuildContext context) =>
              new ShowFollowingUsers(),
          '/ShowFollowers': (BuildContext context) => new ShowFollowers(),
          '/NewHomePage': (BuildContext context) => new NewHomePage(),
          '/MessageTabHolder': (BuildContext context) => new MessageTabHolder(),
        },
        home: Wrapper(),
      ),
    );
  }
}
