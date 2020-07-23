class Skill {
  String _skillName, _about, _userId, _Skill_Id, _hosted_by, _skill_image;

  bool _public_comment, _public_post, _public_see_post;

  double _price;
  Map<String, dynamic> _members;

  String get skillName => _skillName;

  set skillName(String value) {
    _skillName = value;
  }

  get skill_image => _skill_image;

  set skill_image(value) {
    _skill_image = value;
  }

  get Skill_Id => _Skill_Id;

  set Skill_Id(value) {
    _Skill_Id = value;
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

  set about(value) {
    _about = value;
  }

  get public_see_post => _public_see_post;

  set public_see_post(value) {
    _public_see_post = value;
  }

  get public_post => _public_post;

  set public_post(value) {
    _public_post = value;
  }

  bool get public_comment => _public_comment;

  set public_comment(bool value) {
    _public_comment = value;
  }
}
