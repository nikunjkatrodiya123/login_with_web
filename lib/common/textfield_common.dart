import 'package:flutter/material.dart';

import '../color_controller.dart';

class TextFieldCommon extends StatelessWidget {
  final int? minLines;
  final int? maxLines;
  final String? labelText;
  final Widget? prefixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const TextFieldCommon(
      {Key? key,
      this.labelText,
      this.validator,
      this.prefixIcon,
      this.controller,
      this.minLines,
      this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        minLines: minLines ?? 1,
        maxLines: maxLines ?? 1,
        controller: controller,
        decoration: InputDecoration(
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorController.buttonColor),
              borderRadius: BorderRadius.circular(15)),
          prefixIcon: prefixIcon,
          prefixIconColor: ColorController.buttonColor,
          labelText: labelText ?? '',
        ),
        keyboardType: TextInputType.emailAddress,
        onFieldSubmitted: (value) {
          //Validator
        },
        validator: validator ?? (value) {});
  }
}
