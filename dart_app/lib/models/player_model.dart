class Player {
  String _name;
  String? _team; //null if single player

  get getName => this._name;
  set setName(String name) => this._name = name;

  get getTeam => this._team;
  set setTeam(String? team) => this._team = team;

  Player({required String name}) : _name = name;
}
