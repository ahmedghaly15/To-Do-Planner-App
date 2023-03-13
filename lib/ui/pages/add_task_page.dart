import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../size_config.dart';
import '../theme.dart';
import '/ui/widgets/button.dart';
import '/ui/widgets/input_field.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _taskFormController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 30)))
      .toString();
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
//============================= UI Of The Page =============================
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: context.theme.colorScheme.background,
        appBar: _appBar(),
        body: Container(
          margin: EdgeInsets.only(top: SizeConfig.screenHeight * 0.02),
          padding:
              EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.05),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  margin:
                      EdgeInsets.only(bottom: SizeConfig.screenHeight * 0.03),
                  child: Text("Add Task", style: haedingStyle),
                ),
                //=============== Write your Task ===============
                InputField(
                  title: "Task",
                  hint: "Write a task",
                  controller: _taskFormController,
                  suggestions: true,
                  capitalization: TextCapitalization.sentences,
                ),
                //=============== Choose A Date ===============
                InputField(
                  title: "Date",
                  suggestions: false,
                  capitalization: TextCapitalization.none,
                  hint: DateFormat.yMd().format(_selectedDate),
                  widget: IconButton(
                    icon: const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () => _getDateFromUser(),
                  ),
                ),
                //=============== Start Time & End Time Of The Task ===============
                Row(
                  children: <Widget>[
                    Expanded(
                      child: InputField(
                        title: "Start Time",
                        suggestions: false,
                        capitalization: TextCapitalization.none,
                        hint: _startTime,
                        widget: IconButton(
                          icon: const Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          ),
                          onPressed: () => _getTimeFromUser(isStartTime: true),
                        ),
                      ),
                    ),
                    SizedBox(width: SizeConfig.screenWidth * 0.04),
                    Expanded(
                      child: InputField(
                        title: "End Time",
                        hint: _endTime,
                        suggestions: false,
                        capitalization: TextCapitalization.none,
                        widget: IconButton(
                          icon: const Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          ),
                          onPressed: () => _getTimeFromUser(isStartTime: false),
                        ),
                      ),
                    ),
                  ],
                ),
                //=============== Reminder ===============
                InputField(
                  title: "Remind",
                  suggestions: false,
                  capitalization: TextCapitalization.none,
                  hint: "$_selectedRemind minutes early",
                  widget: Row(
                    children: <Widget>[
                      DropdownButton(
                        dropdownColor: Colors.grey[500],
                        borderRadius: BorderRadius.circular(10),
                        items: remindList
                            .map<DropdownMenuItem<String>>(
                              (int value) => DropdownMenuItem<String>(
                                value: value.toString(),
                                child: Text(
                                  "$value",
                                  style: bodyStyle3,
                                ),
                              ),
                            )
                            .toList(),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                        iconSize: 32,
                        elevation: 4,
                        underline: Container(height: 0),
                        style: subTitleStyle,
                        onChanged: (String? newVal) {
                          setState(() {
                            _selectedRemind = int.parse(newVal!);
                          });
                        },
                      ),
                      SizedBox(width: SizeConfig.screenWidth * 0.02),
                    ],
                  ),
                ),
                //=============== Times Of Repeating The Task ===============
                InputField(
                  title: "Repeat",
                  suggestions: false,
                  capitalization: TextCapitalization.none,
                  hint: _selectedRepeat,
                  widget: Row(
                    children: <Widget>[
                      DropdownButton(
                        borderRadius: BorderRadius.circular(10),
                        dropdownColor: Colors.grey[500],
                        items: repeatList
                            .map<DropdownMenuItem<String>>(
                              (String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: bodyStyle3,
                                ),
                              ),
                            )
                            .toList(),
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                        iconSize: 32,
                        elevation: 4,
                        underline: Container(height: 0),
                        style: subTitleStyle,
                        onChanged: (String? newVal) {
                          setState(() {
                            _selectedRepeat = newVal!;
                          });
                        },
                      ),
                      SizedBox(width: SizeConfig.screenWidth * 0.02),
                    ],
                  ),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.03),
                //=============== Task Color & Create Task Button ===============
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _colorPalette(),
                    MyButton(
                        label: "Create Task",
                        onTap: () {
                          _validateData();
                        }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//==================== Customized AppBar ====================
  AppBar _appBar() {
    return AppBar(
      backgroundColor: context.theme.colorScheme.background,
      systemOverlayStyle: SystemUiOverlayStyle(
        systemNavigationBarColor: Get.isDarkMode ? darkGreyClr : Colors.white,
        statusBarColor: Get.isDarkMode ? darkGreyClr : Colors.white,
      ),
      centerTitle: true,
      //=============== Back Button ===============
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          size: 24,
          color: Get.isDarkMode ? Colors.white : primaryClr,
        ),
        onPressed: () => Get.back(),
      ),
      elevation: 0,
    );
  }

//==================== Create Color Palettes ====================
  Column _colorPalette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Color",
          style: titleStyle,
        ),
        const SizedBox(height: 5),
        Wrap(
          direction: Axis.horizontal, // acts as a Row()
          children: List<Widget>.generate(
            3,
            (int index) => GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  backgroundColor: index == 0
                      ? irisTaskColor
                      : index == 1
                          ? lilacColor
                          : amethystColor,
                  radius: 14,
                  child: _selectedColor == index
                      ? const Icon(
                          Icons.done,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

//==================== Check Data Before Creating a Task ====================
  _validateData() {
    if (_taskFormController.text.isNotEmpty) {
      _addTasksToDb();
      Get.back();
    } else if (_taskFormController.text.isEmpty) {
      Get.snackbar(
        "Warning",
        "Don't forget to write a task",
        titleText: Text("Warning",
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            )),
        messageText: Text("Don't forget to write a task",
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            )),
        backgroundColor: primaryClr,
        colorText: Colors.white,
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.white,
          size: 30,
        ),
        duration: const Duration(milliseconds: 3500),
        shouldIconPulse: true,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 25),
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        borderRadius: 10,
        snackPosition: SnackPosition.BOTTOM,
        snackStyle: SnackStyle.FLOATING,
        forwardAnimationCurve: Curves.easeInExpo,
        reverseAnimationCurve: Curves.easeIn,
        animationDuration: const Duration(milliseconds: 800),
      );
    }
  }

//==================== Add Data To Databasae ====================
  _addTasksToDb() async {
    int value = await _taskController.addTask(
      task: Task(
        taskText: _taskFormController.text,
        isCompleted: 0,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        color: _selectedColor,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
      ),
    );
    print('$value');
  }

//==================== Display a DatePicker ====================
  _getDateFromUser() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2040),
      initialEntryMode: DatePickerEntryMode.calendar,
    );

    if (pickedDate != null) {
      setState(() => _selectedDate = pickedDate);
    } else {
      print("It's null or something is wrong.");
    }
  }

//==================== Display a TimePicker ====================
  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode.dial,
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(
              (DateTime.now().add(const Duration(minutes: 30))),
            ),
    );

    // ignore: use_build_context_synchronously
    String formattedPickedTime = pickedTime!.format(context);
    if (isStartTime) {
      setState(() => _startTime = formattedPickedTime);
    } else if (!isStartTime) {
      setState(() => _endTime = formattedPickedTime);
    }
  }
}
