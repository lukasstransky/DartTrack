import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/utils/ad_management/banner_ad.dart';
import 'package:flutter/material.dart';

class BannerAdManager_P with ChangeNotifier {
  // stats screen
  MyBannerAd? overallStatsScreenBannerAd;
  MyBannerAd? x01GameStatsScreenBannerAd;
  MyBannerAd? cricketGameStatsScreenBannerAd;
  MyBannerAd? singleDoubleTrainingGameStatsScreenBannerAd;
  MyBannerAd? scoreTrainingGameStatsScreenBannerAd;
  // finish screen
  MyBannerAd? x01FinishScreenBannerAd;
  MyBannerAd? cricketFinishScreenBannerAd;
  MyBannerAd? singleDoubleTrainingFinishScreenBannerAd;
  MyBannerAd? scoreTrainingFinishScreenBannerAd;
  // game screen
  MyBannerAd? x01GameScreenBannerAd;
  MyBannerAd? cricketGameScreenBannerAd;
  MyBannerAd? singleDoubleTrainingGameScreenBannerAd;
  MyBannerAd? scoreTrainingGameScreenBannerAd;

  MyBannerAd? get getOverallStatsScreenBannerAd =>
      this.overallStatsScreenBannerAd;
  set setOverallStatsScreenBannerAd(MyBannerAd? overallStatsScreenBannerAd) =>
      this.overallStatsScreenBannerAd = overallStatsScreenBannerAd;

  MyBannerAd? get getX01GameStatsScreenBannerAd =>
      this.x01GameStatsScreenBannerAd;
  set setX01GameStatsScreenBannerAd(MyBannerAd? x01GameStatsScreenBannerAd) =>
      this.x01GameStatsScreenBannerAd = x01GameStatsScreenBannerAd;

  MyBannerAd? get getCricketGameStatsScreenBannerAd =>
      this.cricketGameStatsScreenBannerAd;
  set setCricketGameStatsScreenBannerAd(
          MyBannerAd? cricketGameStatsScreenBannerAd) =>
      this.cricketGameStatsScreenBannerAd = cricketGameStatsScreenBannerAd;

  MyBannerAd? get getSingleDoubleTrainingGameStatsScreenBannerAd =>
      this.singleDoubleTrainingGameStatsScreenBannerAd;
  set setSingleDoubleTrainingGameStatsScreenBannerAd(
          MyBannerAd? singleDoubleTrainingGameStatsScreenBannerAd) =>
      this.singleDoubleTrainingGameStatsScreenBannerAd =
          singleDoubleTrainingGameStatsScreenBannerAd;

  MyBannerAd? get getScoreTrainingGameStatsScreenBannerAd =>
      this.scoreTrainingGameStatsScreenBannerAd;
  set setScoreTrainingGameStatsScreenBannerAd(
          MyBannerAd? scoreTrainingGameStatsScreenBannerAd) =>
      this.scoreTrainingGameStatsScreenBannerAd =
          scoreTrainingGameStatsScreenBannerAd;

  MyBannerAd? get getX01FinishScreenBannerAd => this.x01FinishScreenBannerAd;
  set setX01FinishScreenBannerAd(MyBannerAd? x01FinishScreenBannerAd) =>
      this.x01FinishScreenBannerAd = x01FinishScreenBannerAd;

  MyBannerAd? get getCricketFinishScreenBannerAd =>
      this.cricketFinishScreenBannerAd;
  set setCricketFinishScreenBannerAd(MyBannerAd? cricketFinishScreenBannerAd) =>
      this.cricketFinishScreenBannerAd = cricketFinishScreenBannerAd;

  MyBannerAd? get getSingleDoubleTrainingFinishScreenBannerAd =>
      this.singleDoubleTrainingFinishScreenBannerAd;
  set setSingleDoubleTrainingFinishScreenBannerAd(
          MyBannerAd? singleDoubleTrainingFinishScreenBannerAd) =>
      this.singleDoubleTrainingFinishScreenBannerAd =
          singleDoubleTrainingFinishScreenBannerAd;

