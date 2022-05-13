import 'package:flutter/material.dart';

class PrimaryTextField extends StatelessWidget {
  final String? value;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  const PrimaryTextField({
    Key? key,
    required this.value,
    this.focusNode,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: value == "shorten" ? TextInputType.url : TextInputType.text,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText:
            "Enter ${value == "shorten" ? 'https://google.com' : '12345'}",
        labelText:
            "Enter ${value == "shorten" ? 'URL to shorten' : 'Alias to retrieve a link'}",
      ),
      controller: controller,
    );
  }
}
