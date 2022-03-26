import 'package:dart_app/models/player.dart';

class PlayerGameStatistics {
  final Player _player;
  String? _gameId; //to reference the corresponding game -> calc stats
  final String _mode; //e.g. X01, Cricket.. -> calc stats

  get getPlayer => this._player;

  get getGameId => this._gameId;

  get getMode => this._mode;

  PlayerGameStatistics({required Player player, required String mode})
      : _player = player,
        _mode = mode;
}