  MyBannerAd? get getScoreTrainingFinishScreenBannerAd =>
      this.scoreTrainingFinishScreenBannerAd;
  set setScoreTrainingFinishScreenBannerAd(
          MyBannerAd? scoreTrainingFinishScreenBannerAd) =>
      this.scoreTrainingFinishScreenBannerAd =
          scoreTrainingFinishScreenBannerAd;

  MyBannerAd? get getX01GameScreenBannerAd => this.x01GameScreenBannerAd;
  set setX01GameScreenBannerAd(MyBannerAd? x01GameScreenBannerAd) =>
      this.x01GameScreenBannerAd = x01GameScreenBannerAd;

  MyBannerAd? get getCricketGameScreenBannerAd =>
      this.cricketGameScreenBannerAd;
  set setCricketGameScreenBannerAd(MyBannerAd? cricketGameScreenBannerAd) =>
      this.cricketGameScreenBannerAd = cricketGameScreenBannerAd;

  MyBannerAd? get getSingleDoubleTrainingGameScreenBannerAd =>
      this.singleDoubleTrainingGameScreenBannerAd;
  set setSingleDoubleTrainingGameScreenBannerAd(
          MyBannerAd? singleDoubleTrainingGameScreenBannerAd) =>
      this.singleDoubleTrainingGameScreenBannerAd =
          singleDoubleTrainingGameScreenBannerAd;

  MyBannerAd? get getScoreTrainingGameScreenBannerAd =>
      this.scoreTrainingGameScreenBannerAd;
  set setScoreTrainingGameScreenBannerAd(
          MyBannerAd? scoreTrainingGameScreenBannerAd) =>
      this.scoreTrainingGameScreenBannerAd = scoreTrainingGameScreenBannerAd;

  MyBannerAd? assignBannerAd(BannerAdEnum adEnum) {
    switch (adEnum) {
      case BannerAdEnum.OverallStatsScreen:
        return getOverallStatsScreenBannerAd;
      case BannerAdEnum.X01StatsScreen:
        return getX01GameStatsScreenBannerAd;
      case BannerAdEnum.CricketStatsScreen:
        return getCricketGameStatsScreenBannerAd;
      case BannerAdEnum.SingleDoubleTrainingStatsScreen:
        return getSingleDoubleTrainingGameStatsScreenBannerAd;
      case BannerAdEnum.ScoreTrainingStatsScreen:
        return getScoreTrainingGameStatsScreenBannerAd;
      case BannerAdEnum.X01FinishScreen:
        return getX01FinishScreenBannerAd;
      case BannerAdEnum.CricketFinishScreen:
        return getCricketFinishScreenBannerAd;
      case BannerAdEnum.SingleDoubleTrainingFinishScreen:
        return getSingleDoubleTrainingFinishScreenBannerAd;
      case BannerAdEnum.ScoreTrainingFinishScreen:
        return getScoreTrainingFinishScreenBannerAd;
      case BannerAdEnum.X01GameScreen:
        return getX01GameScreenBannerAd;
      case BannerAdEnum.CricketGameScreen:
        return getCricketGameScreenBannerAd;
      case BannerAdEnum.SingleDoubleTrainingGameScreen:
        return getSingleDoubleTrainingGameScreenBannerAd;
      case BannerAdEnum.ScoreTrainingGameScreen:
        return getScoreTrainingGameScreenBannerAd;
    }
  }

  disposeCorrectBannerAd(Game_P game) {
    if (game is GameX01_P) {
      if (getX01GameScreenBannerAd != null) {
        getX01GameScreenBannerAd!.dispose();
      }
    } else if (game is GameCricket_P) {
      if (getCricketGameScreenBannerAd != null) {
        getCricketGameScreenBannerAd!.dispose();
      }
    } else if (game is GameSingleDoubleTraining_P) {
      if (getSingleDoubleTrainingGameScreenBannerAd != null) {
        getSingleDoubleTrainingGameScreenBannerAd!.dispose();
      }
    } else if (game is GameScoreTraining_P) {
      if (getScoreTrainingGameScreenBannerAd != null) {
        getScoreTrainingGameScreenBannerAd!.dispose();
      }
    }
  }
}
