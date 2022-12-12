import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextfiled extends StatefulWidget {
  CustomTextfiled(
      {super.key,
      required this.controller,
      this.validator,
      this.color,
      this.hint,
      this.onChangedd,
      this.limit,
      this.icon});
  final TextEditingController controller;
  final Function? validator;
  final Function? onChangedd;
  final Color? color;
  final String? hint;
  final List<LengthLimitingTextInputFormatter>? limit;
  final IconData? icon;

  @override
  State<CustomTextfiled> createState() => _CustomTextfiledState();
}

class _CustomTextfiledState extends State<CustomTextfiled> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: widget.limit,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
        focusColor: Colors.green,
        prefixIcon: Icon(widget.icon),
        hintText: widget.hint,
      ),
      controller: widget.controller,
      style: TextStyle(color: widget.color),
      validator: (value) {
        if (widget.validator != null) {
          //doubt
          widget.validator!(value);
        }
      },
      onChanged: (value) {
        if (widget.onChangedd != null) {
          widget.onChangedd!(value);
        }
      },
    );
  }
}
