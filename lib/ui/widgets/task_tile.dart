import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/task.dart';
import '../size_config.dart';
import '../theme.dart';

//==================== Building A Customize Task Tile ====================
class TaskTile extends StatelessWidget {
  const TaskTile(
    this.task, {
    Key? key,
  }) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(
            SizeConfig.orientation == Orientation.landscape ? 4 : 15),
      ),
      width: SizeConfig.orientation == Orientation.landscape
          ? SizeConfig.screenWidth / 2
          : SizeConfig.screenWidth,
      margin: EdgeInsets.only(bottom: getProportionateScreenHeight(12)),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.screenWidth * 0.05,
          vertical: SizeConfig.screenHeight * 0.02,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _getTaskClr(task.color),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      task.taskText!,
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.02),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.access_time_filled_rounded,
                          color: Colors.grey[200],
                          size: 18,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "${task.startTime} - ${task.endTime}",
                          style: GoogleFonts.lato(
                              textStyle: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[100],
                          )),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.screenWidth * 0.01,
              ),
              height: SizeConfig.screenHeight * 0.08,
              width: SizeConfig.screenWidth * 0.0015,
              color: Colors.grey[300]!,
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                task.isCompleted == 0 ? "TO-DO" : "COMPLETED",
                style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

//==================== Choosing The Task Color ====================
  _getTaskClr(int? color) {
    switch (color) {
      case 0:
        return irisTaskColor;
      case 1:
        return lilacColor;
      case 2:
        return amethystColor;
      default:
        return irisTaskColor;
    }
  }
}
