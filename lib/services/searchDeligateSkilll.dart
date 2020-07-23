import 'package:flutter/material.dart';
import 'package:virtualclass/modals/skillModal.dart';

import '../constants.dart';

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
