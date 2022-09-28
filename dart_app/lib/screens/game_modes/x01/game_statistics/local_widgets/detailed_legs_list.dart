import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/detailed_leg.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:sizer/sizer.dart';

class DetailedLegsList extends StatefulWidget {
  DetailedLegsList({Key? key, required this.game}) : super(key: key);

  final Game? game;

  @override
  State<DetailedLegsList> createState() => _DetailedLegsListState();
}

class _DetailedLegsListState extends State<DetailedLegsList> {
  List<Item> _items = [];

  List<Item> getItems() {
    List<Item> items = [];
    for (String setLegKey
        in (widget.game as GameX01).getAllLegSetStringsExceptCurrentOne()) {
      items.add(Item(value: setLegKey));
    }
    return items;
  }

  @override
  initState() {
    super.initState();
    _items = getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      child: Padding(
        padding: EdgeInsets.only(top: 15, left: 3.w, right: 3.w),
        child: ExpansionPanelList(
          expandedHeaderPadding: EdgeInsets.all(0),
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _items[index].isExpanded = !isExpanded;
            });
          },
          children: _items
              .map<ExpansionPanel>(
                (item) => ExpansionPanel(
                  canTapOnHeader: true,
                  headerBuilder: (_, isExpanded) => ListTile(
                    title: Container(
                      child: Row(
                        children: [
                          SizedBox(
                            width: widget.game!.getGameSettings.getSets != 0
                                ? 32.w
                                : 20.w,
                            child: Text(
                              item.value,
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  Entypo.trophy,
                                  size: 14.sp,
                                  color: Color(0xffFFD700),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text(
                                    Utils.getWinnerOfLeg(
                                                item.value, widget.game)
                                            .contains('Bot')
                                        ? 'Bot'
                                        : Utils.getWinnerOfLeg(
                                            item.value, widget.game),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14.sp),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  body: DetailedLeg(
                      setLegString: item.value,
                      game: widget.game,
                      winnerOfLeg:
                          Utils.getWinnerOfLeg(item.value, widget.game)),
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
