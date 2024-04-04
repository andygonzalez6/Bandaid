import 'dart:convert';
import 'package:bandaid/controllers/login_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:bandaid/utils/api_endpoints.dart';

class RegisterController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  LoginController loginController = LoginController();
  // Define APIs here
  static const registrationEndpointURL = AuthRouterEndPoints.register;

  Future<void> registerUser() async {
    var headers = {'Content-Type': 'application/json'};
    if (passwordController.text != confirmpasswordController.text) {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return const SimpleDialog(
              children: [Text('Passwords do not match')],
            );
          });
    } else {
      try {
        var url = Uri.parse(getServerApiUrl(registrationEndpointURL));

        Map<String, String> body = {
          'email': emailController.text,
          'password': passwordController.text,
        };
        final http.Response response =
            await http.post(url, headers: headers, body: json.encode(body));

        if (response.statusCode == 201) {
          showDialog(
              context: Get.context!,
              builder: (context) {
                return const SimpleDialog(
                  children: [Text('  User Created!')],
                );
              });
          Future.delayed(
              const Duration(seconds: 2),
              () => {
                loginController.login(emailController.text, passwordController.text),
                emailController.clear(),
                passwordController.clear(),
                confirmpasswordController.clear()});
        } else {
          throw Exception("$body");
        }
      } catch (e) {
        showDialog(
            context: Get.context!,
            builder: (context) {
              return const CupertinoAlertDialog(
                title: Text("Email Already in Use"),
                content: Text(
                    'Unable to create User, please try with another email'),
              );
            });
        throw Exception('Error: $e');
      }
    }
  }
}
