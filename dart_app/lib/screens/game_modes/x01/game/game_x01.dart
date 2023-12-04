import 'dart:io';

import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/user_p.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/multiple_player_team_stats/multiple_player_team_stats_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/round/point_btns_round_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/two_player_team_stats_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/three_darts/point_btns_three_darts_x01.dart';
import 'package:dart_app/utils/ad_management/banner_ad_widget.dart';
import 'package:dart_app/utils/ad_management/banner_ads_manager_p.dart';

import 'package:dart_app/utils/app_bars/x01/custom_app_bar_x01_game.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class GameX01 extends StatefulWidget {
  static const routeName = '/gameX01';

  @override
  GameX01State createState() => GameX01State();
}

class GameX01State extends State<GameX01> {
  //TODO replace
  // ios -> ca-app-pub-8582367743573228/6467055638
  // android -> ca-app-pub-8582367743573228/8518503902
  final String _bannerAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  @override
  Widget build(BuildContext context) {
    final bool isTeamMode = context.read<GameSettingsX01_P>().getSingleOrTeam ==
        SingleOrTeamEnum.Team;

    context.read<GameX01_P>().setSafeAreaPadding =
        MediaQuery.of(context).padding;

    if (context.read<User_P>().getAdsEnabled && Utils.isLandscape(context)) {
      final BannerAdManager_P bannerAdManager =
          context.read<BannerAdManager_P>();
      if (bannerAdManager.getX01GameScreenBannerAd != null) {
        bannerAdManager.getX01GameScreenBannerAd!.dispose();
      }
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBarX01Game(),
        body: SafeArea(
          child: Selector<GameX01_P, bool>(
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
                    ? _buildLandscapeLayout(isTeamMode)
                    : _buildPortraitLayout(isTeamMode);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _getTwoOrMultiplePlayerTeamStatsView(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01_P =
        context.read<GameSettingsX01_P>();
    final bool isSingleMode =
        gameSettingsX01_P.getSingleOrTeam == SingleOrTeamEnum.Single;
    final bool isSingleGameWithTwoPlayers =
        isSingleMode && gameSettingsX01_P.getPlayers.length == 2;
    final bool isTeamGameWithTwoTeams =
        !isSingleMode && gameSettingsX01_P.getTeams.length == 2;

    if (isSingleGameWithTwoPlayers || isTeamGameWithTwoTeams) {
      return TwoPlayerOrTeamStatsX01(
          isSingleMode: isSingleGameWithTwoPlayers ? true : false);
    }

    return MultiplePlayerTeamStatsX01(
      isSingleMode: isSingleMode,
    );
  }

  Column _buildPortraitLayout(bool isTeamMode) {
    return Column(
      children: [
        if (context.read<User_P>().getAdsEnabled)
          Container(
            padding: EdgeInsets.only(bottom: 0.5.h),
            child: BannerAdWidget(
              bannerAdUnitId: _bannerAdUnitId,
              bannerAdEnum: BannerAdEnum.X01GameScreen,
              disposeInstant: true,
            ),
          ),
        _getTwoOrMultiplePlayerTeamStatsView(context),
        Selector<GameSettingsX01_P, InputMethod>(
          selector: (_, gameSettingsX01) => gameSettingsX01.getInputMethod,
          builder: (_, inputMethod, __) => inputMethod == InputMethod.Round
              ? PointBtnsRoundX01()
              : PointsBtnsThreeDartsX01(),
        ),
      ],
    );
  }

  Row _buildLandscapeLayout(bool isTeamMode) {
    return Row(
      children: [
        _getTwoOrMultiplePlayerTeamStatsView(context),
        Selector<GameSettingsX01_P, InputMethod>(
          selector: (_, gameSettingsX01) => gameSettingsX01.getInputMethod,
          builder: (_, inputMethod, __) => Builder(builder: (context) {
            return Expanded(
              child: Column(
                children: [
                  inputMethod == InputMethod.Round
                      ? PointBtnsRoundX01()
                      : PointsBtnsThreeDartsX01()
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
