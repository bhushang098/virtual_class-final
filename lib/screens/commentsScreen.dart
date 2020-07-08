import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualclass/modals/postsmodal.dart';
import 'package:virtualclass/screens/timeService.dart';
import 'package:virtualclass/services/fStoreCollection.dart';

class CommentsScreen extends StatefulWidget {
  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  Post _post;
  Map<String, dynamic> _comments;
  List<dynamic> _userComment;
  List<dynamic> _userNames;
  String comment;
  TextEditingController commentController = new TextEditingController();
  FirebaseUser user;

  @override
  void initState() {
    super.initState();
    _userComment = [];
    _userNames = [];
  }

  @override
  Widget build(BuildContext context) {
    _post = ModalRoute.of(context).settings.arguments;
    user = Provider.of<FirebaseUser>(context);
    _comments = _post.comments;
    _userNames.clear();
    _userComment.clear();
    setcomments(_comments);
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 3,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: CircleAvatar(
                        radius: 15,
                        backgroundImage: NetworkImage(_post.profile_url),
                      ),
                      title: Text(
                        _post.userIdWhoPosted,
                      ),
                      subtitle: Text(convertTimeStamp(_post.time_posted)),
                      trailing: Column(
                        children: <Widget>[
                          Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          Text(_post.likes.toString()),
                        ],
                      ),
                    ),
                    Text(_post.content),
                    Image.network(_post.imageUrl),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.comment,
                            color: Colors.black38,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextField(
                                controller: commentController,
                                decoration:
                                    InputDecoration(hintText: 'Write Comment')),
                          ),
                          Spacer(),
                          GestureDetector(
                              child: Icon(
                                Icons.send,
                                color: Colors.black38,
                              ),
                              onTap: () {
                                comment = commentController.text;
                                if (comment.isEmpty) {
                                } else {
                                  setState(() {
                                    FocusScope.of(context).unfocus();
                                    new DbUserCollection(user.uid)
                                        .addcomment(
                                            comment, user.uid, _post.postId)
                                        .then((onValue) {
                                      showAlertDialog(context);
                                    });
                                  });
                                }
                              }),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5),
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: _userComment.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      _userNames[index].split('>>.>>').first),
                                  radius: 20,
                                ),
                                title: Text(
                                  _userNames[index].split('>>.>>').last,
                                  style: TextStyle(fontSize: 14),
                                ),
                                subtitle: Text(_userComment[index]),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 3,
            ),
          ],
        ),
      ),
    );
  }

  String convertTimeStamp(var timeStamp) {
    DateTime t = timeStamp.toDate();
    return timeAgo(t);
  }

  void setcomments(Map<String, dynamic> comments) {
    for (var singleuser in comments.keys) {
      _userNames.add(singleuser);
      _userComment.add(comments[singleuser]);
    }
  }

  void showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("Ok"),
      onPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Comment Added"),
      content: Text('Thanks For Posting Your Comment '),
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
}
