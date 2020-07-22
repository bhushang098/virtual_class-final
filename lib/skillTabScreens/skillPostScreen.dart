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
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../constants.dart';

class SkillPostScreen extends StatefulWidget {
  SkillPostScreen({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _SkillPostScreenState createState() => _SkillPostScreenState();
}

class _SkillPostScreenState extends State<SkillPostScreen>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Myusers _myusers;
  YoutubePlayerController _controller;

  var uuid = Uuid();
  Set<String> _liked_Posts;
  List<String> _likedPost_list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _liked_Posts = new Set();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    super.build(context);
    setPostLiked(user.uid);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'Make New Post',
        onPressed: () {
          Navigator.pushNamed(context, '/MakePostScreen',
              arguments: widget.title);
          //TODO : make Post In Ski8ll
        },
        backgroundColor: PrimaryColor,
        child: Icon(Icons.image),
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('posts')
            .orderBy('time_uploaded', descending: true)
            .snapshots(),
        builder: (_, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            // ignore: missing_return
            return Center(
              child: Text('Loading ....'),
            );
          } else {
            return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapShot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  return snapShot.data.documents[index].data['assigned_with'] ==
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
                                            .data
                                            .documents[index]
                                            .data['profile_url']),
                                      ),
                                      title: Text(snapShot.data.documents[index]
                                          .data['user_id_who_posted']
                                          .split('??.??')
                                          .first),
                                      subtitle: Text(convertTimeStamp(snapShot
                                          .data
                                          .documents[index]
                                          .data['time_uploaded'])),
                                      trailing: snapShot.data.documents[index]
                                              .data['likes']
                                              .contains(user.uid)
                                          ? GestureDetector(
                                              onTap: () {
                                                List<dynamic> userWhoLiked =
                                                    snapShot
                                                        .data
                                                        .documents[index]
                                                        .data['likes'];

                                                userWhoLiked.remove(user.uid);

                                                new DbUserCollection(user.uid)
                                                    .updateLikeInPost(
                                                        snapShot
                                                            .data
                                                            .documents[index]
                                                            .data['post_id']
                                                            .toString(),
                                                        userWhoLiked)
                                                    .then((onValue) {});
                                              },
                                              child: Column(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.favorite,
                                                    color: Colors.red,
                                                  ),
                                                  Text(snapShot
                                                      .data
                                                      .documents[index]
                                                      .data['likes']
                                                      .length
                                                      .toString()),
                                                ],
                                              ),
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                List<dynamic> userWhoLiked =
                                                    snapShot
                                                        .data
                                                        .documents[index]
                                                        .data['likes'];
                                                userWhoLiked.add(user.uid);

                                                new DbUserCollection(user.uid)
                                                    .updateLikeInPost(
                                                        snapShot
                                                            .data
                                                            .documents[index]
                                                            .data['post_id']
                                                            .toString(),
                                                        userWhoLiked)
                                                    .then((onValue) {});
                                              },
                                              child: Column(children: <Widget>[
                                                Icon(Icons.favorite_border),
                                                Text(snapShot
                                                    .data
                                                    .documents[index]
                                                    .data['likes']
                                                    .length
                                                    .toString()),
                                              ]),
                                            ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Text(snapShot.data.documents[index]
                                          .data['content']),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    snapShot.data.documents[index]
                                            .data['is_image']
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.network(
                                              snapShot.data.documents[index]
                                                  .data['image_url']
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
                                        : snapShot.data.documents[index]
                                                    .data['image_url'] ==
                                                null
                                            ? Text('')
                                            : snapShot.data.documents[index]
                                                    .data['is_yt_vid']
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              3,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: showYoutubeVideo(
                                                          snapShot
                                                              .data
                                                              .documents[index]
                                                              .data['image_url']
                                                              .toString()),
                                                    ),
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              3,
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      child: NetworkPlayer(
                                                          snapShot
                                                              .data
                                                              .documents[index]
                                                              .data['image_url']
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
                                          Text(snapShot.data.documents[index]
                                                      .data['comments'].length >
                                                  1
                                              ? '${snapShot.data.documents[index].data['comments'].length} Comments'
                                              : ' ${snapShot.data.documents[index].data['comments'].length} Comment'),
                                          Spacer(),
                                          GestureDetector(
                                            onTap: () {
                                              Post _post = new Post();
                                              _post.imageUrl = snapShot
                                                  .data
                                                  .documents[index]
                                                  .data['image_url'];
                                              _post.content = snapShot
                                                  .data
                                                  .documents[index]
                                                  .data['content'];
                                              _post.likes = snapShot
                                                  .data
                                                  .documents[index]
                                                  .data['likes'];
                                              _post.userIdWhoPosted = snapShot
                                                  .data
                                                  .documents[index]
                                                  .data['user_id_who_posted'];
                                              _post.comments = snapShot
                                                  .data
                                                  .documents[index]
                                                  .data['comments'];
                                              _post.postId = snapShot
                                                  .data
                                                  .documents[index]
                                                  .data['post_id'];
                                              _post.time_posted = snapShot
                                                  .data
                                                  .documents[index]
                                                  .data['time_uploaded'];

                                              _post.profile_url = snapShot
                                                  .data
                                                  .documents[index]
                                                  .data['profile_url'];
                                              _post.isImage = snapShot
                                                  .data
                                                  .documents[index]
                                                  .data['is_image'];
                                              _post.is_yt_vid = snapShot
                                                  .data
                                                  .documents[index]
                                                  .data['is_yt_vid'];

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
                      : Container();
                });
          }
        },
      ),
    );
  }

  getpostsmadeInSkill(String skillId) async {
    var fireStore = Firestore.instance;
    QuerySnapshot qn = await fireStore
        .collection('posts')
        .orderBy('time_uploaded', descending: true)
        .getDocuments();
    return qn.documents;
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

  Widget showYoutubeVideo(String uTubeVdLink) {
    if (uTubeVdLink == null) {
    } else {
      if (uTubeVdLink.isNotEmpty) {
        try {
          _controller = YoutubePlayerController(
              initialVideoId: YoutubePlayer.convertUrlToId(uTubeVdLink));
          return Container(
            child: Column(
              children: <Widget>[
                YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                ),
              ],
            ),
          );
        } catch (e) {
          print(e.toString());
        }
      }
    }
    return Container();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
