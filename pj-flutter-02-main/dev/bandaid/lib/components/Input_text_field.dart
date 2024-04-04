import 'package:flutter/material.dart';

class InputTextFieldWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final bool obscureText;
  const InputTextFieldWidget(this.textEditingController, this.hintText, this.obscureText);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: TextField(
        maxLines: obscureText ? 1: null,
        controller: textEditingController,
        decoration: InputDecoration(
            alignLabelWithHint: true,
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black)),
            fillColor: Colors.white54,
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            contentPadding: const EdgeInsets.only(bottom: 15),
            focusColor: Colors.white60),
            obscureText: obscureText,
      ),
    );
  }
}

Widget controllerWidget(TextEditingController controller, String text) {
  return Column(
    children: [
      const SizedBox(
        height: 20,
      ),
      InputTextFieldWidget(controller, text, false),
      const SizedBox(
        height: 20,
      ),
    ],
  );
}