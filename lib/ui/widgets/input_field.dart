import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme.dart';
import '/ui/size_config.dart';

//==================== Building A Customize Input Field ====================
class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.title,
    required this.hint,
    required this.suggestions,
    required this.capitalization,
    this.controller,
    this.widget,
  }) : super(key: key);

  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;
  final bool? suggestions;
  final TextCapitalization? capitalization;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: titleStyle),
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.only(left: 14),
            width: SizeConfig.screenWidth,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    enableSuggestions: suggestions!,
                    textCapitalization: capitalization!,
                    autofocus: false,
                    readOnly: widget != null ? true : false,
                    style: subTitleStyle,
                    cursorColor:
                        Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: subTitleStyle,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Get.isDarkMode ? darkGreyClr : Colors.white,
                          width: 0,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Get.isDarkMode ? darkGreyClr : Colors.white,
                          width: 0,
                        ),
                      ),
                    ),
                  ),
                ),
                widget ?? Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
