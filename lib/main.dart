import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:virtualclass/detailsScreens/classDetailsMail.dart';
import 'package:virtualclass/detailsScreens/skillDetailsMain.dart';
import 'package:virtualclass/screens/commentsScreen.dart';
import 'package:virtualclass/screens/createSkillpage.dart';
import 'package:virtualclass/screens/createClass.dart';
import 'package:virtualclass/screens/editProfileScreen.dart';
import 'package:virtualclass/screens/getTeamDetails.dart';
import 'package:virtualclass/screens/mainScreen.dart';
import 'package:virtualclass/screens/makePostScreen.dart';
import 'package:virtualclass/screens/profilepage.dart';
import 'package:virtualclass/screens/showusersPost.dart';
import 'package:virtualclass/screens/welcomeScreen.dart';
import 'package:virtualclass/screens/wrapper.dart';
import 'package:virtualclass/services/authentication.dart';
import 'constants.dart';
import 'sign_in.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value(
      value: Auth().user,
      child: MaterialApp(
        title: 'Virtual Class',
        theme: ThemeData(
//        brightness: Brightness.dark,
          primaryColor: kPrimaryColor,
//        scaffoldBackgroundColor: kBackgroundColor,
          textTheme: TextTheme(
            display1:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            button: TextStyle(color: kPrimaryColor),
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
          '/GetTeamDetails': (BuildContext context) => new GetTeamDetails(),
          '/EditProfile': (BuildContext context) => new EditProfileScreen(),
          '/CreateSkills': (BuildContext context) => new CreateSkills(),
          '/CreateWorkshop': (BuildContext context) => new CreateClass(),
          '/SkillDetailsPage': (BuildContext context) => new SkillDetailsMain(),
          '/ClassDetailsPage': (BuildContext context) => new ClassDetailsMain(),
          '/ShowUsersPosts': (BuildContext context) => new ShowUsersPosts(),
        },
        home: Wrapper(),
      ),
    );
  }
}
