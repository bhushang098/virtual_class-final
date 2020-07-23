class Myusers {
  String _name, _email, _phone, _profile_url, _location, _userId;
  bool _gender, _isTeacher;
  int _noOfPost;
  List<dynamic> _followers;
  List<dynamic> _following;
  List<dynamic> _posts;
  List<dynamic> _images;
  List<dynamic> _videos;
  List<dynamic> _links;
  List<dynamic> _post_liked;
  List<dynamic> _skills;

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  List<dynamic> get skills => _skills;

  set skills(List<dynamic> value) {
    _skills = value;
  }

  get userId => _userId;

  set userId(value) {
    _userId = value;
  }

  get profile_url => _profile_url;

  set profile_url(value) {
    _profile_url = value;
  }

  get isTeacher => _isTeacher;

  set isTeacher(value) {
    _isTeacher = value;
  }

  get location => _location;

  set location(value) {
    _location = value;
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

  List<dynamic> get followers => _followers;

  set followers(List<dynamic> value) {
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

  List<dynamic> get following => _following;

  set following(List<dynamic> value) {
    _following = value;
  }
}
