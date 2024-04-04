import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bandaid/controllers/login_controller.dart';
import 'package:bandaid/components/input_field.dart';
import 'package:bandaid/components/gradient_button.dart';
import 'package:bandaid/components/app_bar.dart';

class LoginPage extends StatelessWidget {
  final LoginController loginController = LoginController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(title: "Sign In"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(36),
          child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Welcome back!',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextInputField(inputController: loginController.emailController, obscureText: false, hintText: "Enter your email...", labelText: "Email",), 
                  TextInputField(inputController: loginController.passwordController, obscureText: true, hintText: "Enter your password...", labelText: "Password"), 
                  const SizedBox(
                    height: 25,
                  ),
                  GradientButton(text: "Login", onPressed: ()=> loginController.login(loginController.emailController.text, loginController.passwordController.text))
                ]),
          ),
        ),
      ),
    );
  }
}