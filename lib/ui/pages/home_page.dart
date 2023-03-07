import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../theme.dart';
import '../widgets/button.dart';
import '../widgets/task_tile.dart';
import '/services/theme_services.dart';
import '/ui/pages/add_task_page.dart';
import '/ui/size_config.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskController _taskController = Get.put(TaskController());
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
//============================= UI Of The Page =============================
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: context.theme.colorScheme.background,
        appBar: _appBar(),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              _addTaskBar(),
              _addDateBar(),
              const SizedBox(height: 6),
              _showTasks(),
            ],
          ),
        ));
  }

//==================== Customize AppBar ====================
  AppBar _appBar() {
    return AppBar(
      backgroundColor: context.theme.colorScheme.background,
      leading: IconButton(
        onPressed: () async {
          ThemeServices().switchTheme();
        },
        icon: Icon(
          Get.isDarkMode
              ? Icons.wb_sunny_outlined
              : Icons.nightlight_round_outlined,
          size: 28,
          color: Get.isDarkMode ? Colors.white : darkGreyClr,
        ),
      ),
      elevation: 0,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.cleaning_services_rounded,
            size: 28,
            color: Get.isDarkMode ? Colors.white : darkGreyClr,
          ),
          onPressed: () {
            if (_taskController.taskList.isEmpty) {
              return;
            } else {
              _showConfirmBottomSheet();
            }
          },
        ),
        const SizedBox(width: 5),
        const CircleAvatar(
          backgroundImage: AssetImage('assets/images/person.jpeg'),
          radius: 18,
        ),
        const SizedBox(width: 20),
      ],
    );
  }

//==================== Build A Customize TaskBar ====================
  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHaedingStyle,
              ),
              Text("Today", style: haedingStyle),
            ],
          ),
          MyButton(
              label: "Add Task",
              onTap: () async {
                await Get.to(
                  () => const AddTaskPage(),
                  transition: Transition.cupertinoDialog,
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.easeIn,
                );
                _taskController.getTasks();
              }),
        ],
      ),
    );
  }

//==================== Build A Date Bar ====================
  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 6, left: 15),
      child: DatePicker(
        DateTime.now(), // start date
        width: 70,
        height: 100,
        initialSelectedDate: _selectedDate,
        selectedTextColor: Colors.white,
        selectionColor: primaryClr,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (DateTime newDate) {
          setState(() {
            _selectedDate = newDate;
          });
        },
      ),
    );
  }

//==================== Displaying Tasks In The Page ====================
  _showTasks() {
    return Expanded(
      child: Obx(() {
        if (_taskController.taskList.isEmpty) {
          return _noTaskMsg();
        } else {
          return ListView.builder(
            itemCount: _taskController.taskList.length,
            scrollDirection: SizeConfig.orientation == Orientation.landscape
                ? Axis.horizontal
                : Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              Task task = _taskController.taskList[index];
              if (task.repeat == 'Daily' ||
                  task.date == DateFormat.yMd().format(_selectedDate) ||
                  (task.repeat == 'Weekly' &&
                      _selectedDate
                                  .difference(
                                      DateFormat.yMd().parse(task.date!))
                                  .inDays %
                              7 ==
                          0) ||
                  (task.repeat == 'Monthly' &&
                      DateFormat.yMd().parse(task.date!).day ==
                          _selectedDate.day)) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 1200),
                  child: SlideAnimation(
                    horizontalOffset: 300,
                    child: FadeInAnimation(
                      child: GestureDetector(
                        onTap: () => _showBottomSheet(context, task),
                        child: TaskTile(task),
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          );
        }
      }),
    );
  }

//==================== In Case There Are No Created Tasks ====================
  _noTaskMsg() {
    return Stack(
      children: <Widget>[
        AnimatedPositioned(
          duration: const Duration(seconds: 2),
          child: SingleChildScrollView(
            child: Wrap(
              direction: SizeConfig.orientation == Orientation.landscape
                  ? Axis.horizontal
                  : Axis.vertical,
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                SizeConfig.orientation == Orientation.landscape
                    ? const SizedBox(height: 6)
                    : const SizedBox(height: 120),
                SvgPicture.asset(
                  "assets/images/task.svg",
                  height: 100,
                  semanticsLabel: "Task",
                  color: primaryClr.withOpacity(0.5),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Text(
                    "You don't have any tasks yet!\nAdd new tasks to make your days productive",
                    style: subTitleStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizeConfig.orientation == Orientation.landscape
                    ? const SizedBox(height: 120)
                    : const SizedBox(height: 180),
              ],
            ),
          ),
        ),
      ],
    );
  }

//==================== Displaying Bottom Sheet ====================
  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 4),
          width: SizeConfig.screenWidth,
          height: (SizeConfig.orientation == Orientation.landscape)
              ? (task.isCompleted == 1
                  ? SizeConfig.screenHeight * 0.6
                  : SizeConfig.screenHeight * 0.8)
              : (task.isCompleted == 1
                  ? SizeConfig.screenHeight * 0.30
                  : SizeConfig.screenHeight * 0.39),
          color: Get.isDarkMode ? darkHeaderClr : Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Container(
                  height: 6,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              task.isCompleted == 1
                  ? Container()
                  : _buildBottomSheet(
                      label: "Completed",
                      onTap: () {
                        _taskController.markTaskCompleted(task.id!);
                        Get.back();
                      },
                      color: primaryClr,
                    ),
              _buildBottomSheet(
                label: "Delete",
                onTap: () {
                  _taskController.deleteTasks(task);
                  Get.back();
                },
                color: Colors.red[400]!,
              ),
              const SizedBox(height: 15),
              _buildBottomSheet(
                label: "Close",
                onTap: () {
                  Get.back();
                },
                color: primaryClr,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

//==================== Displaying Bottom Sheet For Clearing Confirmation ====================
  _showConfirmBottomSheet() {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 4),
          width: SizeConfig.screenWidth,
          height: (SizeConfig.orientation == Orientation.landscape)
              ? SizeConfig.screenHeight * 0.55
              : SizeConfig.screenHeight * 0.30,
          color: Get.isDarkMode ? darkHeaderClr : Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Container(
                  height: 6,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
                  ),
                ),
              ),
              SizedBox(
                  height:
                      SizeConfig.orientation == Orientation.landscape ? 5 : 15),
              Text(
                "Are you sure you want to clear all tasks?",
                style: titleStyle.copyWith(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                  height: SizeConfig.orientation == Orientation.landscape
                      ? 10
                      : 20),
              _buildBottomSheet(
                label: "Delete",
                onTap: () {
                  _taskController.deleteAllTasks();
                  Get.back();
                },
                color: Colors.red[400]!,
              ),
              SizedBox(
                  height:
                      SizeConfig.orientation == Orientation.landscape ? 5 : 10),
              _buildBottomSheet(
                label: "Cancel",
                onTap: () {
                  Get.back();
                },
                color: primaryClr,
              ),
              SizedBox(
                  height:
                      SizeConfig.orientation == Orientation.landscape ? 5 : 10),
            ],
          ),
        ),
      ),
    );
  }

//==================== Customize Bottom Sheet ====================
  _buildBottomSheet({
    required String label,
    required Function() onTap,
    required Color color,
    bool isClose = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : color,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : color,
        ),
        child: Center(
          child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
