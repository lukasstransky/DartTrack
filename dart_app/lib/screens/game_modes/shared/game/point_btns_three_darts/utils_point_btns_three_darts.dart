import 'package:dart_app/constants.dart';

class UtilsPointBtnsThreeDarts {
  // calculate points based on single, double, tripple
  static String calculatePoints(String pointValue, PointType pointType) {
    int points;

    if (pointValue == 'Bull') {
      points = 50;
    } else if (pointValue == '25') {
      points = 25;
    } else {
      points = int.parse(pointValue);

      if (pointType == PointType.Double) {
        points = points * 2;
      } else if (pointType == PointType.Tripple) {
        points = points * 3;
      }
    }

    return points.toString();
  }

  static updateCurrentThreeDarts(
      List<String> currentThreeDarts, String pointValue) {
    if (currentThreeDarts[0] == 'Dart 1') {
      currentThreeDarts[0] = pointValue;
    } else if (currentThreeDarts[1] == 'Dart 2') {
      currentThreeDarts[1] = pointValue;
    } else if (currentThreeDarts[2] == 'Dart 3') {
      currentThreeDarts[2] = pointValue;
    }
  }

  static resetCurrentThreeDarts(List<String> currentThreeDarts) {
    currentThreeDarts[0] = 'Dart 1';
    currentThreeDarts[1] = 'Dart 2';
    currentThreeDarts[2] = 'Dart 3';
  }
}
