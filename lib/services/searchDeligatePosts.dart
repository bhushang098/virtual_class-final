import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualclass/modals/postsmodal.dart';
import 'package:virtualclass/screens/networkVidScreen.dart';
import 'package:virtualclass/screens/timeService.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'fStoreCollection.dart';

class DeligatePostAll extends SearchDelegate<Post> {
  List<Post> list = [];
  BuildContext context;

  DeligatePostAll(this.list, this.context);

  YoutubePlayerController _controller;

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    List<Post> anslist = [];

    for (int i = 0; i < list.length; i++) {
      if (list[i].userIdWhoPosted.toLowerCase().contains(query.toLowerCase()) ||
          list[i].content.toLowerCase().contains(query.toLowerCase())) {
        anslist.add(list[i]);
      }
    }

    final user = Provider.of<FirebaseUser>(context);

    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: anslist.length,
        itemBuilder: (BuildContext context, int index) {
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
                          backgroundImage:
                              NetworkImage(anslist[index].profile_url),
                        ),
                        title: Text(anslist[index]
                            .userIdWhoPosted
                            .split('??.??')
                            .first),
                        subtitle:
                            Text(convertTimeStamp(anslist[index].time_posted)),
                        trailing: anslist[index].likes.contains(user.uid)
                            ? GestureDetector(
                                onTap: () {
                                  List<dynamic> userWhoLiked =
                                      anslist[index].likes;

                                  userWhoLiked.remove(user.uid);

                                  new DbUserCollection(user.uid)
                                      .updateLikeInPost(
                                          anslist[index].postId, userWhoLiked)
                                      .then((onValue) {});
                                },
                                child: Column(
                                  children: <Widget>[
                                    Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                    ),
                                    Text(
                                        anslist[index].likes.length.toString()),
                                  ],
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  List<dynamic> userWhoLiked =
                                      anslist[index].likes;
                                  userWhoLiked.add(user.uid);

                                  new DbUserCollection(user.uid)
                                      .updateLikeInPost(
                                          anslist[index].postId, userWhoLiked)
                                      .then((onValue) {});
                                },
                                child: Column(children: <Widget>[
                                  Icon(Icons.favorite_border),
                                  Text(anslist[index].likes.length.toString()),
                                ]),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(anslist[index].content),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      anslist[index].isImage
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                anslist[index].imageUrl.toString(),
                                height: MediaQuery.of(context).size.height / 3,
                                scale: 1.0,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                alignment: Alignment.center,
                              ),
                            )
                          : anslist[index].imageUrl == null
                              ? Text('')
                              : anslist[index].is_yt_vid
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                3,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: showYoutubeVideo(
                                            anslist[index].imageUrl.toString()),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                3,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: NetworkPlayer(
                                            anslist[index].imageUrl.toString()),
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
                            Text(anslist[index].comments.length > 1
                                ? '${anslist[index].comments.length} Comments'
                                : ' ${anslist[index].comments.length} Comment'),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                navToCommentscreen(anslist[index]);
                              },
                              child: Text(
                                'See Comments ',
                                style: TextStyle(color: Colors.blue),
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
        });
  }

  String convertTimeStamp(var timeStamp) {
    DateTime t = timeStamp.toDate();
    return timeAgo(t);
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
}
