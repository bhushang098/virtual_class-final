import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:virtualclass/modals/postsmodal.dart';
import 'package:virtualclass/screens/networkVidScreen.dart';
import 'package:virtualclass/screens/timeService.dart';
import 'package:virtualclass/services/fStoreCollection.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../constants.dart';

class TeamPosts extends StatefulWidget {
  TeamPosts({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _TeamPostsState createState() => _TeamPostsState();
}

class _TeamPostsState extends State<TeamPosts>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool see_post_public = false;
  bool post_public = false;
  bool mess_public = false;
  String _user_who_made_skill;

  Map<String, dynamic> members;

  YoutubePlayerController _controller;
  var uuid = Uuid();
  Set<String> _liked_Posts;
  int countState = 0;

  @override
  void initState() {
    _liked_Posts = new Set();
    members = new Map();
    getsettings(widget.title);
    super.initState();
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
    setPostLiked(user.uid);
    Future.delayed(const Duration(seconds: 1), () {
      if (countState < 1) {
        setState(() {
          countState++;
        });
      }
    });
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'Make New Post',
        onPressed: () {
          if (post_public) {
            Navigator.pushNamed(context, '/MakePostScreen',
                arguments: widget.title);
          } else {
            if (members.containsKey(user.uid) ||
                _user_who_made_skill == user.uid) {
              Navigator.pushNamed(context, '/MakePostScreen',
                  arguments: widget.title);
            } else {
              showDialog(
                context: context,
                child: Dialog(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text('Only Members Can post In This Team'),
                  ),
                ),
              );
            }
          }
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
                  if (snapShot.data.documents[index].data['assigned_with'] ==
                      widget.title) {
                    if (see_post_public) {
                      return Column(
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
                                    trailing: snapShot
                                            .data.documents[index].data['likes']
                                            .contains(user.uid)
                                        ? GestureDetector(
                                            onTap: () {
                                              List<dynamic> userWhoLiked =
                                                  snapShot.data.documents[index]
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
                                                  snapShot.data.documents[index]
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
                                    child: Text(snapShot
                                        .data.documents[index].data['content']),
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
                                                      const EdgeInsets.all(8.0),
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
                                                      const EdgeInsets.all(8.0),
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
                                            if (mess_public) {
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
                                            } else {
                                              if (members
                                                      .containsKey(user.uid) ||
                                                  _user_who_made_skill ==
                                                      user.uid) {
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
                                              } else {
                                                showDialog(
                                                    context: context,
                                                    child: Dialog(
                                                        child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      child: Text(
                                                          'Only Members Can Comment In This Team'),
                                                    )));
                                              }
                                            }
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
                      );
                    } else {
                      if (members.containsValue(user.uid) ||
                          _user_who_made_skill == user.uid) {
                        return Column(
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
                        );
                      } else {
                        return Container();
                      }
                    }
                  } else {
                    return Container();
                  }
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

  void getsettings(String teamId) async {
    DocumentSnapshot snp =
        await Firestore.instance.collection('teams').document(teamId).get();

    members = snp.data['members'];

    _user_who_made_skill = snp.data['user_id'];

    post_public = snp.data['public_post'];

    see_post_public = snp.data['public_see_post'];

    mess_public = snp.data['public_comment'];
  }
}
