import 'package:bandaid/utils/user_functions.dart';
import 'package:flutter/material.dart';
import 'package:bandaid/page/genre_page.dart';
import 'package:bandaid/page/instrument_page.dart';
import 'package:bandaid/page/aboutme_page.dart';
import 'package:bandaid/components/gradient_button.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'You can change your preferences here.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey, // Set the color to a faded grey
                  fontStyle: FontStyle.normal,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              // Use your existing GradientButton for "Choose Genres" with enhanced styling
              GradientButton(
                text: 'Choose Genres',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GenrePage()),
                  );
                },
              ),
              SizedBox(height: 10),
              // Use your existing GradientButton for "Choose Instruments" with enhanced styling
              GradientButton(
                text: 'Choose Instruments',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InstrumentsPage()),
                  );
                },
              ),
              SizedBox(height: 10),

              GradientButton(
                text: 'Update \"About Me\"',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutmePage()),
                  );
                },
              ),
              
               SizedBox(height: 10),
              
              // Use your existing GradientButton for "Choose Instruments" with enhanced styling
              GradientButton(
                text: 'Upload Sample',
                onPressed: () async{
                 await uploadSound();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
