import 'dart:io';

import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_score_training_p.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/user_p.dart';
import 'package:dart_app/screens/game_modes/score_training/game/local_widgets/players_list/players_list_sc_t.dart';
import 'package:dart_app/screens/game_modes/score_training/game/local_widgets/point_btns_round/point_btns_round_sc_t.dart';
import 'package:dart_app/screens/game_modes/shared/game/point_btns_three_darts/point_btns_three_darts.dart';
import 'package:dart_app/screens/game_modes/shared/select_input_method/select_input_method.dart';
import 'package:dart_app/utils/ad_management/banner_ad_widget.dart';
import 'package:dart_app/utils/ad_management/banner_ads_manager_p.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar_game.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class GameScoreTraining extends StatefulWidget {
  static const routeName = '/gameScoreTraining';

  const GameScoreTraining({Key? key}) : super(key: key);

  @override
  State<GameScoreTraining> createState() => _GameScoreTrainingState();
}

class _GameScoreTrainingState extends State<GameScoreTraining> {
  final String _bannerAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-8582367743573228/6822278850'
      : 'ca-app-pub-8582367743573228/6083912251';

  @override
  Widget build(BuildContext context) {
    context.read<GameScoreTraining_P>().setSafeAreaPadding =
        MediaQuery.of(context).padding;

    if (context.read<User_P>().getAdsEnabled && Utils.isLandscape(context)) {
      final BannerAdManager_P bannerAdManager =
          context.read<BannerAdManager_P>();
      if (bannerAdManager.getScoreTrainingGameScreenBannerAd != null) {
        bannerAdManager.getScoreTrainingGameScreenBannerAd!.dispose();
      }
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBarGame(mode: GameMode.ScoreTraining),
        body: SafeArea(
          child: Selector<GameScoreTraining_P, bool>(
            selector: (_, game) => game.getShowLoadingSpinner,
            builder: (_, showLoadingSpinner, __) {
              if (showLoadingSpinner) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              } else {
                return Utils.isLandscape(context)
                    ? _buildLandscapeLayout()
                    : _buildPortraitLayout();
              }
            },
          ),
        ),
      ),
    );
  }

  Column _buildPortraitLayout() {
    return Column(
      children: [
        if (context.read<User_P>().getAdsEnabled)
          Container(
            padding: EdgeInsets.only(bottom: 0.5.h),
            child: BannerAdWidget(
              bannerAdUnitId: _bannerAdUnitId,
              bannerAdEnum: BannerAdEnum.ScoreTrainingGameScreen,
              disposeInstant: true,
            ),
          ),
        PlayersListScoreTraining(),
        Expanded(
          child: Selector<GameSettingsScoreTraining_P, InputMethod>(
            selector: (_, gameSettingsScoreTraining_P) =>
                gameSettingsScoreTraining_P.getInputMethod,
            builder: (_, inputMethod, __) => Column(
              children: [
                SelectInputMethod(mode: GameMode.ScoreTraining),
                inputMethod == InputMethod.Round
                    ? PointBtnsRoundScoreTraining()
                    : PointBtnsThreeDarts(mode: GameMode.ScoreTraining),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Row _buildLandscapeLayout() {
    return Row(
      children: [
        Expanded(child: PlayersListScoreTraining()),
        Expanded(
          child: Selector<GameSettingsScoreTraining_P, InputMethod>(
            selector: (_, gameSettingsScoreTraining_P) =>
                gameSettingsScoreTraining_P.getInputMethod,
            builder: (_, inputMethod, __) => Column(
              children: [
                SelectInputMethod(mode: GameMode.ScoreTraining),
                inputMethod == InputMethod.Round
                    ? PointBtnsRoundScoreTraining()
                    : PointBtnsThreeDarts(mode: GameMode.ScoreTraining),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
