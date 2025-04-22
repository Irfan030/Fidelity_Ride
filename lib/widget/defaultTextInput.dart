import 'package:fidelityride/theme/colors.dart';
import 'package:flutter/material.dart';

class DefaultTextInput extends StatelessWidget {
  final String hint;
  final String label;
  final String? type;
  final int? maxlineHeight;
  final Function onChange;
  final String errorMsg;
  final String value;
  final String? prefixText;
  final TextInputType keyboardType;
  final bool validator;

  const DefaultTextInput({
    super.key,
    required this.hint,
    required this.label,
    this.prefixText,

    this.type,
    this.maxlineHeight = 1,
    this.validator = false,
    this.errorMsg = "Invalid value",
    this.value = "",
    required this.onChange,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,

      textAlign: TextAlign.justify,
      maxLines: maxlineHeight,
      onChanged: (value) {
        onChange(value);
      },
      initialValue: value,
      validator: (value) => validator ? errorMsg : null,

      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 0.0,
          horizontal: 10.0,
        ),
        fillColor: Colors.white,
        hintText: hint,
        labelText: label,
        prefixText: prefixText,
        prefixStyle: TextStyle(
          color: AppColor.labelColor,
          fontSize: 14,
          fontFamily: "PoppinsMedium",
        ),

        labelStyle: TextStyle(
          color: AppColor.labelColor,
          fontSize: 14,
          fontFamily: "PoppinsMedium",
        ),
        hintStyle: TextStyle(
          color: AppColor.textFieldHintTextColor,
          fontSize: 12,
          fontFamily: "PoppinsRegular",
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.secondaryColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.secondaryColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.secondaryColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.secondaryColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
