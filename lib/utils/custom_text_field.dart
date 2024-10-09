import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    super.key,
    required this.controller,
    this.onTap,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLines,
    this.hintText,
    this.onChange,
    this.readOnly,
    this.keyboardType,
  });

  final TextEditingController controller;
  final void Function()? onTap;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLines;
  final String? hintText;
  final void Function(String)? onChange;
  final bool? readOnly;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: TextField(
        controller: controller,
        readOnly: readOnly ?? false,
        cursorColor: Colors.grey,
        maxLines: maxLines ?? 1,
        cursorHeight: 20,
        onChanged: onChange,
        keyboardType: keyboardType,
        onTap: onTap,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 15, color: Colors.grey.shade500),
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          contentPadding: EdgeInsets.all(8),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
        ),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.0),
              spreadRadius: 0,
              blurRadius: 0,
              offset: Offset(-1, -1),
            ),
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 9,
              blurRadius: 9,
              offset: Offset(5, 5),
            ),
          ]),
    );
  }
}
