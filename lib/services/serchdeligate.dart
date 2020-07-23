import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualclass/modals/classModal.dart';
import 'package:virtualclass/modals/postsmodal.dart';
import 'package:virtualclass/modals/skillModal.dart';
import 'package:virtualclass/modals/teamModal.dart';
import 'package:virtualclass/modals/userModal.dart';
import 'package:virtualclass/screens/networkVidScreen.dart';
import 'package:virtualclass/screens/timeService.dart';
import 'package:virtualclass/services/fStoreCollection.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../constants.dart';

class DeligateLectures extends SearchDelegate<VideoClass> {
  List<VideoClass> list = [];

  DeligateLectures(this.list);

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

  void navtoVidScreen(VideoClass vid, BuildContext context) {
    Navigator.pushNamed(context, '/vidScreen', arguments: vid);
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
    List<VideoClass> anslist = [];

    for (int i = 0; i < list.length; i++) {
      if (list[i].title.toLowerCase().contains(query.toLowerCase()) ||
          list[i].author.toLowerCase().contains(query.toLowerCase())) {
        anslist.add(list[i]);
      }
    }

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
                  child: InkWell(
                    splashColor: Colors.teal[100],
                    onTap: () {
                      navtoVidScreen(anslist[index], context);
                      print("Tapped>>>>" + anslist[index].author.toString());
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.video_library,
                        size: 50,
                        color: Colors.green,
                      ),
                      title: Text(anslist[index].title.toString()),
                      subtitle: Text(anslist[index].author.toString()),
                    ),
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
}

class VideoClass {
  String _title, _url, _author, _course, _price;

  VideoClass(this._title, this._url, this._author, this._course, this._price);

  get course => _course;

  set course(value) {
    _course = value;
  }

  get price => _price;

