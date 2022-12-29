import 'package:dart_app/models/game_settings/score_training/game_settings_score_training_p.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/add_player_team_btn/add_player_team_btn_dialogs.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AddPlayerBtnScoreTraining extends StatelessWidget {
  const AddPlayerBtnScoreTraining({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10.w,
      padding: EdgeInsets.only(
        bottom: 5,
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
            highlightColor: Colors.transparent,
            shadowColor: Colors.transparent),
        child: FloatingActionButton(
          splashColor: Colors.transparent,
          backgroundColor: Utils.getPrimaryColorDarken(context),
          elevation: 0.0,
          onPressed: () => AddPlayerTeamBtnDialogs.showDialogForAddingPlayer(
              context.read<GameSettingsScoreTraining_P>(), context),
          child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
