class UserTeamArgs {
  var _joinedTeam = [];
  var _hostedTeams = [];

  get joinedTeam => _joinedTeam;

  set joinedTeam(value) {
    _joinedTeam = value;
  }

  get hostedTeams => _hostedTeams;

  set hostedTeams(value) {
    _hostedTeams = value;
  }
}
