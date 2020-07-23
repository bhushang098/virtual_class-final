class Team {
  String _teamName, _about, _location, _userId, _teamId;

  bool _public_post, _public_see_post, _public_comment;

  String _host, _team_image;

  Map<String, dynamic> _members;

  Map<String, dynamic> get members => _members;

  set members(Map<String, dynamic> value) {
    _members = value;
  }

  get teamId => _teamId;

  set teamId(value) {
    _teamId = value;
  }

  String get teamName => _teamName;

  set teamName(String value) {
    _teamName = value;
  }

  get about => _about;

  get userId => _userId;

  set userId(value) {
    _userId = value;
  }

  get location => _location;

  set location(value) {
    _location = value;
  }

  set about(value) {
    _about = value;
  }

  get public_comment => _public_comment;

  set public_comment(value) {
    _public_comment = value;
  }

  get public_see_post => _public_see_post;

  set public_see_post(value) {
    _public_see_post = value;
  }

  bool get public_post => _public_post;

  set public_post(bool value) {
    _public_post = value;
  }

  get team_image => _team_image;

  set team_image(value) {
    _team_image = value;
  }

  String get host => _host;

  set host(String value) {
    _host = value;
  }
}
