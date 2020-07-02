import 'package:flutter/material.dart';

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
