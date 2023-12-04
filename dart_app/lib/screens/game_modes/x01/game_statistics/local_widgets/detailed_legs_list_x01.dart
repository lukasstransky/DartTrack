import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/detailed_leg_x01.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:sizer/sizer.dart';

class DetailedLegsListX01 extends StatefulWidget {
  DetailedLegsListX01({Key? key, required this.gameX01}) : super(key: key);

  final GameX01_P gameX01;

  @override
  State<DetailedLegsListX01> createState() => _DetailedLegsListX01State();
}

class _DetailedLegsListX01State extends State<DetailedLegsListX01> {
  List<Item> _items = [];

  @override
  initState() {
    super.initState();
    _items = _getItems(context);
  }

  List<Item> _getItems(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = widget.gameX01.getGameSettings;

    List<Item> items = [];
    for (String setLegKey in widget.gameX01
        .getAllLegSetStringsExceptCurrentOne(widget.gameX01, gameSettingsX01)) {
      items.add(Item(value: setLegKey));
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = widget.gameX01.getGameSettings;
    final double iconSize = Utils.getResponsiveValue(
      context: context,
      mobileValue: 12,
      tabletValue: 10,
    );

    return Container(
      width: 100.w,
      padding: EdgeInsets.only(
        top: 1.5.h,
        left: 3.w,
        right: 3.w,
      ),
      child: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          colorScheme: Theme.of(context).colorScheme,
        ),
        child: ExpansionPanelList(
          expandedHeaderPadding: EdgeInsets.all(0),
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _items[index].isExpanded = isExpanded;
            });
          },
          children: _items
              .map<ExpansionPanel>(
                (item) => ExpansionPanel(
                  backgroundColor:
                      Utils.darken(Theme.of(context).colorScheme.primary, 20),
                  canTapOnHeader: true,
                  headerBuilder: (_, isExpanded) => ListTile(
                    title: Row(
                      children: [
                        SizedBox(
                          width: gameSettingsX01.getSets != 0 ? 32.w : 20.w,
                          child: Text(
                            item.value,
                            style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .fontSize,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Entypo.trophy,
                                size: iconSize.sp,
                                color: Color(0xffFFD700),
                              ),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Container(
                                    padding: EdgeInsets.only(left: 1.w),
                                    child: Text(
                                      Utils.getWinnerOfLeg(
                                                  item.value,
                                                  widget.gameX01,
                                                  context,
                                                  _items.indexOf(item))
                                              .contains('Bot')
                                          ? 'Bot'
                                          : Utils.getWinnerOfLeg(
                                              item.value,
                                              widget.gameX01,
                                              context,
                                              _items.indexOf(item)),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .fontSize,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: DetailedLegX01(
                    setLegString: item.value,
                    winnerOfLeg: Utils.getWinnerOfLeg(item.value,
                        widget.gameX01, context, _items.indexOf(item)),
                    gameX01: widget.gameX01,
                  ),
                  isExpanded: item.isExpanded,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class Item {
  Item({
    required this.value,
    this.isExpanded = false,
  });

  String value;
  bool isExpanded;
}
