import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:virtualclass/modals/postsmodal.dart';
import 'package:virtualclass/modals/userModal.dart';
import 'package:virtualclass/screens/networkVidScreen.dart';
import 'package:virtualclass/screens/timeService.dart';
import 'package:virtualclass/services/fStoreCollection.dart';

import '../constants.dart';

class ClassPosts extends StatefulWidget {
  ClassPosts({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _ClassPostsState createState() => _ClassPostsState();
}

class _ClassPostsState extends State<ClassPosts> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Myusers _myusers;

  var uuid = Uuid();
  Set<String> _liked_Posts;
  List<String> _likedPost_list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _liked_Posts = new Set();
  }

  getpostsmadeInClass(String skillId) async {
    var fireStore = Firestore.instance;
    QuerySnapshot qn = await fireStore
        .collection('posts')
        .orderBy('time_uploaded', descending: true)
        .getDocuments();
    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'Make New Post',
        onPressed: () {
          Navigator.pushNamed(context, '/MakePostScreen',
              arguments: widget.title);
          //TODO : make Post In Ski8ll
        },
        backgroundColor: kPrimaryColor,
        child: Icon(Icons.image),
      ),
      body: FutureBuilder(
        future: getpostsmadeInClass(widget.title),
        builder: (_, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            // ignore: missing_return
            return Center(
              child: Text('Loading ....'),
            );
          } else {
            return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapShot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return snapShot.data[index].data['assigned_with'] ==
                          widget.title
                      ? Column(
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
                                        backgroundImage: NetworkImage(snapShot
                                            .data[index].data['profile_url']),
                                      ),
                                      title: Text(snapShot.data[index]
                                          .data['user_id_who_posted']),
                                      subtitle: Text(convertTimeStamp(snapShot
                                          .data[index].data['time_uploaded'])),
                                      trailing: _liked_Posts.contains(snapShot
                                              .data[index].data['post_id']
                                              .toString())
                                          ? GestureDetector(
                                              onTap: () {
                                                _liked_Posts.remove(snapShot
                                                    .data[index].data['post_id']
                                                    .toString());
                                                _likedPost_list.clear();
                                                _liked_Posts.forEach((ele) {
                                                  _likedPost_list.add(ele);
                                                });

                                                new DbUserCollection(user.uid)
                                                    .updateLikesinUser(user.uid,
                                                        _likedPost_list);

                                                new DbUserCollection(user.uid)
                                                    .removeLikeInPost(snapShot
                                                        .data[index]
                                                        .data['post_id']
                                                        .toString())
                                                    .then((onValue) {
                                                  setState(() {});
                                                });
                                              },
                                              child: Column(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.favorite,
                                                    color: Colors.red,
                                                  ),
                                                  Text(snapShot
                                                      .data[index].data['likes']
                                                      .toString()),
                                                ],
                                              ),
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                _liked_Posts.add(snapShot
                                                    .data[index].data['post_id']
                                                    .toString());
                                                _likedPost_list.clear();
                                                _liked_Posts.forEach((ele) {
                                                  _likedPost_list.add(ele);
                                                });
                                                new DbUserCollection(user.uid)
                                                    .updateLikesinUser(user.uid,
                                                        _likedPost_list);
                                                new DbUserCollection(user.uid)
                                                    .addLikeInPost(snapShot
                                                        .data[index]
                                                        .data['post_id']
                                                        .toString())
                                                    .then((onValue) {
                                                  setState(() {});
                                                });
                                              },
                                              child: Column(children: <Widget>[
                                                Icon(Icons.favorite_border),
                                                Text(snapShot
                                                    .data[index].data['likes']
                                                    .toString()),
                                              ]),
                                            ),
                                    ),
                                    Text(snapShot.data[index].data['content']),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    snapShot.data[index].data['is_image']
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.network(
                                              snapShot
                                                  .data[index].data['image_url']
                                                  .toString(),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  3,
                                              scale: 1.0,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              alignment: Alignment.center,
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  3,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: NetworkPlayer(snapShot
                                                  .data[index].data['image_url']
                                                  .toString()),
                                            ),
                                          ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.comment,
                                            color: Colors.black38,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(snapShot.data[index]
                                                      .data['comments'].length >
                                                  1
                                              ? '${snapShot.data[index].data['comments'].length} Comments'
                                              : ' ${snapShot.data[index].data['comments'].length} Comment'),
                                          Spacer(),
                                          GestureDetector(
                                            onTap: () {
                                              Post _post = new Post();
                                              _post.imageUrl = snapShot
                                                  .data[index]
                                                  .data['image_url'];
                                              _post.content = snapShot
                                                  .data[index].data['content'];
                                              _post.likes = snapShot
                                                  .data[index].data['likes'];
                                              _post.userIdWhoPosted = snapShot
                                                  .data[index]
                                                  .data['user_id_who_posted'];
                                              _post.comments = snapShot
                                                  .data[index].data['comments'];
                                              _post.postId = snapShot
                                                  .data[index].data['post_id'];
                                              _post.time_posted = snapShot
                                                  .data[index]
                                                  .data['time_uploaded'];

                                              _post.profile_url = snapShot
                                                  .data[index]
                                                  .data['profile_url'];
                                              _post.isImage = snapShot
                                                  .data[index].data['is_image'];

                                              navToCommentscreen(_post);
                                            },
                                            child: Text(
                                              'See Comments ',
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                        ],
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
                        )
                      : Text('');
                });
          }
        },
      ),
    );
  }

  String convertTimeStamp(var timeStamp) {
    DateTime t = timeStamp.toDate();
    return timeAgo(t);
  }

  void setPostLiked(String uid) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('users').document(uid).get();
    List<dynamic> userLiked = snapshot.data['post_liked'];

    for (int i = 0; i < userLiked.length; i++) {
      _liked_Posts.add(userLiked[i]);
    }
  }

  void navToCommentscreen(Post post) {
    Navigator.pushNamed(context, '/CommentScreen', arguments: post);
  }
}
