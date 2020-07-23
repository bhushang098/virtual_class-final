import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:virtualclass/constants.dart';
import 'package:virtualclass/modals/postsmodal.dart';
import 'package:virtualclass/modals/userModal.dart';
import 'package:virtualclass/screens/networkVidScreen.dart';
import 'package:virtualclass/screens/timeService.dart';
import 'package:virtualclass/services/fStoreCollection.dart';
import 'package:virtualclass/services/serchdeligate.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Myusers _myusers;
  YoutubePlayerController _controller;

  var uuid = Uuid();

  @override
  void initState() {
    super.initState();
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

  FirebaseUser user;
  List<Post> _postList = [];

  @override
  Widget build(BuildContext context) {
    _postList.clear();
    super.build(context);
    user = Provider.of<FirebaseUser>(context);
    return Scaffold(
      backgroundColor: primaryLight,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/MakePostScreen', arguments: 'ALL');
        },
        tooltip: 'Make New Post',
        backgroundColor: PrimaryColor,
        child: Icon(Icons.image),
      ),
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Home Page"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                getpostListForSearch();
                showSearch(
                    context: context,
                    delegate: DeligatePostAll(_postList, context));
                print("u tapped search");
              }),
          IconButton(
              icon: Icon(Icons.person),
              onPressed: () async {
                var result = await Connectivity().checkConnectivity();
                if (result == ConnectivityResult.none) {
                  _showDialog(
                      'No internet', "You're not connected to a network");
                } else if (result == ConnectivityResult.mobile ||
                    result == ConnectivityResult.wifi) {
                  _myusers = await new DbUserCollection(user.uid)
                      .getUserDeta(user.uid);
                  navToprofilePage(_myusers);
                }
                print("u tapped profile");
              }),
        ],
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
                          'ALL'
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

  void navToprofilePage(Myusers user) {
    Navigator.pushNamed(context, '/ProfilePage', arguments: user);
  }

  getposts() async {
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

  void navToCommentscreen(Post post) {
    Navigator.pushNamed(context, '/CommentScreen', arguments: post);
  }

  Future<String> getUsername(String uid) async {
    DocumentSnapshot snapshot =
        await Firestore.instance.collection('users').document(uid).get();
    return snapshot.data['name'];
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

  void getpostListForSearch() {
    _postList = getpostData();
  }

  List<Post> getpostData() {
    Firestore.instance
        .collection('posts')
        .where('assigned_with', isEqualTo: 'ALL')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => _postList.add(buildPostClass(f)));
    });
    return _postList;
  }

  Post buildPostClass(DocumentSnapshot f) {
    Post _post = new Post();
    _post.userIdWhoPosted = f.data['user_id_who_posted'];
    _post.content = f.data['content'];
    _post.imageUrl = f.data['image_url'];
    _post.profile_url = f.data['profile_url'];
    _post.postId = f.data['post_id'];
    _post.time_posted = f.data['time_uploaded'];
    _post.comments = f.data['comments'];
    _post.isImage = f.data['is_image'];
    _post.is_yt_vid = f.data['is_yt_vid'];
    _post.likes = f.data['likes'];

    return _post;
  }
}
