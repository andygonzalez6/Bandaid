import 'dart:convert';
import 'package:bandaid/page/userInfo_page.dart';
import 'package:bandaid/utils/google_signin_api.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:bandaid/page/home_page.dart';
import 'package:bandaid/utils/api_endpoints.dart';
import 'package:bandaid/utils/user_preferences.dart';
import 'package:bandaid/utils/user_functions.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Define APIs here
  static const loginEndpointURL = AuthRouterEndPoints.login;

  Future<void> login(String email, String password) async {
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    try {
      var url = Uri.parse(getServerApiUrl(loginEndpointURL));

      Map<String, String> body = {
        'username': email,
        'password': password,
      };

      final http.Response response =
          await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseJson = jsonDecode(response.body);
        // set token in local storage
        writeAuthToken(responseJson['access_token']);

        emailController.clear();
        passwordController.clear();
        final bool firstTimeUser = await firstTimeUserMode(Get.context!);
        if (!firstTimeUser) {
          Navigator.of(Get.context!)
              .push(MaterialPageRoute(builder: (context) => UserInfoPage()));
        } else {
          Navigator.of(Get.context!).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Homepage()),
              (route) => false);
        }
      } else {
        throw Error();
      }
    } catch (error) {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return const SimpleDialog(
              children: [Text('Invalid Email and/or Password')],
            );
          });
    }
  }

  Future googleSignIn() async {
    final userIdToken = await GoogleSignInApi.login();

    if (userIdToken != null) {
      try {
        var headers = {'Content-Type': 'application/json'};
        var googleOauthEndpointUrl = AuthRouterEndPoints.google_oauth;
        var url = Uri.parse(getServerApiUrl(googleOauthEndpointUrl));

        Map<String, String> body = {
          "id_token" : userIdToken,
        };
        
        final http.Response response = await http.post(url, headers: headers, body: jsonEncode(body));

        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);
          // set token in local storage
          writeAuthToken(json['access_token']);

          // User shouldn't able to navigate back to login screen once signed in
         final bool firstTimeUser = await firstTimeUserMode(Get.context!);
          if (!firstTimeUser) {
          Navigator.of(Get.context!)
              .push(MaterialPageRoute(builder: (context) => UserInfoPage()));
        } else {
          Navigator.of(Get.context!).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Homepage()),
              (route) => false);
        }
        } else {
          // Clean up google sign in cache
          await GoogleSignInApi.logout();
          throw Error();
        }
      } catch (error) {
        Get.back();
        showDialog(
            context: Get.context!,
            builder: (context) {
              return const SimpleDialog(
                children: [Text('Invalid email')],
              );
            });
      }
    } else {
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context) {
            return const SimpleDialog(
              children: [Text('Invalid email')],
            );
          });
    }
  }
}
