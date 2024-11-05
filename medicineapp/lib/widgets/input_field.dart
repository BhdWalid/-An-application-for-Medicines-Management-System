import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../theme.dart';

class InputField extends StatelessWidget {
  InputField(
      {super.key,
      required this.title,
      required this.note,
      this.controller,
      this.widget,
      this.keyboardType,
      this.inputFormatters,
      this.onEditingComplet,
      this.validator});

  final String title;
  final String note;
  final TextEditingController? controller;
  final Widget? widget;
  final TextInputType? keyboardType;
  final Function? onEditingComplet;
  final List<TextInputFormatter>? inputFormatters;
  final bool? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: titleStyle,
        ),
        Container(
          margin: EdgeInsets.only(top: 4),
          padding: EdgeInsets.only(left: 8),
         // height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey)),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  keyboardType: keyboardType ?? TextInputType.text,
                  inputFormatters: inputFormatters ?? [],
                  readOnly: widget == null ? false : true,
                  controller: controller,
                  validator: (value) {
                    if (validator == false )return null;
                    if (value == null) {
                      return 'This field is required';
                    } else {
                      return null;
                    }
                  },
                  autofocus: false,
                  style: subTitleStyle,
                  cursorColor:
                      Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
                  decoration: InputDecoration(
                    hintText: note,
                    enabledBorder:
                        const UnderlineInputBorder(borderSide: BorderSide.none),
                    focusedBorder:
                        const UnderlineInputBorder(borderSide: BorderSide.none),
                  ),
                  onEditingComplete: () {},
                ),
              ),
              widget ??
                  Container(
                    padding: EdgeInsets.only(right: 5),
                  )
            ],
          ),
        ),
      ],
    );
  }
}
