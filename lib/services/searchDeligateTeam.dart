import 'package:flutter/material.dart';
import 'package:virtualclass/modals/teamModal.dart';

import '../constants.dart';

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
