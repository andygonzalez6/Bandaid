import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SavebuttonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const SavebuttonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
                onPressed: onClicked,
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  alignment: Alignment.center,
                  backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 28, 105, 237)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  padding: MaterialStateProperty.all( EdgeInsets.only(right: 30.sp, left: 30.sp, top: 15.sp, bottom: 15.sp)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)))
                ),
                child: Text(text, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
              );
}