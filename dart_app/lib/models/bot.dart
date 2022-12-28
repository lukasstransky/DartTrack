import 'dart:math';

import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/x01/game_x01.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/x01/player_or_team_game_statistics_x01.dart';
import 'package:tuple/tuple.dart';

class Bot extends Player {
  int preDefinedAverage;
  int level;
  List<String> generatedScores = List.filled(AMOUNT_OF_GENERATED_SCORES, '');
  int indexForGeneratedScores = 0;
  bool shouldGenerateRandomScores = true;
  bool starterDoubleAlreadySet = false;
  double onePercentOfBaseValue = 0.0;
  double scoreRangeLowerLimit = 0.0;
  double scoreRangeUpperLimit = 0.0;

  final _random = new Random();

  get getPreDefinedAverage => this.preDefinedAverage;
  set setPreDefinedAverage(int preDefinedAverage) =>
      this.preDefinedAverage = preDefinedAverage;

  int get getLevel => this.level;
  set setLevel(int level) => this.level = level;

  int get getIndexForGeneratedScores => this.indexForGeneratedScores;
  set setIndexForGeneratedScores(int indexForGeneratedScores) =>
      this.indexForGeneratedScores = indexForGeneratedScores;

  bool get getStarterDoubleAlreadySet => this.starterDoubleAlreadySet;
  set setStarterDoubleAlreadySet(bool starterDoubleAlreadySet) =>
      this.starterDoubleAlreadySet = starterDoubleAlreadySet;

  Bot({required name, required this.preDefinedAverage, required this.level})
      : super(name: name);

  // String -> scored value
  // int -> amount of finish darts
  // int -> amount of checkout darts
  Tuple3<String, int, int> getNextScoredValue(GameX01 gameX01) {
    Tuple3<String, int, int> resultTuple = new Tuple3('', 3, 0);

    // 0 -> when starting the game
    if (indexForGeneratedScores == 0) {
      shouldGenerateRandomScores = true;
      starterDoubleAlreadySet = false;
      generatedScores = List.filled(AMOUNT_OF_GENERATED_SCORES, '');

      onePercentOfBaseValue = preDefinedAverage / 100;
      scoreRangeLowerLimit =
          onePercentOfBaseValue * BASE_VALUE_PERCENTAGE_LOWER_LIMIT;
      scoreRangeUpperLimit = preDefinedAverage +
          (BASE_VALUE_PERCENTAGE_UPPER_LIMIT * onePercentOfBaseValue);
      if (scoreRangeUpperLimit > 180) {
        scoreRangeUpperLimit = 180;
      }
    }

    final PlayerOrTeamGameStatisticsX01 stats =
        gameX01.getCurrentPlayerGameStats();
    final int currentPoints = stats.getCurrentPoints;

    // finish possible
    if (currentPoints <= scoreRangeUpperLimit &&
        !BOGEY_NUMBERS.contains(currentPoints) &&
        currentPoints <= 170) {
      final double avg = double.parse(stats.getAverage());

      // don't finish -> leave double field
      if (avg > preDefinedAverage) {
        // leave starter double field (e.g. 40, 32...)
        if (!starterDoubleAlreadySet &&
            !STARTER_DOUBLES_FOR_FINISH.contains(currentPoints)) {
          return resultTuple
              .withItem1(_getStarterDoubleForFinish(currentPoints));
        }

        if (_shouldSubmitZero()) {
          // set checkout count to 3
          resultTuple = resultTuple.withItem3(3);
          return resultTuple.withItem1('0');
        }

        switch (currentPoints) {
          case 40:
            resultTuple = resultTuple.withItem1('20');
            break;
          case 36:
            resultTuple = resultTuple.withItem1('18');
            break;
          case 32:
            resultTuple = resultTuple.withItem1('16');
            break;
          case 24:
            resultTuple = resultTuple.withItem1('12');
            break;
          case 20:
            resultTuple = resultTuple.withItem1('10');
            break;
          case 18:
            resultTuple = resultTuple.withItem1('9');
            break;
          case 16:
            resultTuple = resultTuple.withItem1('8');
            break;
          case 12:
            resultTuple = resultTuple.withItem1('6');
            break;
          case 10:
            resultTuple = resultTuple.withItem1('5');
            break;
          case 8:
            resultTuple = resultTuple.withItem1('4');
            break;
          default:
            resultTuple = resultTuple.withItem1('0');
            break;
        }
        // set checkout count to 3
        resultTuple = resultTuple.withItem3(3);

        return resultTuple;
      } else {
        // finish
        late int amountOfFinishDarts;
        late int checkoutDarts;

        if (gameX01.isDoubleField(currentPoints.toString())) {
          // generate random value between 1-3 for checkout count + amount of finish darts
          final int randomValue = _getRandomValue(1, 4);
          checkoutDarts = randomValue;
          amountOfFinishDarts = randomValue;
        } else if (gameX01.finishedWithThreeDarts(currentPoints.toString())) {
          checkoutDarts = 1;
          amountOfFinishDarts = 3;
        } else {
          // 2 dart finish
          checkoutDarts = 1;
          amountOfFinishDarts = 2;
        }
        resultTuple = resultTuple.withItem1(currentPoints.toString());
        resultTuple = resultTuple.withItem2(amountOfFinishDarts);
        resultTuple = resultTuple.withItem3(checkoutDarts);

        return resultTuple;
      }
    }

    if (indexForGeneratedScores == AMOUNT_OF_GENERATED_SCORES ||
        indexForGeneratedScores == 0) {
      indexForGeneratedScores = 0;

      // generate random scores
      if (this.shouldGenerateRandomScores) {
        for (int i = 0; i < AMOUNT_OF_GENERATED_SCORES; i++) {
          final int nextScore = getNextScore(
              scoreRangeLowerLimit.round(), scoreRangeUpperLimit.round());

          generatedScores[i] = nextScore.toString();
        }
        shouldGenerateRandomScores = !shouldGenerateRandomScores;
      } else if (!shouldGenerateRandomScores) {
        // generate scores within specific range
        for (int i = 0; i < AMOUNT_OF_GENERATED_SCORES; i++) {
          final double avg = double.parse(stats.getAverage());

          late int nextScore;
          if (avg <= preDefinedAverage) {
            // generate scores > preDefinedAverage
            nextScore =
                getNextScore(preDefinedAverage, scoreRangeUpperLimit.round());
          } else {
            // generate scores < preDefinedAverage
            nextScore =
                getNextScore(scoreRangeLowerLimit.round(), preDefinedAverage);
          }
          generatedScores[i] = nextScore.toString();
        }
        shouldGenerateRandomScores = !shouldGenerateRandomScores;
      }
    }

    return resultTuple.withItem1(generatedScores[indexForGeneratedScores++]);
  }

