import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtualclass/modals/userModal.dart';

import '../constants.dart';

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
