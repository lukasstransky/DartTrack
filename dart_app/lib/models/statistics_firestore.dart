//only needed for firestore
//overall stats saved, instead of query that has to iterate over each player stats
//gets updated after each game
import 'package:dart_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatisticsFirestore with ChangeNotifier {
  num _countOfGames = 0;
  num _countOfGamesWon = 0;

  num _avg = 0;
  num _bestAvg = -1;
  num _worstAvg = -1;
  num _firstNineAvg = 0;
  num _bestFirstNineAvg = -1;
  num _worstFirstNineAvg = -1;

  num _checkoutQuoteAvg = 0;
  num _bestCheckoutQuote = -1;
  num _worstCheckoutQuote = -1;

  num _dartsPerLegAvg = 0;
  num _bestLeg = -1;
  num _worstLeg = -1;

  num _countOf180 = 0;
  num _countOfAllDarts = 0;

  FilterValue _currentFilterValue = FilterValue.Overall;
  String _customDateFilterRange = "";

  get countOfGamesWon => this._countOfGamesWon;

  set countOfGamesWon(value) => this._countOfGamesWon = value;

  get countOfGames => this._countOfGames;

  set countOfGames(value) => this._countOfGames = value;

  get avg => this._avg;

  set avg(value) => this._avg = value;

  get bestAvg => this._bestAvg;

  set bestAvg(value) => this._bestAvg = value;

  get worstAvg => this._worstAvg;

  set worstAvg(value) => this._worstAvg = value;

  get firstNineAvg => this._firstNineAvg;

  set firstNineAvg(value) => this._firstNineAvg = value;

  get bestFirstNineAvg => this._bestFirstNineAvg;

  set bestFirstNineAvg(value) => this._bestFirstNineAvg = value;

  get worstFirstNineAvg => this._worstFirstNineAvg;

  set worstFirstNineAvg(value) => this._worstFirstNineAvg = value;

  get checkoutQuoteAvg => this._checkoutQuoteAvg;

  set checkoutQuoteAvg(value) => this._checkoutQuoteAvg = value;

  get bestCheckoutQuote => this._bestCheckoutQuote;

  set bestCheckoutQuote(value) => this._bestCheckoutQuote = value;

  get worstCheckoutQuote => this._worstCheckoutQuote;

  set worstCheckoutQuote(value) => this._worstCheckoutQuote = value;

  get dartsPerLegAvg => this._dartsPerLegAvg;

  set dartsPerLegAvg(value) => this._dartsPerLegAvg = value;

  get bestLeg => this._bestLeg;

  set bestLeg(value) => this._bestLeg = value;

  get worstLeg => this._worstLeg;

  set worstLeg(value) => this._worstLeg = value;

  get countOf180 => this._countOf180;

  set countOf180(value) => this._countOf180 = value;

  get countOfAllDarts => this._countOfAllDarts;

  set countOfAllDarts(value) => this._countOfAllDarts = value;

  get currentFilterValue => this._currentFilterValue;

  set currentFilterValue(value) => this._currentFilterValue = value;

  get customDateFilterRange => this._customDateFilterRange;

  set customDateFilterRange(value) => this._customDateFilterRange = value;

  changeCurrentFilterValue(FilterValue newValue) {
    currentFilterValue = newValue;
    notifyListeners();
  }

  DateTime getDateTimeFromCurrentFilterValue() {
    DateTime now = new DateTime.now();
    DateTime result = new DateTime.now();

    switch (currentFilterValue) {
      case FilterValue.Month:
        {
          result = new DateTime(now.year, now.month - 1, now.day);
          break;
        }
      case FilterValue.Year:
        {
          result = new DateTime(now.year - 1, now.month, now.day);
          break;
        }
    }

    return result;
  }

  DateTime getCustomStartDate() {
    return DateFormat("dd-MM-yyyy")
        .parse(customDateFilterRange.split(";").first);
  }

  DateTime getCustomEndDate() {
    return DateFormat("dd-MM-yyyy")
        .parse(customDateFilterRange.split(";").last);
  }

  resetValues() {
    _countOfGames = 0;
    _countOfGamesWon = 0;

    _avg = 0;
    _bestAvg = -1;
    _worstAvg = -1;
    _firstNineAvg = 0;
    _bestFirstNineAvg = -1;
    _worstFirstNineAvg = -1;

    _checkoutQuoteAvg = 0;
    _bestCheckoutQuote = -1;
    _worstCheckoutQuote = -1;

    _dartsPerLegAvg = 0;
    _bestLeg = -1;
    _worstLeg = -1;

    _countOf180 = 0;
    _countOfAllDarts = 0;
  }
}