  int getNextScore(int lowerLimit, int upperLimit) {
    // check that no score is generated which is not possible
    int nextScore;
    do {
      nextScore = _getRandomValue(lowerLimit, upperLimit);
    } while (NO_SCORES_POSSIBLE.contains(nextScore));

    return nextScore;
  }

  String _getStarterDoubleForFinish(int currentPoints) {
    List<int> possibleStarterDoubles = [];
    for (int starterDouble in STARTER_DOUBLES_FOR_FINISH) {
      if (starterDouble < currentPoints) {
        possibleStarterDoubles.add(starterDouble);
      } else {
        break;
      }
    }

    // in case currentPoints < 16
    if (possibleStarterDoubles.isEmpty) {
      possibleStarterDoubles = [4, 8, 10, 12];
    }

    // pick random starter double
    final int upperLimit = possibleStarterDoubles.length;
    final int index = _getRandomValue(0, upperLimit);
    final int starterDoubleFinish = possibleStarterDoubles[index];

    starterDoubleAlreadySet = true;
    // calc diff to starter double finish
    return ((starterDoubleFinish - currentPoints) * -1).toString();
  }

  bool _shouldSubmitZero() {
    final int upperLimit =
        (1 / PROBABILITY_TO_SUBMIT_ZERO_FOR_FINISH_CHANCE).round();
    final int randomValue = _getRandomValue(0, upperLimit);

    // randomly picked 1
    if (randomValue == 1) {
      return true;
    }
    return false;
  }

  int _getRandomValue(int min, int max) => min + _random.nextInt(max - min);
}
