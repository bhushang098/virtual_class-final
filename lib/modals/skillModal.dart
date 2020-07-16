class Skill {
  String _skillName,
      _about,
      _whoCnaPost,
      _whoCanSendMessage,
      _whoCanSeePost,
      _userId,
      _Skill_Id,
      _hosted_by;

  double _price;
  Map<String, dynamic> _members;

  String get skillName => _skillName;

  set skillName(String value) {
    _skillName = value;
  }

  get about => _about;

  Map<String, dynamic> get members => _members;

  set members(Map<String, dynamic> value) {
    _members = value;
  }

  double get price => _price;

  set price(double value) {
    _price = value;
  }

  get hosted_by => _hosted_by;

  set hosted_by(value) {
    _hosted_by = value;
  }

  get skillId => _Skill_Id;

  set skillId(value) {
    _Skill_Id = value;
  }

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

  set about(value) {
    _about = value;
  }
}
