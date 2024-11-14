import 'package:chatty/common/values/colors.dart';
import 'package:flutter/material.dart';

class ProfileTextfield extends StatelessWidget {
  const ProfileTextfield({
    super.key,
    this.textEditingController,
    this.focusNode,
    this.hintText,
    this.keyboardType, this.onChanged,
  });

  final TextEditingController? textEditingController;
  final FocusNode? focusNode;
  final String? hintText;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      autofocus: false,
      focusNode: focusNode,
      controller: textEditingController,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: EdgeInsets.only(
          left: 15,
          bottom: 0,
          top: 0,
        ),
        hintStyle: TextStyle(
          fontSize: 16,
          color: AppColors.primaryText,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
