import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/services.dart';
import 'package:virtualclass/constants.dart';
import 'package:virtualclass/screens/videoScreen.dart';
import 'package:virtualclass/services/fStoreCollection.dart';

class MakePostScreen extends StatefulWidget {
  @override
  _MakePostScreenState createState() => _MakePostScreenState();
}

class _MakePostScreenState extends State<MakePostScreen> {
  Future<File> imageFile;
  File videoFile;
  bool _showProgress = false;
  TextEditingController captnController = new TextEditingController();
  TextEditingController youTubeVideoLinkController =
      new TextEditingController();

  String caption;
  String uTubeLink;
  String vidFileName;
  FirebaseUser user;
  bool _islinkOk = false;
  Uuid uuid = new Uuid();
  StorageUploadTask _tasks;

  pickImageFromGallery(ImageSource source) {
    videoFile = null;
    _islinkOk = false;
    _tasks = null;
    setState(() {
      imageFile = ImagePicker.pickImage(source: source);
    });
  }

  pickVideofromGallery(ImageSource source) async {
    imageFile = null;
    _islinkOk = false;
    _tasks = null;
    File video = await ImagePicker.pickVideo(source: ImageSource.gallery);

    setState(() {
      videoFile = video;
    });
    new DownloadedVidPalyer(videoFile);
    uploadVid(context);
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
        .makePostWithIamge(fileName, uuid, caption, user.uid, assigedWith)
        .then((onValue) {
      setState(() {
        _showProgress = false;
      });
      showAlertDialog(context);
    });
  }

  Future uploadVid(BuildContext context) async {
    String _extension = videoFile.path.split('.').last;

    String fileName = uuid.v1() + videoFile.path.split('/').last;
    vidFileName = fileName;
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('videos/').child(fileName);

    final StorageUploadTask uploadTask = storageReference.putFile(
        videoFile,
        StorageMetadata(
          contentType: 'videos/$_extension',
        ));

    setState(() {
      _tasks = uploadTask;
    });
  }

  void showAlertDialog(BuildContext context) {
    setState(() {
      _showProgress = false;
    });

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
  void initState() {
    super.initState();
    _showProgress = false;
  }

  String assigedWith;

  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);
    assigedWith = ModalRoute.of(context).settings.arguments;
    Widget children;
    if (_tasks == null) {
    } else {
      children = getTaskDetail(_tasks);
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: PrimaryColor,
        child: Icon(Icons.send),
        onPressed: () async {
          FocusScope.of(context).unfocus();
          var result = await Connectivity().checkConnectivity();
          if (result == ConnectivityResult.none) {
            _showDialog('No internet', "You're not connected to a network");
          } else if (result == ConnectivityResult.mobile) {
            caption = captnController.text;
            if (caption.isEmpty) {
              _showDialog('Needed Caption', 'Share Some Thoughts');
            } else {
              if (imageFile != null) {
                setState(() {
                  _showProgress = true;
                });
                uploadPic(context);
              }
              if (videoFile != null) {
                setState(() {
                  _showProgress = true;
                });

                new DbUserCollection(user.uid)
                    .makePostWithVideo(vidFileName, uuid, caption, user.uid,
                        context, assigedWith)
                    .then((onValue) {
                  showAlertDialog(context);
                });
              }

              if (caption.isNotEmpty &&
                  imageFile == null &&
                  videoFile == null) {
                setState(() {
                  _showProgress = true;
                });

                new DbUserCollection(user.uid)
                    .makwPostWithCaption(
                        uuid, caption, user.uid, context, assigedWith)
                    .then((onValue) {
                  showAlertDialog(context);
                });
              }
            }
          } else if (result == ConnectivityResult.wifi) {
            caption = captnController.text;
            if (caption.isEmpty) {
              _showDialog('Needed Caption', 'Share Some Thoughts');
            } else {
              if (imageFile != null) {
                setState(() {
                  _showProgress = true;
                });
                uploadPic(context);
              }
              if (videoFile != null) {
                setState(() {
                  _showProgress = true;
                });

                new DbUserCollection(user.uid)
                    .makePostWithVideo(vidFileName, uuid, caption, user.uid,
                        context, assigedWith)
                    .then((onValue) {
                  showAlertDialog(context);
                });
              }
            }
          }
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
                    InkWell(
                      splashColor: PrimaryColor,
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.add_photo_alternate,
                            color: PrimaryColor,
                          ),
                          Text('Select Image')
                        ],
                      ),
                      onTap: () {
                        pickImageFromGallery(ImageSource.gallery);
                      },
                    ),
                    Spacer(),
                    InkWell(
                        splashColor: PrimaryColor,
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.ondemand_video,
                              color: PrimaryColor,
                            ),
                            Text('Select Video')
                          ],
                        ),
                        onTap: () {
                          pickVideofromGallery(ImageSource.gallery);
                        }),
                    Spacer(),
                    InkWell(
                      splashColor: PrimaryColor,
                      child: Column(
                        children: <Widget>[
                          Icon(
                            Icons.insert_link,
                            color: PrimaryColor,
                          ),
                          Text('YouTube Link'),
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          _islinkOk = true;
                        });
                      },
                    ),
                  ],
                ),
              ),
              _islinkOk
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        controller: youTubeVideoLinkController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                          hintText: "YouTube Video Link...",
                        ),
                      ),
                    )
                  : Text(''),
              _showProgress ? CircularProgressIndicator() : Text(''),
              SizedBox(
                height: 5,
              ),
              Container(
                child: children,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: showImage(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: showVideo(),
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
                  color: PrimaryColor,
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

  Widget showVideo() {
    return videoFile == null
        ? Text('')
        : Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4,
            child: Stack(
              children: <Widget>[
                DownloadedVidPalyer(videoFile),
                IconButton(
                  icon: Icon(
                    Icons.cancel,
                    color: PrimaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      videoFile = null;
                      _showProgress = false;
                    });
                  },
                ),
              ],
            ));
  }

  _showDialog(title, text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Widget getTaskDetail(StorageUploadTask tasks) {
    return UploadTaskListTile(
      task: _tasks,
      onDismissed: _ondismissed(),
      onDownload: null,
    );
  }

  _ondismissed() {
    setState(() {
      _tasks = null;
    });
  }
}

