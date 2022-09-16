import 'package:dart_app/models/default_settings_x01.dart';
import 'package:dart_app/models/open_games_firestore.dart';
import 'package:dart_app/services/firestore/firestore_service_default_settings.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class GameModesOverView extends StatefulWidget {
  const GameModesOverView({Key? key}) : super(key: key);

  @override
  _GameModesOverViewScreenState createState() =>
      _GameModesOverViewScreenState();
}

class _GameModesOverViewScreenState extends State<GameModesOverView> {
  @override
  void initState() {
    _getOpenGames();
    _getDefaultSettingsX01();
    super.initState();
  }

  void _getOpenGames() async {
    await context.read<FirestoreServiceGames>().getOpenGames(context);
  }

  void _getDefaultSettingsX01() async {
    Provider.of<DefaultSettingsX01>(context, listen: false).resetValues();
    await context
        .read<FirestoreServiceDefaultSettings>()
        .getDefaultSettingsX01(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(false, 'Game Modes'),
      body: Consumer<OpenGamesFirestore>(
        builder: (_, openGamesFirestore, __) => openGamesFirestore.init
            ? Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('Open Games: '),
                        Container(
                          height: 3.h,
                          child: ElevatedButton(
                            child: Text(
                                openGamesFirestore.openGames.length.toString()),
                            onPressed: () =>
                                Navigator.of(context).pushNamed('/openGames'),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Container(
                              width: 50.w,
                              child: ElevatedButton(
                                child: Text(
                                  'X01',
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                                onPressed: () => Navigator.of(context)
                                    .pushNamed('/settingsX01'),
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Container(
                              width: 50.w,
                              child: ElevatedButton(
                                child: Text(
                                  'Cricket',
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                                onPressed: () => null,
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Container(
                              width: 50.w,
                              child: ElevatedButton(
                                child: Text(
                                  'Singles Training',
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                                onPressed: () => null,
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 50.w,
                            child: ElevatedButton(
                              child: Text(
                                'Doubles Training',
                                style: TextStyle(fontSize: 14.sp),
                              ),
                              onPressed: () => null,
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
