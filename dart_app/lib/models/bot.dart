import 'package:dart_app/models/player.dart';

class Bot extends Player {
  double? preDefinedAverage;

  get getPreDefinedAverage => this.preDefinedAverage;
  set setPreDefinedAverage(double preDefinedAverage) =>
      this.preDefinedAverage = preDefinedAverage;

  Bot({required name, required this.preDefinedAverage}) : super(name: name);

  Bot.clone({required Bot player}) : super(name: player.getName) {
    preDefinedAverage = player.getPreDefinedAverage;
  }
}
