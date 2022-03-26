class Player {
  String _name;
  String? _playerGameStatisticsId;

  get getPlayerGameStatisticsId => this._playerGameStatisticsId;
  set setPlayerGameStatisticsId(String playerGameStatisticsId) =>
      this._playerGameStatisticsId = playerGameStatisticsId;

  get getName => this._name;
  set setName(String name) => this._name = name;

  Player({required String name}) : _name = name;
}
