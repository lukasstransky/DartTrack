import 'dart:io';

import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/screens/game_modes/single_double_training/game/local_widgets/field_to_hit_sd_t.dart';
import 'package:dart_app/screens/game_modes/single_double_training/game/local_widgets/game_btns/double/game_btns_double_sd_t.dart';
import 'package:dart_app/screens/game_modes/single_double_training/game/local_widgets/game_btns/single/game_btns_single_sd_t.dart';
import 'package:dart_app/screens/game_modes/single_double_training/game/local_widgets/players_list/players_list_sd_t.dart';
import 'package:dart_app/screens/game_modes/single_double_training/game/local_widgets/revert_btn_thrown_darts_sd_t.dart';
import 'package:dart_app/utils/ad_management/banner_ad_widget.dart';
import 'package:dart_app/utils/ad_management/banner_ads_manager_p.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar_game.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class GameSingleDoubleTraining extends StatefulWidget {
  static const routeName = '/gameSingleDoubleTraining';

  const GameSingleDoubleTraining({Key? key}) : super(key: key);

  @override
  State<GameSingleDoubleTraining> createState() =>
      _GameSingleDoubleTrainingState();
}

class _GameSingleDoubleTrainingState extends State<GameSingleDoubleTraining> {
  GameMode _mode = GameMode.SingleTraining;
  //TODO replace
  // ios -> ca-app-pub-8582367743573228/8710075598
  // android -> ca-app-pub-8582367743573228/4387687203
  final String _bannerAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    if (arguments.isNotEmpty) {
      _mode = arguments['mode'] == GameMode.SingleTraining.name
          ? GameMode.SingleTraining
          : GameMode.DoubleTraining;
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<GameSingleDoubleTraining_P>().setSafeAreaPadding =
        MediaQuery.of(context).padding;

    if (Utils.isLandscape(context)) {
      context
          .read<BannerAdManager_P>()
          .getSingleDoubleTrainingGameScreenBannerAd!
          .dispose();
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBarGame(mode: _mode),
        body: SafeArea(
          child: Selector<GameSingleDoubleTraining_P, bool>(
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
        Container(
          padding: EdgeInsets.only(bottom: 0.5.h),
          child: BannerAdWidget(
            bannerAdUnitId: _bannerAdUnitId,
            bannerAdEnum: BannerAdEnum.SingleDoubleTrainingGameScreen,
            disposeInstant: true,
          ),
        ),
        PlayersListSingleDoubleTraining(),
        FieldToHitSingleDoubleTraining(),
        RevertBtnAndThrownDarts(),
        context.read<GameSingleDoubleTraining_P>().getMode ==
                GameMode.DoubleTraining
            ? GameBtnsDoubleTraining()
            : GameBtnsSingleTraining(),
      ],
    );
  }

  Row _buildLandscapeLayout() {
    return Row(
      children: [
        Expanded(child: PlayersListSingleDoubleTraining()),
        Expanded(
          child: Column(
            children: [
              FieldToHitSingleDoubleTraining(),
              RevertBtnAndThrownDarts(),
              context.read<GameSingleDoubleTraining_P>().getMode ==
                      GameMode.DoubleTraining
                  ? GameBtnsDoubleTraining()
                  : GameBtnsSingleTraining(),
            ],
          ),
        ),
      ],
    );
  }
}
