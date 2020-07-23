import 'package:flutter/material.dart';
import 'package:virtualclass/modals/classModal.dart';

import '../constants.dart';

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
