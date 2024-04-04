import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const GradientButton({required this.text, required this.onPressed, Key? key}): super(key: key);

  final double borderRadius = 25;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: const LinearGradient(colors: [Color(0xff4338CA), Color(0xff6D28D9)])),
        child: ElevatedButton(
          style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          alignment: Alignment.center,
          padding: MaterialStateProperty.all( EdgeInsets.only(
          right: 30.sp, left: 30.sp, top: 15.sp, bottom: 15.sp)),
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)))
          ),
          onPressed: onPressed,
          child: Text(text, style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold))
          )
        );
  }
}