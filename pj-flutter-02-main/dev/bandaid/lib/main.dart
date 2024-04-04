import 'package:bandaid/page/home_page.dart';
import 'package:bandaid/utils/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:bandaid/page/landing_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  String loggedIn = await readAuthToken();
  runApp(
    ResponsiveSizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
          debugShowCheckedModeBanner: false, home: loggedIn=="" ? LandingPage(): Homepage());
    }),
  );
}
