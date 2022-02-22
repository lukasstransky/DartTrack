import '../models/player_model.dart';

class Bot extends Player {
  double preDefinedAverage;

  get getPreDefinedAverage => this.preDefinedAverage;
  set setPreDefinedAverage(double preDefinedAverage) =>
      this.preDefinedAverage = preDefinedAverage;

  Bot({name, required this.preDefinedAverage}) : super(name: name);
}
