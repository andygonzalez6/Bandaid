import 'package:bandaid/components/app_bar.dart';
import 'package:bandaid/components/input_field.dart';
import 'package:bandaid/utils/api_endpoints.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bandaid/widget/savebutton_widget.dart';
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// ignore: must_be_immutable
class AboutmePage extends StatelessWidget {
  TextEditingController descriptionController = TextEditingController();

  final logger = Logger();
  Future<void> sendCurrBio() async {
    try {
      final httpHeader = await buildHTTPHeader();
      final Map<String, dynamic> requestBody = {
        'field': 'description',
        'data': descriptionController.text,
      };

      final response = await http.put(
      Uri.parse('http://ec2-54-234-100-83.compute-1.amazonaws.com/api/users/details/me'),
      headers: httpHeader,
      body: json.encode(requestBody),
    );

      if (response.statusCode == 201) {
        logger.e('POST request successful');

      } else if (response.statusCode == 422) {
        // Handle a validation error or specific error response here
        logger.i('Validation Error: ${response.body}');
      } else {
        logger.i('Status code: ${response.statusCode}');
      }
    } catch (e) {
      logger.i('Error during POST request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: "About Me",
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text("Tell us about yourself!", style: TextStyle(fontSize: 20.sp)),
                TextInputField(
                  inputController: descriptionController,
                  obscureText: false,
                  hintText: "I am...",
                  labelText: "Description",
                ),
              SizedBox(height: 20),
              SavebuttonWidget(
                text: 'Save',
                onClicked: () async {
                  await sendCurrBio();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
