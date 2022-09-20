library dartApp.globals;

import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

ItemScrollController scrollController =
    ItemScrollController(); //for scrolling to player whos turn it is in game
ScrollController scrollControllerPlayers = new ScrollController();
ScrollController scrollControllerTeams = new ScrollController();

TextEditingController newPlayerController = new TextEditingController();
TextEditingController newTeamController = new TextEditingController();

TextEditingController editTeamController = new TextEditingController();
TextEditingController editPlayerController = new TextEditingController();

ItemScrollController newItemScrollController() {
  scrollController = new ItemScrollController();
  return scrollController;
}

ScrollController newScrollControllerPlayers() {
  scrollControllerPlayers = new ScrollController();
  return scrollControllerPlayers;
}

ScrollController newScrollControllerTeams() {
  scrollControllerTeams = new ScrollController();
  return scrollControllerTeams;
}

void disposeScrollControllersForGamesettings() {
  scrollControllerPlayers.dispose();
  scrollControllerTeams.dispose();
  newPlayerController.dispose();
  newTeamController.dispose();
  editPlayerController.dispose();
  editTeamController.dispose();
}
