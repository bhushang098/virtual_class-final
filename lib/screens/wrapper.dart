import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualclass/main.dart';
import 'package:virtualclass/sign_in.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    return user == null ? SignInScreen() : WelcomeScreen();
  }
}
