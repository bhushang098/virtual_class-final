import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtualclass/constants.dart';

class NewHomePage extends StatefulWidget {
  @override
  _NewHomePageState createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> {
  TextEditingController captnController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryDark,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network("https://virtualskill.in/mobile-icon.jpeg"),
          ),
          Spacer(),
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.message,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/MessageTabHolder');
            },
          ),
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.account_circle,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Card(
                elevation: 2,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: TextFormField(
                        controller: captnController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: 'Share What You Think',
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.add_photo_alternate,
                            color: primaryDark,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.play_arrow,
                            color: primaryDark,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.ondemand_video,
                            color: primaryDark,
                          ),
                        ),
                        Spacer(),
                        RaisedButton(
                          child: Text(
                            'Post!',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: PrimaryColor,
                          onPressed: () {},
                        ),
                        SizedBox(
                          width: 20,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  AssetImage("images/welcome_image.jpeg"),
                            ),
                            title: Text('Bhushan Gurnule'),
                            subtitle: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.access_time,
                                  size: 15,
                                ),
                                Text('15 hours ago')
                              ],
                            ),
                            trailing: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                                Text('12'),
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text('Caption Goes here'),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset("images/welcome_image.jpeg"),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 20,
                            ),
                            Icon(
                              Icons.insert_comment,
                              color: Colors.black45,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Write Comment',
                              style: TextStyle(color: Colors.black54),
                            )
                          ],
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundImage:
                                      AssetImage("images/welcome_image.jpeg"),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          //color: Colors.red[500],
                                          ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        Text('comment'),
                                        Spacer(),
                                        Icon(Icons.send)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
