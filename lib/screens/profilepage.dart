import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:virtualclass/services/fStoreCollection.dart';
import '../constants.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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

  getPofile(String uid) async {
    var fireStore = Firestore.instance;
    DocumentSnapshot dsn =
        await fireStore.collection('users').document(uid).get();
    return dsn;
  }

  @override
  Widget build(BuildContext context) {
    //_myusers = ModalRoute.of(context).settings.arguments;
    user = Provider.of<FirebaseUser>(context);
    _showProgress = false;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: getPofile(user.uid),
          builder: (_, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              // ignore: missing_return
              return Center(
                child: Text('Loading ....'),
              );
            } else {
              if (snapShot.data['is_teacher']) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * .36,
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 50),
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
                                          snapShot.data['profile_url'],
                                        ),
                                        radius: 40.0,
                                      ),
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        navToEditprofile();
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
                                snapShot.data['name'],
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                snapShot.data['email'],
                                style: TextStyle(color: Colors.white),
                              ),
                              RatingBar(
                                initialRating: 3,
                                minRating: 5,
                                direction: Axis.horizontal,
                                itemCount: 5,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 2.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.green,
                                ),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                },
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height / 9,
                          left: MediaQuery.of(context).size.width / 2,
                          child: Icon(
                            Icons.verified_user,
                            color: Colors.green,
                          ),
                        ),
                        Padding(
                          padding: new EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .28,
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
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/ShowUsersPosts');
                                    },
                                    child: Expanded(
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
                                            snapShot.data['posts'].length
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 14.0,
                                            ),
                                          )
                                        ],
                                      ),
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
                                          snapShot.data['followers'].length
                                              .toString(),
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
                                          snapShot.data['following'].length
                                              .toString(),
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
                            top: MediaQuery.of(context).size.height * .42,
                            left: 5,
                            right: 5,
                          ),
                          child: Text(
                            'Personal Details',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                        ),
                        Padding(
                          padding: new EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .46,
                            left: 5,
                            right: 5,
                          ),
                          child: Text(
                            'Phone Number  ' + snapShot.data['phone'],
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 13),
                          ),
                        ),
                        Padding(
                          padding: new EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .49,
                            left: 5,
                            right: 5,
                          ),
                          child: snapShot.data['gender']
                              ? Text(
                                  'Gender  Male',
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 13),
                                )
                              : Text(
                                  'Gender  Grmale',
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 13),
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
                                title: Text(
                                    'Skills Made  ${snapShot.data['skills_made'].length}'),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.stay_current_landscape,
                                  color: Colors.black,
                                ),
                                title: Text('Classes Made '),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.group,
                                  color: Colors.black,
                                ),
                                title: Text('Teams Made '),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.attach_money,
                                  color: Colors.black,
                                ),
                                title: Text('Earnings'),
                              ),
