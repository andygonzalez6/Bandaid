import 'package:flutter/material.dart';
import 'package:bandaid/page/login_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EmailSignIn extends StatelessWidget {
  const EmailSignIn({ Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 6.h,
        margin: EdgeInsets.all(15.sp),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: const Color.fromARGB(255, 231, 231, 231),
        ),
        child: TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)))
          ),
          onPressed: ()=>{
             Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()))
          },
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.email),
              const SizedBox(
                width: 10,
              ),
              Text("Continue with email", style: TextStyle(color: Colors.black, fontSize: 18.sp)),
            ],
          ),
        ));
  }
}