import 'package:flutter/material.dart';
import 'package:virtualclass/modals/postsmodal.dart';
import 'package:virtualclass/screens/timeService.dart';

class CommentsScreen extends StatefulWidget {
  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  Post _post;
  @override
  Widget build(BuildContext context) {
    _post = ModalRoute.of(context).settings.arguments;

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
                          Spacer(),
                          Expanded(
                            child: TextField(
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
                                //ToDO Post Comment
                              }),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: _post.comments.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(_post.imageUrl),
                                radius: 10,
                              ),
                              title: Text('Comment 12'),
                            );
                          }),
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
}
