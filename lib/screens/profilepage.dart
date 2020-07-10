import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:virtualclass/constants.dart';
import 'package:virtualclass/modals/userModal.dart';
import 'package:virtualclass/services/fStoreCollection.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Myusers _myusers;
  Future<File> imageFile;
  bool _showProgress = false;
  FirebaseUser user;

  pickImageFromGallery() {
    setState(() {
      imageFile = ImagePicker.pickImage(source: ImageSource.gallery);
      if (imageFile != null) {
        _showProgress = true;
        uploadPic(context);
      } else {
        _showProgress = false;
      }
    });
  }

  void showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Profile Updated"),
      content: Text('Updated Succesfully'),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future uploadPic(BuildContext context) async {
    _showProgress = true;
    String fileName;
    File img;
    Uuid uuid = new Uuid();
    await imageFile.then((onValue) {
      fileName = uuid.v1() + onValue.path.split('/').last;
      print('>>>>>>>>>>> File NAMe' + fileName);
      img = onValue;
    });
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('images/').child(fileName);

    final StorageUploadTask uploadTask = storageReference.putFile(img);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    setState(() {
      print("Profile Picture uploaded");
    });
    new DbUserCollection(user.uid)
        .updateuserProfilerPic(fileName, uuid, user.uid)
        .then((onValue) {
      setState(() {
        _showProgress = false;
      });
      showAlertDialog(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    _myusers = ModalRoute.of(context).settings.arguments;
    user = Provider.of<FirebaseUser>(context);
    _showProgress = false;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * .30,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [kPrimaryColor, kPrimaryColor]),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * .70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(Icons.arrow_back_ios),
                                ),
                                elevation: 5,
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                pickImageFromGallery();
                              },
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  _myusers.profile_url,
                                ),
                                radius: 40.0,
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                navToEditprofile(_myusers);
                              },
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.mode_edit,
                                    color: Colors.black,
                                  ),
                                ),
                                elevation: 5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        _myusers.name,
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        _myusers.email,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: new EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * .23,
                    left: 5,
                    right: 5,
                  ),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    color: Colors.white,
                    elevation: 5.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 22.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "Posts",
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _myusers.noOfPost.toString(),
                                  style: TextStyle(
                                    fontSize: 14.0,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "Followers",
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _myusers.followers.toString(),
                                  style: TextStyle(fontSize: 14.0),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "Following",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  _myusers.following.toString(),
                                  style: TextStyle(fontSize: 14.0),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: new EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * .40,
                    left: 5,
                    right: 5,
                  ),
                  child: Text(
                    'Personal Details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
                  ),
                ),
                Padding(
                  padding: new EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * .45,
                    left: 5,
                    right: 5,
                  ),
                  child: Text(
                    'Phone Number  ' + _myusers.phone,
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 13),
                  ),
                ),
                Padding(
                  padding: new EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * .50,
                    left: 5,
                    right: 5,
                  ),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(
                          Icons.desktop_mac,
                          color: Colors.black,
                        ),
                        title: Text('Skills'),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.stay_current_landscape,
                          color: Colors.black,
                        ),
                        title: Text('Classes'),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.group,
                          color: Colors.black,
                        ),
                        title: Text('Teams'),
                      )
                    ],
                  ),
                ),
                _showProgress
                    ? Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.only(top: 45.0),
                        child: Center(child: Text('')),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void navToEditprofile(Myusers myusers) {
    Navigator.pushNamed(context, '/EditProfile', arguments: myusers);
  }
}
