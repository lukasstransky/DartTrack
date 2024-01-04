import 'dart:io';

import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/models/user_p.dart';
import 'package:dart_app/screens/game_modes/single_double_training/game_statistics/local_widgets/field_hits_sd_t.dart';
import 'package:dart_app/screens/game_modes/single_double_training/game_statistics/local_widgets/main_stats_sd_t.dart';
import 'package:dart_app/screens/game_modes/shared/game_stats/player_or_team_names.dart';
import 'package:dart_app/utils/ad_management/banner_ad_widget.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar_with_heart.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class GameStatsSingleDoubleTraining extends StatefulWidget {
  static const routeName = '/statisticsSingleDoubleTraining';

  const GameStatsSingleDoubleTraining({Key? key}) : super(key: key);

  @override
  State<GameStatsSingleDoubleTraining> createState() =>
      _GameStatsSingleDoubleTrainingState();
}

class _GameStatsSingleDoubleTrainingState
    extends State<GameStatsSingleDoubleTraining> {
  GameSingleDoubleTraining_P? _game;
  bool _showSimpleAppBar = false;
  // testing ads
  // final String _bannerAdUnitId = Platform.isAndroid
  //     ? 'ca-app-pub-8582367743573228/1888682225'
  //     : 'ca-app-pub-8582367743573228/6490272217';
  // real ads
  final String _bannerAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-8582367743573228/1888682225'
      : 'ca-app-pub-8582367743573228/6490272217';

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    if (arguments.isNotEmpty) {
      if (arguments.containsKey('game')) {
        _game = arguments['game'];
      }
      if (arguments.containsKey('showSimpleAppBar'))
        _showSimpleAppBar = arguments['showSimpleAppBar'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final double fontSizeTargetNumberRounds = Utils.getResponsiveValue(
      context: context,
      mobileValue: 10,
      tabletValue: 8,
    );

    return Scaffold(
      appBar: _game!.getIsGameFinished && !_showSimpleAppBar
          ? CustomAppBarWithHeart(
              title: 'Statistics',
              mode: _game!.getMode,
              isFavouriteGame: _game!.getIsFavouriteGame,
              gameId: _game!.getGameId,
            )
          : CustomAppBar(title: 'Statistics'),
      body: SafeArea(
        child: Column(
          children: [
            if (context.read<User_P>().getAdsEnabled)
              Container(
                padding: EdgeInsets.only(bottom: 0.5.h),
                child: BannerAdWidget(
                  bannerAdUnitId: _bannerAdUnitId,
                  bannerAdEnum: BannerAdEnum.SingleDoubleTrainingStatsScreen,
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    if (_game!.getGameSettings.getIsTargetNumberEnabled) ...[
                      Container(
                        padding: EdgeInsets.only(top: 0.5.h),
                        child: RichText(
                          text: TextSpan(
                            text:
                                'Target number: ${_game!.getMode == GameMode.DoubleTraining ? 'D' : ''}${_game!.getGameSettings.getTargetNumber} ',
                            style: TextStyle(
                              fontSize: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .fontSize! *
                                  0.9,
                              color: Colors.white,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    '(${_game!.getGameSettings.getAmountOfRounds} rounds)',
                                style: TextStyle(
                                  fontSize: fontSizeTargetNumberRounds.sp,
                                  color: Colors.white70,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ] else
                      Text(
                        _getHeader(),
                        style: TextStyle(
                          fontSize: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .fontSize! *
                              0.9,
                          color: Colors.white,
                        ),
                      ),
                    Container(
                      alignment:
                          Utils.isLandscape(context) ? Alignment.center : null,
                      padding: EdgeInsets.only(
                        top: 0.5.h,
                        bottom: 2.h,
                      ),
                      child: Text(
                        _game!.getFormattedDateTime(),
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodyMedium!.fontSize,
                          fontWeight: FontWeight.bold,
                          color: Utils.getTextColorDarken(context),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PlayerOrTeamNames(game: _game!),
                          MainStatsSingleDoubleTraining(game: _game!),
                          FieldHitsSingleDoubleTraining(game: _game!),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getHeader() {
    if (!_game!.getGameSettings.getIsTargetNumberEnabled) {
      //asc, desc or random
      switch (_game!.getGameSettings.getMode) {
        case ModesSingleDoubleTraining.Ascending:
          return 'Ascending';
        case ModesSingleDoubleTraining.Descending:
          return 'Descending';
        case ModesSingleDoubleTraining.Random:
          return 'Random';
      }
    }

    return "";
  }
}
