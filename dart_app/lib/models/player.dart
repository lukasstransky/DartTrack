class Player {
  String _name;

  get getName => this._name;
  set setName(String name) => this._name = name;

  Player({required String name}) : _name = name;
}