//                              Row(
//                                mainAxisSize: MainAxisSize.min,
//                                children: <Widget>[
//                                  Text('Posts'),
//                                  Text('likes')
//                                ],
//                              ),
//                              Container(
//                                width: 400,
//                                height: 400,
//                                child: GridView.count(
//                                  primary: false,
//                                  padding: const EdgeInsets.all(4),
//                                  crossAxisSpacing: 4,
//                                  mainAxisSpacing: 4,
//                                  crossAxisCount: 2,
//                                  children: [
//                                    Padding(
//                                      padding: const EdgeInsets.all(8.0),
//                                      child: Container(
//                                        padding: const EdgeInsets.all(2),
//                                        child: Center(
//                                          child: Card(
//                                            color: Colors.blue,
//                                            elevation: 6,
//                                            child: Column(
//                                              children: <Widget>[
//                                                SizedBox(
//                                                  height: 20,
//                                                ),
//                                                Text(
//                                                  '30 K',
//                                                  style: TextStyle(
//                                                      fontSize: 30,
//                                                      color: Colors.white,
//                                                      fontWeight:
//                                                          FontWeight.bold),
//                                                ),
//                                                SizedBox(
//                                                  height: 20,
//                                                ),
//                                                Text(
//                                                  'Total Users',
//                                                  style: TextStyle(
//                                                      fontSize: 18,
//                                                      color: Colors.white),
//                                                ),
//                                                Padding(
//                                                  padding:
//                                                      const EdgeInsets.only(
//                                                          top: 16.0,
//                                                          right: 5,
//                                                          left: 5),
//                                                  child: Container(
//                                                    color: Colors.blue[300],
//                                                    child: Row(
//                                                      mainAxisAlignment:
//                                                          MainAxisAlignment
//                                                              .center,
//                                                      children: <Widget>[
//                                                        Text(
//                                                          'More Info',
//                                                          style: TextStyle(
//                                                              fontSize: 12,
//                                                              color:
//                                                                  Colors.white),
//                                                        ),
//                                                        SizedBox(
//                                                          width: 10,
//                                                        ),
//                                                        Icon(
//                                                          Icons
//                                                              .arrow_forward_ios,
//                                                          color: Colors.white,
//                                                          size: 12,
//                                                        ),
//                                                      ],
//                                                    ),
//                                                  ),
//                                                )
//                                              ],
//                                            ),
//                                          ),
//                                        ),
//                                      ),
//                                    ),
//                                    Padding(
//                                      padding: const EdgeInsets.all(8.0),
//                                      child: Container(
//                                        padding: const EdgeInsets.all(2),
//                                        child: Center(
//                                          child: Card(
//                                            color: Colors.green,
//                                            elevation: 6,
//                                            child: Column(
//                                              children: <Widget>[
//                                                SizedBox(
//                                                  height: 20,
//                                                ),
//                                                Text(
//                                                  '200',
//                                                  style: TextStyle(
//                                                      fontSize: 30,
//                                                      color: Colors.white,
//                                                      fontWeight:
//                                                          FontWeight.bold),
//                                                ),
//                                                SizedBox(
//                                                  height: 20,
//                                                ),
//                                                Text(
//                                                  'Total Classes',
//                                                  style: TextStyle(
//                                                      fontSize: 18,
//                                                      color: Colors.white),
//                                                ),
//                                                Padding(
//                                                  padding:
//                                                      const EdgeInsets.only(
//                                                          top: 16.0,
//                                                          right: 5,
//                                                          left: 5),
//                                                  child: Container(
//                                                    color: Colors.green[300],
//                                                    child: Row(
//                                                      mainAxisAlignment:
//                                                          MainAxisAlignment
//                                                              .center,
//                                                      children: <Widget>[
//                                                        Text(
//                                                          'More Info',
//                                                          style: TextStyle(
//                                                              fontSize: 12,
//                                                              color:
//                                                                  Colors.white),
//                                                        ),
//                                                        SizedBox(
//                                                          width: 10,
//                                                        ),
//                                                        Icon(
//                                                          Icons
//                                                              .arrow_forward_ios,
//                                                          color: Colors.white,
//                                                          size: 12,
//                                                        ),
//                                                      ],
//                                                    ),
//                                                  ),
//                                                )
//                                              ],
//                                            ),
//                                          ),
//                                        ),
//                                      ),
//                                    ),
//                                    Padding(
//                                      padding: const EdgeInsets.all(8.0),
//                                      child: Container(
//                                        padding: const EdgeInsets.all(2),
//                                        child: Center(
//                                          child: Card(
//                                            color: Colors.amber,
//                                            elevation: 6,
//                                            child: Column(
//                                              children: <Widget>[
//                                                SizedBox(
//                                                  height: 20,
//                                                ),
//                                                Text(
//                                                  '127',
//                                                  style: TextStyle(
//                                                      fontSize: 30,
//                                                      color: Colors.white,
//                                                      fontWeight:
//                                                          FontWeight.bold),
//                                                ),
//                                                SizedBox(
//                                                  height: 20,
//                                                ),
//                                                Text(
//                                                  'Total Skills',
//                                                  style: TextStyle(
//                                                      fontSize: 18,
//                                                      color: Colors.white),
//                                                ),
//                                                Padding(
//                                                  padding:
//                                                      const EdgeInsets.only(
//                                                          top: 16.0,
//                                                          right: 5,
//                                                          left: 5),
//                                                  child: Container(
//                                                    color: Colors.amber[300],
//                                                    child: Row(
//                                                      mainAxisAlignment:
//                                                          MainAxisAlignment
//                                                              .center,
//                                                      children: <Widget>[
//                                                        Text(
//                                                          'More Info',
//                                                          style: TextStyle(
//                                                              fontSize: 12,
//                                                              color:
//                                                                  Colors.white),
//                                                        ),
//                                                        SizedBox(
//                                                          width: 10,
//                                                        ),
//                                                        Icon(
//                                                          Icons
//                                                              .arrow_forward_ios,
//                                                          color: Colors.white,
//                                                          size: 12,
//                                                        ),
//                                                      ],
//                                                    ),
//                                                  ),
//                                                )
//                                              ],
//                                            ),
//                                          ),
//                                        ),
//                                      ),
//                                    ),
//                                    Padding(
//                                      padding: const EdgeInsets.all(8.0),
//                                      child: Container(
//                                        padding: const EdgeInsets.all(2),
//                                        child: Center(
//                                          child: Card(
//                                            color: Colors.deepOrange,
//                                            elevation: 6,
//                                            child: Column(
//                                              children: <Widget>[
//                                                SizedBox(
//                                                  height: 20,
//                                                ),
//                                                Text(
//                                                  '20 ',
//                                                  style: TextStyle(
//                                                      fontSize: 30,
//                                                      color: Colors.white,
//                                                      fontWeight:
//                                                          FontWeight.bold),
//                                                ),
//                                                SizedBox(
//                                                  height: 20,
//                                                ),
//                                                Text(
//                                                  'Total Teams',
//                                                  style: TextStyle(
//                                                      fontSize: 18,
//                                                      color: Colors.white),
//                                                ),
//                                                Padding(
//                                                  padding:
//                                                      const EdgeInsets.only(
//                                                          top: 16.0,
//                                                          right: 5,
//                                                          left: 5),
//                                                  child: Container(
//                                                    color:
//                                                        Colors.deepOrange[300],
//                                                    child: Row(
//                                                      mainAxisAlignment:
//                                                          MainAxisAlignment
//                                                              .center,
//                                                      children: <Widget>[
//                                                        Text(
//                                                          'More Info',
//                                                          style: TextStyle(
//                                                              fontSize: 12,
//                                                              color:
//                                                                  Colors.white),
//                                                        ),
//                                                        SizedBox(
//                                                          width: 10,
//                                                        ),
//                                                        Icon(
//                                                          Icons
//                                                              .arrow_forward_ios,
//                                                          color: Colors.white,
//                                                          size: 12,
//                                                        ),
//                                                      ],
//                                                    ),
//                                                  ),
//                                                )
//                                              ],
//                                            ),
//                                          ),
//                                        ),
//                                      ),
//                                    ),
//                                    Padding(
//                                      padding: const EdgeInsets.all(8.0),
//                                      child: Container(
//                                        padding: const EdgeInsets.all(2),
//                                        child: Center(
//                                          child: Card(
//                                            color: Colors.blue,
//                                            elevation: 6,
//                                            child: Column(
//                                              children: <Widget>[
//                                                SizedBox(
//                                                  height: 20,
//                                                ),
//                                                Text(
//                                                  '30K',
//                                                  style: TextStyle(
//                                                      fontSize: 30,
//                                                      color: Colors.white,
//                                                      fontWeight:
//                                                          FontWeight.bold),
//                                                ),
//                                                SizedBox(
//                                                  height: 20,
//                                                ),
//                                                Text(
//                                                  'Total Users',
//                                                  style: TextStyle(
//                                                      fontSize: 18,
//                                                      color: Colors.white),
//                                                ),
//                                                Padding(
//                                                  padding:
//                                                      const EdgeInsets.only(
//                                                          top: 16.0,
//                                                          right: 5,
//                                                          left: 5),
//                                                  child: Container(
//                                                    color: Colors.blue[300],
//                                                    child: Row(
//                                                      mainAxisAlignment:
//                                                          MainAxisAlignment
//                                                              .center,
//                                                      children: <Widget>[
//                                                        Text(
//                                                          'More Info',
//                                                          style: TextStyle(
//                                                              fontSize: 12,
//                                                              color:
//                                                                  Colors.white),
//                                                        ),
//                                                        SizedBox(
//                                                          width: 10,
//                                                        ),
//                                                        Icon(
//                                                          Icons
//                                                              .arrow_forward_ios,
//                                                          color: Colors.white,
//                                                          size: 12,
//                                                        ),
//                                                      ],
//                                                    ),
//                                                  ),
//                                                )
//                                              ],
//                                            ),
//                                          ),
//                                        ),
//                                      ),
//                                    ),
//                                    Padding(
//                                      padding: const EdgeInsets.all(8.0),
//                                      child: Container(
//                                        padding: const EdgeInsets.all(2),
//                                        child: Center(
//                                          child: Card(
//                                            color: Colors.blue,
//                                            elevation: 6,
//                                            child: Column(
//                                              children: <Widget>[
//                                                SizedBox(
//                                                  height: 20,
//                                                ),
//                                                Text(
//                                                  '30K',
//                                                  style: TextStyle(
//                                                      fontSize: 30,
//                                                      color: Colors.white,
//                                                      fontWeight:
//                                                          FontWeight.bold),
//                                                ),
//                                                SizedBox(
//                                                  height: 20,
//                                                ),
//                                                Text(
//                                                  'Total Users',
//                                                  style: TextStyle(
//                                                      fontSize: 18,
//                                                      color: Colors.white),
//                                                ),
//                                                Padding(
//                                                  padding:
//                                                      const EdgeInsets.only(
//                                                          top: 16.0,
//                                                          right: 5,
//                                                          left: 5),
//                                                  child: Container(
//                                                    color: Colors.blue[300],
//                                                    child: Row(
//                                                      mainAxisAlignment:
//                                                          MainAxisAlignment
//                                                              .center,
//                                                      children: <Widget>[
//                                                        Text(
//                                                          'More Info',
//                                                          style: TextStyle(
//                                                              fontSize: 12,
//                                                              color:
//                                                                  Colors.white),
//                                                        ),
//                                                        SizedBox(
//                                                          width: 10,
//                                                        ),
//                                                        Icon(
//                                                          Icons
//                                                              .arrow_forward_ios,
//                                                          color: Colors.white,
//                                                          size: 12,
//                                                        ),
//                                                      ],
//                                                    ),
//                                                  ),
//                                                )
//                                              ],
//                                            ),
//                                          ),
//                                        ),
//                                      ),
//                                    ),
//                                    Padding(
//                                      padding: const EdgeInsets.all(8.0),
//                                      child: Container(
//                                        padding: const EdgeInsets.all(2),
//                                        child: Center(
//                                          child: Card(
//                                            color: Colors.blue,
//                                            elevation: 6,
//                                            child: Column(
//                                              children: <Widget>[
//                                                SizedBox(
//                                                  height: 20,
//                                                ),
//                                                Text(
//                                                  '30K',
//                                                  style: TextStyle(
//                                                      fontSize: 30,
//                                                      color: Colors.white,
//                                                      fontWeight:
//                                                          FontWeight.bold),
//                                                ),
//                                                SizedBox(
//                                                  height: 20,
//                                                ),
//                                                Text(
//                                                  'Total Users',
//                                                  style: TextStyle(
//                                                      fontSize: 18,
//                                                      color: Colors.white),
//                                                ),
//                                                Padding(
//                                                  padding:
//                                                      const EdgeInsets.only(
//                                                          top: 16.0,
//                                                          right: 5,
//                                                          left: 5),
//                                                  child: Container(
//                                                    color: Colors.blue[300],
//                                                    child: Row(
//                                                      mainAxisAlignment:
//                                                          MainAxisAlignment
//                                                              .center,
//                                                      children: <Widget>[
//                                                        Text(
//                                                          'More Info',
//                                                          style: TextStyle(
//                                                              fontSize: 12,
//                                                              color:
//                                                                  Colors.white),
//                                                        ),
//                                                        SizedBox(
//                                                          width: 10,
//                                                        ),
//                                                        Icon(
//                                                          Icons
//                                                              .arrow_forward_ios,
//                                                          color: Colors.white,
//                                                          size: 12,
//                                                        ),
//                                                      ],
//                                                    ),
//                                                  ),
//                                                )
//                                              ],
//                                            ),
//                                          ),
//                                        ),
//                                      ),
//                                    ),
//                                    Padding(
//                                      padding: const EdgeInsets.all(8.0),
//                                      child: Container(
//                                        padding: const EdgeInsets.all(2),
//                                        child: Center(
//                                          child: Card(
//                                            color: Colors.blue,
//                                            elevation: 6,
//                                            child: Column(
//                                              children: <Widget>[
//                                                SizedBox(
//                                                  height: 20,
//                                                ),
//                                                Text(
//                                                  '30K',
//                                                  style: TextStyle(
//                                                      fontSize: 30,
//                                                      color: Colors.white,
//                                                      fontWeight:
//                                                          FontWeight.bold),
//                                                ),
//                                                SizedBox(
//                                                  height: 20,
//                                                ),
//                                                Text(
//                                                  'Total Users',
//                                                  style: TextStyle(
//                                                      fontSize: 18,
//                                                      color: Colors.white),
//                                                ),
//                                                Padding(
//                                                  padding:
//                                                      const EdgeInsets.only(
//                                                          top: 16.0,
//                                                          right: 5,
//                                                          left: 5),
//                                                  child: Container(
//                                                    color: Colors.blue[300],
//                                                    child: Row(
//                                                      mainAxisAlignment:
//                                                          MainAxisAlignment
//                                                              .center,
//                                                      children: <Widget>[
//                                                        Text(
//                                                          'More Info',
//                                                          style: TextStyle(
//                                                              fontSize: 12,
//                                                              color:
//                                                                  Colors.white),
//                                                        ),
//                                                        SizedBox(
//                                                          width: 10,
//                                                        ),
//                                                        Icon(
//                                                          Icons
//                                                              .arrow_forward_ios,
//                                                          color: Colors.white,
//                                                          size: 12,
//                                                        ),
//                                                      ],
//                                                    ),
//                                                  ),
//                                                )
//                                              ],
//                                            ),
//                                          ),
//                                        ),
//                                      ),
//                                    ),
//                                  ],
//                                ),
//                              ),
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
                );
              } else {
                return SingleChildScrollView(
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 50),
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
                                          snapShot.data['profile_url'],
                                        ),
                                        radius: 40.0,
                                      ),
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        navToEditprofile();
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
                                snapShot.data['name'],
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                snapShot.data['email'],
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
                                          snapShot.data['posts'].length
                                              .toString(),
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
                                          snapShot.data['followers'].length
                                              .toString(),
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
                                          snapShot.data['following'].length
                                              .toString(),
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
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                        ),
                        Padding(
                          padding: new EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * .45,
                            left: 5,
                            right: 5,
                          ),
                          child: Text(
                            'Phone Number  ' + snapShot.data['phone'],
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 13),
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
                                title: Text('Skills Joined'),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.stay_current_landscape,
                                  color: Colors.black,
                                ),
                                title: Text('Classes Joined'),
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.group,
                                  color: Colors.black,
                                ),
                                title: Text('Teams Created'),
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
                );
              }
            }
          },
        ),
      ),
    );
  }

  void navToEditprofile() {
    Navigator.pushNamed(
      context,
      '/EditProfile',
    );
  }
}
