import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bandaid/controllers/register_controller.dart';
import 'package:bandaid/components/input_field.dart';
import 'package:bandaid/components/gradient_button.dart';
import 'package:bandaid/components/app_bar.dart';

class RegisterPage extends StatelessWidget {
  final RegisterController registerController = RegisterController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(title: "Register"),
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
                    'Welcome to Bandaid, let\'s get you registered.',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextInputField(inputController: registerController.emailController, obscureText: false, hintText: "Enter your email...", labelText: "Email",), 
                  TextInputField(inputController: registerController.passwordController, obscureText: true, hintText: "Enter your password...", labelText: "Password"), 
                  TextInputField(inputController: registerController.confirmpasswordController, obscureText: true, hintText: "Confirm your password...", labelText: "Confirm Password"), 
                  const SizedBox(
                    height: 25,
                  ),
                  GradientButton(text: "Create My Account", onPressed: ()=> registerController.registerUser())
                ]),
          ),
        ),
      ),
    );
  }
}