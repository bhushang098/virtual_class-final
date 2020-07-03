class Myusers {
  String _name, _email, _phone, _gender;
  int _noOfPost, _followers, _following;
  List<String> _posts;
  List<String> _images;
  List<String> _videos;
  List<String> _links;

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  get email => _email;

  List<String> get links => _links;

  set links(List<String> value) {
    _links = value;
  }

  List<String> get videos => _videos;

  set videos(List<String> value) {
    _videos = value;
  }

  List<String> get images => _images;

  set images(List<String> value) {
    _images = value;
  }

  List<String> get posts => _posts;

  set posts(List<String> value) {
    _posts = value;
  }

  get following => _following;

  set following(value) {
    _following = value;
  }

  get followers => _followers;

  set followers(value) {
    _followers = value;
  }

  int get noOfPost => _noOfPost;

  set noOfPost(int value) {
    _noOfPost = value;
  }

  get gender => _gender;

  set gender(value) {
    _gender = value;
  }

  get phone => _phone;

  set phone(value) {
    _phone = value;
  }

  set email(value) {
    _email = value;
  }
}