  set price(value) {
    _price = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  get url => _url;

  set url(value) {
    _url = value;
  }

  get author => _author;

  set author(value) {
    _author = value;
  }
}

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
      if (list[i]
              .userIdWhoPosted
              .split('??.??')
              .first
              .toLowerCase()
              .contains(query.toLowerCase()) ||
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

class DeligateSkill extends SearchDelegate<Skill> {
  List<Skill> list = [];
  BuildContext context;

  DeligateSkill(this.list, this.context);

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
    List<Skill> anslist = [];

    for (int i = 0; i < list.length; i++) {
      if (list[i].skillName.toLowerCase().contains(query.toLowerCase()) ||
          list[i].hosted_by.toLowerCase().contains(query.toLowerCase())) {
        anslist.add(list[i]);
      }
    }

    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: anslist.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              navToDetailsPage(anslist[index].skillId);
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          anslist[index].skillName,
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Image.network(
                        anslist[index].skill_image,
                        height: 150,
                        fit: BoxFit.fill,
                        width: MediaQuery.of(context).size.width,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '     INR ${anslist[index].price}      ',
                        style: TextStyle(
                            backgroundColor: primaryDark,
                            fontSize: 17,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text('Members ${anslist[index].members.length} '),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Hosted By :  ${anslist[index].hosted_by} ',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void navToDetailsPage(String skillId) {
    Navigator.pushNamed(context, '/SkillDetailsPage', arguments: skillId);
  }
}

class DeligateTeam extends SearchDelegate<Team> {
  List<Team> list = [];
  BuildContext context;

  DeligateTeam(this.list, this.context);

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
    List<Team> anslist = [];

    for (int i = 0; i < list.length; i++) {
      if (list[i].teamName.toLowerCase().contains(query.toLowerCase()) ||
          list[i].host.toLowerCase().contains(query.toLowerCase())) {
        anslist.add(list[i]);
      }
    }

    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: anslist.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/TeamDetailsMain',
                  arguments: anslist[index].teamId);
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    anslist[index].teamName,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Image.network(
                    anslist[index].team_image,
                    height: MediaQuery.of(context).size.height / 5,
                  ),
                  Text(
                    '${anslist[index].members.length} Members',
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: PrimaryColor,
                        fontStyle: FontStyle.italic),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: Colors.black,
                        size: 15,
                      ),
                      SizedBox(width: 10),
                      Text(anslist[index].location),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Hosted By  : ",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: anslist[index].host,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class DeligateClass extends SearchDelegate<Classes> {
  List<Classes> list = [];
  BuildContext context;

  DeligateClass(this.list, this.context);

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
    List<Classes> anslist = [];

    for (int i = 0; i < list.length; i++) {
      if (list[i].className.toLowerCase().contains(query.toLowerCase()) ||
          list[i].host.toLowerCase().contains(query.toLowerCase())) {
        anslist.add(list[i]);
      }
    }

    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: anslist.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              navToDetailsPage(anslist[index].classId);
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          anslist[index].className,
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Image.network(
                        anslist[index].class_image,
                        height: MediaQuery.of(context).size.height / 5,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(' Location : ${anslist[index].location} '),
                      SizedBox(
                        height: 8,
                      ),
                      anslist[index].fees == null
                          ? Text(
                              '    Free Class    ',
                              style: TextStyle(
                                  backgroundColor: PrimaryColor, fontSize: 17),
                            )
                          : Text(
                              '   INR ${anslist[index].fees}   ',
                              style: TextStyle(
                                  backgroundColor: PrimaryColor, fontSize: 17),
                            ),
                      SizedBox(
                        height: 5,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.date_range,
                          color: PrimaryColor,
                        ),
                        title: Text(anslist[index]
                                .startDate
                                .toDate()
                                .day
                                .toString() +
                            '/' +
                            anslist[index].startDate.toDate().month.toString() +
                            '/' +
                            anslist[index].startDate.toDate().year.toString()),
                      ),
                      anslist[index].daily
                          ? ListTile(
                              leading: Icon(
                                Icons.access_time,
                                color: PrimaryColor,
                              ),
                              title: Text('Daily ' +
                                  anslist[index]
                                      .startTime
                                      .toDate()
                                      .hour
                                      .toString() +
                                  ' : ' +
                                  anslist[index]
                                      .startTime
                                      .toDate()
                                      .minute
                                      .toString()),
                            )
                          : ListTile(
                              leading: Icon(
                                Icons.access_time,
                                color: PrimaryColor,
                              ),
                              title: Text('At ' +
                                  anslist[index]
                                      .startTime
                                      .toDate()
                                      .hour
                                      .toString() +
                                  ' : ' +
                                  anslist[index]
                                      .startTime
                                      .toDate()
                                      .minute
                                      .toString()),
                            ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void navToDetailsPage(String classId) {
    Navigator.pushNamed(context, '/ClassDetailsPage', arguments: classId);
  }
}

class DeligateUsers extends SearchDelegate<Myusers> {
  List<Myusers> list = [];
  BuildContext context;

  DeligateUsers(this.list, this.context);

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
    List<Myusers> anslist = [];

    for (int i = 0; i < list.length; i++) {
      if (list[i].name.toLowerCase().contains(query.toLowerCase())) {
        anslist.add(list[i]);
      }
    }
    final user = Provider.of<FirebaseUser>(context);

    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: anslist.length,
        itemBuilder: (BuildContext context, int index) {
          return anslist[index].isTeacher
              ? Container()
              : user.uid == anslist[index].userId
                  ? Container()
                  : InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/OtherUserProfile',
                            arguments: anslist[index].userId);
                      },
                      splashColor: PrimaryColor,
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 12.0, left: 10),
                              child: Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 35,
                                    backgroundImage: NetworkImage(
                                        anslist[index].profile_url),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    anslist[index].name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: PrimaryColor),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                ],
                              ),
                            ),
                            Text('Location ${anslist[index].location}'),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Skills'),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: SingleChildScrollView(
                                child: skillBuilder(anslist[index].skills),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
        });
  }

  Widget skillBuilder(List<dynamic> skills) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: skills.length,
        itemBuilder: (BuildContext context, int index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  skills[index],
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          );
        });
  }
}
