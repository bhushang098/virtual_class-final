class Myusers {
  String _name, _email, _phone, _profile_url;
  bool _gender;
  int _noOfPost;
  int _followers;
  int _following;
  List<dynamic> _posts;
  List<dynamic> _images;
  List<dynamic> _videos;
  List<dynamic> _links;
  List<dynamic> _post_liked;

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  get profile_url => _profile_url;

  set profile_url(value) {
    _profile_url = value;
  }

  get email => _email;

  List<dynamic> get post_liked => _post_liked;

  set post_liked(List<dynamic> value) {
    _post_liked = value;
  }

  List<dynamic> get links => _links;

  set links(List<dynamic> value) {
    _links = value;
  }

  List<dynamic> get videos => _videos;

  set videos(List<dynamic> value) {
    _videos = value;
  }

  List<dynamic> get images => _images;

  set images(List<dynamic> value) {
    _images = value;
  }

  List<dynamic> get posts => _posts;

  set posts(List<dynamic> value) {
    _posts = value;
  }

  int get following => _following;

  set following(int value) {
    _following = value;
  }

  int get followers => _followers;

  set followers(int value) {
    _followers = value;
  }

  int get noOfPost => _noOfPost;

  set noOfPost(int value) {
    _noOfPost = value;
  }

  bool get gender => _gender;

  set gender(bool value) {
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
