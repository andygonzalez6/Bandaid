import 'package:bandaid/model/user.dart';
import 'package:bandaid/page/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  var myUser = User(
    id: -1,
    imagePath:
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&q=60&w=800&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D',
    name: 'Sally Ride',
    email: 'sally.ride@gmail.com',
    about:
        'Lead Vocalist of Wink-281. Saxophonist. Open to collaboration on tracks needing female vocals or a little extra jazz!',
    isDarkMode: false,
  );
}

// Define all user related preference key value
const String userAuthToken = 'pj-flutter-02-user-auth-token';

// Read user's auth token from local device's storage
Future<String> readAuthToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? value = prefs.getString(userAuthToken);
  return value ?? ""; // Return an empty string if value is null
}

Future<int> getUserId() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final int? value = prefs.getInt("id");
  return value ?? -1;
}

// Write user's auth token to local device's storage
Future<bool> writeAuthToken(String token) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool result = await prefs.setString(userAuthToken, token);
  return result;
}

Future<void> logout(context) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool result = await prefs.clear();
  if (result) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LandingPage()),
        (route) => false);
  } else {}
}
