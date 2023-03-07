import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../controllers/task_controller.dart';
import '../../models/task.dart';
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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
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
    return Scaffold(
      backgroundColor: context.theme.colorScheme.background,
      appBar: _appBar(),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 5),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text("Add Task", style: haedingStyle),
                InputField(
                  title: "Title",
                  hint: "Enter title here",
                  controller: _titleController,
                ),
                InputField(
                  title: "Note",
                  hint: "Enter note here",
                  controller: _noteController,
                ),
                InputField(
                  title: "Date",
                  hint: DateFormat.yMd().format(_selectedDate),
                  widget: IconButton(
                    icon: const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () => _getDateFromUser(),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: InputField(
                        title: "Start Time",
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
                    const SizedBox(width: 10),
                    Expanded(
                      child: InputField(
                        title: "End Time",
                        hint: _endTime,
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
                InputField(
                  title: "Remind",
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
                      const SizedBox(width: 6),
                    ],
                  ),
                ),
                InputField(
                  title: "Repeat",
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
                      const SizedBox(width: 6),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
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

//==================== Customize AppBar ====================
  AppBar _appBar() {
    return AppBar(
      backgroundColor: context.theme.colorScheme.background,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          size: 24,
          color: Get.isDarkMode ? Colors.white : primaryClr,
        ),
        onPressed: () => Get.back(),
      ),
      elevation: 0,
      actions: const <Widget>[
        CircleAvatar(
          backgroundImage: AssetImage('assets/images/person.jpeg'),
          radius: 18,
        ),
        SizedBox(width: 20),
      ],
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
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTasksToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        "Warning",
        "All fields are required",
        titleText: Text("Warning",
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            )),
        messageText: Text("All fields are required",
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
        title: _titleController.text,
        note: _noteController.text,
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
