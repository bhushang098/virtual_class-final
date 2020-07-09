class Team {
  String _teamName,
      _about,
      _location,
      _whoCnaPost,
      _whoCanSendMessage,
      _whoCanSeePost,
      _userId,
      _teamId;
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

  get whoCanSeePost => _whoCanSeePost;

  set whoCanSeePost(value) {
    _whoCanSeePost = value;
  }

  get whoCanSendMessage => _whoCanSendMessage;

  set whoCanSendMessage(value) {
    _whoCanSendMessage = value;
  }

  get whoCnaPost => _whoCnaPost;

  set whoCnaPost(value) {
    _whoCnaPost = value;
  }

  get location => _location;

  set location(value) {
    _location = value;
  }

  set about(value) {
    _about = value;
  }
}
