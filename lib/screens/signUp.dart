import 'package:flutter/material.dart';
import 'package:virtualclass/constants.dart';
import 'package:virtualclass/modals/userModal.dart';
import 'package:virtualclass/services/authentication.dart';
import 'package:virtualclass/services/fStoreCollection.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String mail, name, phone, pass1, pass2;
  int gender;
  final snackBar = SnackBar(content: Text('Password Not Matched'));

  TextEditingController mailController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController pass1Controller = new TextEditingController();
  TextEditingController pass2Controller = new TextEditingController();
  TextEditingController genderController = new TextEditingController();
  Auth _auth;
  Myusers _user;
  bool _obscureText = true;
  int selectedRadioTile;
  bool _ShowProgress = false;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth = new Auth();
    _user = new Myusers();
    selectedRadioTile = 0;
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/welcome_image.jpeg"),
                      fit: BoxFit.cover,
                      alignment: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Create Account ',
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Icon(
                      Icons.person,
                      color: kPrimaryColor,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                        hintText: "Full Name",
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Icon(
                      Icons.mail,
                      color: kPrimaryColor,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: mailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                        hintText: "Email Address",
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Icon(
                      Icons.phone,
                      color: kPrimaryColor,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                        hintText: "Mobile No",
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Icon(
                      Icons.lock,
                      color: kPrimaryColor,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      obscureText: _obscureText,
                      controller: pass1Controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                        hintText: "password",
                      ),
                    ),
                  ),
                  IconButton(
                    icon: _obscureText
                        ? Icon(
                            Icons.visibility_off,
                            color: kPrimaryColor,
                          )
                        : Icon(
                            Icons.visibility,
                            color: kPrimaryColor,
                          ),
                    onPressed: _toggle,
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Icon(
                      Icons.lock,
                      color: kPrimaryColor,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      obscureText: _obscureText,
                      controller: pass2Controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                        hintText: "conform Password",
                      ),
                    ),
                  ),
                  IconButton(
                    icon: _obscureText
                        ? Icon(
                            Icons.visibility_off,
                            color: kPrimaryColor,
                          )
                        : Icon(
                            Icons.visibility,
                            color: kPrimaryColor,
                          ),
                    onPressed: _toggle,
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Icon(
                      Icons.face,
                      color: kPrimaryColor,
                    ),
                  ),
                  RadioListTile(
                    value: 1,
                    groupValue: selectedRadioTile,
                    title: Text("Male"),
                    onChanged: (val) {
                      print(" Mail ");
                      setSelectedRadioTile(val);
                    },
                    activeColor: Colors.green,
                    selected: false,
                  ),
                  RadioListTile(
                    value: 2,
                    groupValue: selectedRadioTile,
                    title: Text("Female"),
                    onChanged: (val) {
                      print("Female");
                      setSelectedRadioTile(val);
                    },
                    activeColor: Colors.green,
                    selected: false,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                name = nameController.text;
                mail = mailController.text;
                phone = phoneController.text;
                pass1 = pass1Controller.text;
                pass2 = pass2Controller.text;
                gender = selectedRadioTile;

                if (mail.isEmpty ||
                    pass1.isEmpty ||
                    phone.isEmpty ||
                    pass2.isEmpty ||
                    gender.isNaN) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        // Retrieve the text the that user has entered by using the
                        // TextEditingController.
                        content: Text('provide all info'),
                      );
                    },
                  );
                } else {
                  if (pass2 == pass1) {
                    showProgressDialog();
                    dynamic user = await _auth.signUp(mail, pass1, context);

                    if (user == null) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      FocusScope.of(context).unfocus();
                      dynamic user = await _auth.signUp(mail, pass1, context);
                    }

                    if (user != null) {
                      // Push Deta To fireStore
                      setUserInitialDeta();
                      new DbUserCollection(user).pushUserDeta(_user);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/WelcomeScreen', (Route<dynamic> route) => false);
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          // Retrieve the text the that user has entered by using the
                          // TextEditingController.
                          content: Text('Password Not Matched'),
                        );
                      },
                    );
                    print('Password Not mached');
                  }
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 80),
                padding: EdgeInsets.symmetric(horizontal: 26, vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: kPrimaryColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Register",
                      style: Theme.of(context).textTheme.button.copyWith(
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
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  void setUserInitialDeta() {
    _user.name = name;
    _user.phone = phone;
    _user.email = mail;
    _user.noOfPost = 0;
    _user.followers = 0;
    _user.following = 0;
    _user.posts = [];
    _user.images = [];
    _user.videos = [];
    _user.links = [];
    _user.gender = gender == 1 ? true : false;
    _user.post_liked = [];
    _user.profile_url =
        'https://firebasestorage.googleapis.com/v0/b/virtual-class-2922d.appspot.com/o/dummy%20profile%2Fdefault-avatar-profile-icon-social-media-user-vector-default-avatar-profile-icon-social-media-user-vector-portrait-176194876.jpg?alt=media&token=0aecb938-9b35-495c-bcac-9a212b54711c';
  }

  Widget showProgressDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // Retrieve the text the that user has entered by using the
          // TextEditingController.
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Registering..'),
              CircularProgressIndicator(),
            ],
          ),
        );
      },
    );
  }
}