class UploadTaskListTile extends StatelessWidget {
  const UploadTaskListTile(
      {Key key, this.task, this.onDismissed, this.onDownload})
      : super(key: key);

  final StorageUploadTask task;
  final VoidCallback onDismissed;
  final VoidCallback onDownload;

  String get status {
    String result;
    if (task.isComplete) {
      if (task.isSuccessful) {
        result = 'Complete';
      } else if (task.isCanceled) {
        result = 'Canceled';
      } else {
        result = 'Failed ERROR: ${task.lastSnapshot.error}';
      }
    } else if (task.isInProgress) {
      result = 'Uploading';
    } else if (task.isPaused) {
      result = 'Paused';
    }
    return result;
  }

  String _bytesTransferred(StorageTaskSnapshot snapshot) {
    return '${snapshot.bytesTransferred / snapshot.totalByteCount * 100}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StorageTaskEvent>(
      stream: task.events,
      builder: (BuildContext context,
          AsyncSnapshot<StorageTaskEvent> asyncSnapshot) {
        Widget subtitle;
        if (asyncSnapshot.hasData) {
          final StorageTaskEvent event = asyncSnapshot.data;
          final StorageTaskSnapshot snapshot = event.snapshot;
          subtitle = Text('$status: ${_bytesTransferred(snapshot)}  %');
        } else {
          subtitle = const Text('Starting...');
        }
        return Dismissible(
          key: Key(task.hashCode.toString()),
          onDismissed: (_) => onDismissed(),
          child: ListTile(
            title: Text('Uploading Your Video...'),
            subtitle: subtitle,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Offstage(
                  offstage: !task.isInProgress,
                  child: IconButton(
                    icon: const Icon(Icons.pause),
                    onPressed: () => task.pause(),
                  ),
                ),
                Offstage(
                  offstage: !task.isPaused,
                  child: IconButton(
                    icon: const Icon(Icons.file_upload),
                    onPressed: () => task.resume(),
                  ),
                ),
                Offstage(
                  offstage: task.isComplete,
                  child: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () => task.cancel(),
                  ),
                ),
                Offstage(
                  offstage: !(task.isComplete && task.isSuccessful),
                  child: IconButton(
                    icon: const Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                    onPressed: onDownload,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
