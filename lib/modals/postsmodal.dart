class Post {
  String _userIdWhoPosted, _content, _imageUrl, _timesAgo;
  int _likes;

  String get userIdWhoPosted => _userIdWhoPosted;

  set userIdWhoPosted(String value) {
    _userIdWhoPosted = value;
  }

  get content => _content;

  int get likes => _likes;

  set likes(int value) {
    _likes = value;
  }

  get timesAgo => _timesAgo;

  set timesAgo(value) {
    _timesAgo = value;
  }

  get imageUrl => _imageUrl;

  set imageUrl(value) {
    _imageUrl = value;
  }

  set content(value) {
    _content = value;
  }
}
