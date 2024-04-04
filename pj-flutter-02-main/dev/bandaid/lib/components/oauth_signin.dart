import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OauthSignIn extends StatelessWidget {
  final Function() onPressed;
  final String buttonText;
  final String imageUrl;

  const OauthSignIn({
    required this.onPressed,
    required this.buttonText,
    required this.imageUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 6.h,
        margin:  EdgeInsets.all(15.sp),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Color.fromARGB(255, 231, 231, 231),
        ),
        child: TextButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)))),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                imageUrl,
                width: 20,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(buttonText,
                  style: TextStyle(color: Colors.black, fontSize: 18.sp)),
            ],
          ),
        ));
  }
}
