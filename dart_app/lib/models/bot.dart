import 'package:dart_app/models/player.dart';

class Bot extends Player {
  int preDefinedAverage;
  int level;

  get getPreDefinedAverage => this.preDefinedAverage;
  set setPreDefinedAverage(int preDefinedAverage) =>
      this.preDefinedAverage = preDefinedAverage;

  int get getLevel => this.level;
  set setLevel(int level) => this.level = level;

  Bot({required name, required this.preDefinedAverage, required this.level})
      : super(name: name);
}
