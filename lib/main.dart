import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:virtualclass/screens/commentsScreen.dart';
import 'package:virtualclass/screens/editProfileScreen.dart';
import 'package:virtualclass/screens/getTeamDetails.dart';
import 'package:virtualclass/screens/mainScreen.dart';
import 'package:virtualclass/screens/makePostScreen.dart';
import 'package:virtualclass/screens/profilepage.dart';
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
        },
        home: Wrapper(),
      ),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/welcome_image.jpeg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "VirtualSkill\n",
                          style: Theme.of(context).textTheme.display1,
                        ),
                        TextSpan(
                          text: "Learn Skills",
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 22,
                          ),
                        ),
                        TextSpan(
                          text: " For Better Life",
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FittedBox(
                    child: GestureDetector(
                      onTap: () {
                        if (user == null) {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return SignInScreen();
                            },
                          ));
                        } else {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/MainPage', (Route<dynamic> route) => false);
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 25),
                        padding:
                            EdgeInsets.symmetric(horizontal: 26, vertical: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: kPrimaryColor,
                        ),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "START LEARNING",
                              style:
                                  Theme.of(context).textTheme.button.copyWith(
                                        color: Colors.black,
                                      ),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.black,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
