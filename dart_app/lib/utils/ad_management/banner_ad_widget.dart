import 'package:dart_app/constants.dart';
import 'package:dart_app/utils/ad_management/banner_ad.dart';
import 'package:dart_app/utils/ad_management/banner_ads_manager_p.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class BannerAdWidget extends StatefulWidget {
  final String bannerAdUnitId;
  final BannerAdEnum bannerAdEnum;
  final bool disposeInstant;

  BannerAdWidget({
    Key? key,
    required this.bannerAdUnitId,
    required this.bannerAdEnum,
    this.disposeInstant = false,
  }) : super(key: key);

  @override
  _BannerAdWidgetState createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  late MyBannerAd? myBannerAd;
  BannerAdManager_P? bannerAdManager;

  @override
  void initState() {
    bannerAdManager = context.read<BannerAdManager_P>();
    myBannerAd = bannerAdManager!.assignBannerAd(widget.bannerAdEnum);

    // only null the first time
    if (myBannerAd == null) {
      final MyBannerAd tempAd = MyBannerAd(adUnitId: widget.bannerAdUnitId);

      switch (widget.bannerAdEnum) {
        case BannerAdEnum.OverallStatsScreen:
          bannerAdManager!.setOverallStatsScreenBannerAd = tempAd;
          bannerAdManager!.getOverallStatsScreenBannerAd!
              .load(() => setState(() {}));
          break;
        case BannerAdEnum.X01StatsScreen:
          bannerAdManager!.setX01GameStatsScreenBannerAd = tempAd;
          bannerAdManager!.getX01GameStatsScreenBannerAd!
              .load(() => setState(() {}));
          break;
        case BannerAdEnum.CricketStatsScreen:
          bannerAdManager!.setCricketGameStatsScreenBannerAd = tempAd;
          bannerAdManager!.getCricketGameStatsScreenBannerAd!
              .load(() => setState(() {}));
          break;
        case BannerAdEnum.SingleDoubleTrainingStatsScreen:
          bannerAdManager!.setSingleDoubleTrainingGameStatsScreenBannerAd =
              tempAd;
          bannerAdManager!.getSingleDoubleTrainingGameStatsScreenBannerAd!
              .load(() => setState(() {}));
          break;
        case BannerAdEnum.ScoreTrainingStatsScreen:
          bannerAdManager!.setScoreTrainingGameStatsScreenBannerAd = tempAd;
          bannerAdManager!.getScoreTrainingGameStatsScreenBannerAd!
              .load(() => setState(() {}));
          break;
        case BannerAdEnum.X01FinishScreen:
          bannerAdManager!.setX01FinishScreenBannerAd = tempAd;
          bannerAdManager!.getX01FinishScreenBannerAd!
              .load(() => setState(() {}));
          break;
        case BannerAdEnum.CricketFinishScreen:
          bannerAdManager!.setCricketFinishScreenBannerAd = tempAd;
          bannerAdManager!.getCricketFinishScreenBannerAd!
              .load(() => setState(() {}));
          break;
        case BannerAdEnum.SingleDoubleTrainingFinishScreen:
          bannerAdManager!.setSingleDoubleTrainingFinishScreenBannerAd = tempAd;
          bannerAdManager!.getSingleDoubleTrainingFinishScreenBannerAd!
              .load(() => setState(() {}));
          break;
        case BannerAdEnum.ScoreTrainingFinishScreen:
          bannerAdManager!.setScoreTrainingFinishScreenBannerAd = tempAd;
          bannerAdManager!.getScoreTrainingFinishScreenBannerAd!
              .load(() => setState(() {}));
          break;
        case BannerAdEnum.X01GameScreen:
          bannerAdManager!.setX01GameScreenBannerAd = tempAd;
          bannerAdManager!.getX01GameScreenBannerAd!
              .load(() => setState(() {}));
          break;
        case BannerAdEnum.CricketGameScreen:
          bannerAdManager!.setCricketGameScreenBannerAd = tempAd;
          bannerAdManager!.getCricketGameScreenBannerAd!
              .load(() => setState(() {}));
          break;
        case BannerAdEnum.SingleDoubleTrainingGameScreen:
          bannerAdManager!.setSingleDoubleTrainingGameScreenBannerAd = tempAd;
          bannerAdManager!.getSingleDoubleTrainingGameScreenBannerAd!
              .load(() => setState(() {}));
          break;
        case BannerAdEnum.ScoreTrainingGameScreen:
          bannerAdManager!.setScoreTrainingGameScreenBannerAd = tempAd;
          bannerAdManager!.getScoreTrainingGameScreenBannerAd!
              .load(() => setState(() {}));
          break;
      }
    } else if (!myBannerAd!.isAdLoaded) {
      myBannerAd!.load(() => setState(() {}));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    myBannerAd = bannerAdManager!.assignBannerAd(widget.bannerAdEnum);

    return myBannerAd == null
        ? SizedBox(height: 50)
        : myBannerAd!.adContainer();
  }

  @override
  void dispose() {
    myBannerAd!.disposeIfStale(widget.disposeInstant);
    super.dispose();
  }
}
