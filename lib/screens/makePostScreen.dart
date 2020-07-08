import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:virtualclass/constants.dart';
import 'package:virtualclass/services/fStoreCollection.dart';

class MakePostScreen extends StatefulWidget {
  @override
  _MakePostScreenState createState() => _MakePostScreenState();
}

class _MakePostScreenState extends State<MakePostScreen> {
  Future<File> imageFile;
  bool _showProgress = false;
  TextEditingController captnController = new TextEditingController();
  String caption;
  FirebaseUser user;
  //Open gallery
  pickImageFromGallery(ImageSource source) {
    setState(() {
      imageFile = ImagePicker.pickImage(source: source);
    });
  }

  Future uploadPic(BuildContext context) async {
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
        .makePostWithIamge(fileName, uuid, caption, user.uid)
        .then((onValue) {
      setState(() {
        _showProgress = false;
      });
      showAlertDialog(context);
    });
  }

  void showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("See Your post"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Post Added"),
      content: Text('Thanks For Sharing your Thoughts '),
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

  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        child: Icon(Icons.send),
        onPressed: () {
          _showProgress = true;
          FocusScope.of(context).unfocus();
          caption = captnController.text;
          if (caption.isEmpty) {
            print('share some thoughts Before');
          } else {
            if (imageFile != null) {
              uploadPic(context);
            }
          }
          // makePostWithoutIamge();
        },
      ),
      appBar: AppBar(
        title: Text('Make New Post'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: (Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      child: Icon(
                        Icons.image,
                        color: Colors.black38,
                      ),
                      onTap: () {
                        pickImageFromGallery(ImageSource.gallery);
                      },
                    ),
                    Spacer(),
                    GestureDetector(
                      child: Icon(
                        Icons.ondemand_video,
                        color: Colors.black38,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      child: Icon(
                        Icons.insert_link,
                        color: Colors.black38,
                      ),
                    ),
                  ],
                ),
              ),
              _showProgress ? CircularProgressIndicator() : Text(''),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: showImage(),
              ),
              TextFormField(
                controller: captnController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Share Your Thoughts ...',
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return Stack(
            children: <Widget>[
              Image.file(
                snapshot.data,
                width: 300,
                height: 300,
              ),
              IconButton(
                icon: Icon(
                  Icons.cancel,
                  color: kPrimaryColor,
                ),
                onPressed: () {
                  setState(() {
                    imageFile = null;
                  });
                },
              ),
            ],
          );
        } else if (snapshot.error != null) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            '',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }
}
