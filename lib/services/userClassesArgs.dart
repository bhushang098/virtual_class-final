class UserClassesArgs {
  var _joinedClasses = [];
  var _hostedClasses = [];

  get joinedClasses => _joinedClasses;

  set joinedClasses(value) {
    _joinedClasses = value;
  }

  get hostedClasses => _hostedClasses;

  set hostedClasses(value) {
    _hostedClasses = value;
  }
}
