import 'package:bandaid/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:bandaid/components/oauth_signin.dart';
import 'package:bandaid/components/email_signin.dart';
import 'package:bandaid/page/register_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LandingPage extends StatelessWidget {
  //LoginController loginController = LoginController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // First half of the screen with Lottie animation
            SizedBox(
                height: 40.h,
                child: Lottie.asset('assets/lottie/girl_podcast.json')),

            // Second half of the screen with buttons
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(15),
                    child: Text(
                      "All your musical creativity in one place",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  OauthSignIn(
                      onPressed: () => {LoginController().googleSignIn()},
                      buttonText: "Continue with Google",
                      imageUrl:
                          "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/crypto%2Fsearch%20(2).png?alt=media&token=24a918f7-3564-4290-b7e4-08ff54b3c94c"),
                  OauthSignIn(
                      onPressed: () => {},
                      buttonText: "Continue with Apple",
                      imageUrl:
                          "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/socials%2Fapple-black-logo.png?alt=media&token=c44581fa-6fd2-4ae2-bd85-18bfbe6386d2"),
                  const EmailSignIn(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Not a member yet?",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      TextButton(
                        onPressed: () => {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RegisterPage()))
                        },
                        child: const Text('Sign Up',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff6D28D9))),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
