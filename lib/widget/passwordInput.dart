import 'package:fidelityride/constant.dart';
import 'package:fidelityride/theme/colors.dart';
import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  final String hint;
  final String label;
  final String? type;
  final int? maxlength;
  final Function onChange;
  final String errorMsg;
  final bool validator;

  const PasswordInput({
    super.key,
    required this.hint,
    required this.label,
    this.type,
    this.maxlength,
    this.validator = false,
    this.errorMsg = "Invalid value",
    required this.onChange,
  });

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: passwordVisible,
      textAlign: TextAlign.justify,
      onChanged: (value) {
        widget.onChange(value);
      },
      validator: (value) => widget.validator ? widget.errorMsg : null,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(
            passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: AppColor.textFieldHintTextColor,
          ),
          onPressed: () {
            setState(() {
              passwordVisible = !passwordVisible;
            });
          },
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        filled: true,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 0.0,
          horizontal: 10.0,
        ),
        fillColor: Colors.white,
        hintText: widget.hint,
        labelText: widget.label,
        labelStyle: TextStyle(
          color: AppColor.labelColor,
          fontSize: 14,
          fontFamily: AppData.openSansMedium,
        ),
        hintStyle: TextStyle(
          color: AppColor.textFieldHintTextColor,
          fontSize: 12,
          fontFamily: AppData.openSansMedium,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.mainColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.mainColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.mainColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.mainColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
