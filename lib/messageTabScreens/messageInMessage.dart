import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageInMessage extends StatefulWidget {
  @override
  _MessageInMessageState createState() => _MessageInMessageState();
}

class _MessageInMessageState extends State<MessageInMessage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Image.network(
                  'https://neilpatel.com/wp-content/uploads/2017/04/chat.jpg'),
            ),
          ),
          Text('Select User To Start Conversation')
        ],
      ),
    );
  }
}
