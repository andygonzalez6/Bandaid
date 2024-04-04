import 'package:bandaid/components/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:bandaid/utils/api_endpoints.dart';
import 'package:bandaid/widget/savebutton_widget.dart';
import 'dart:convert';

class InstrumentsPage extends StatefulWidget {
  @override
  _InstrumentsPageState createState() => _InstrumentsPageState();
}

class _InstrumentsPageState extends State<InstrumentsPage> {
  List<String> insts = [];
  List<int> ids = [];
  List<String> selectedInsts = [];

  // Lists to store newly added and removed inst IDs
  List<int> newlyAddedIds = [];
  List<int> removedIds = [];

  Map<String, bool> isButtonPressedMap = {}; // Track button press state
  var logger = Logger();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future fetchData() async {
    final response = await http.get(Uri.parse('http://ec2-54-234-100-83.compute-1.amazonaws.com/api/instruments/all'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('data') && responseData['data'] is List<dynamic>) {
        final List<dynamic> instData = responseData['data'];

        setState(() {
          insts = instData.map((inst) => inst['name'].toString()).toList();
          ids = instData.map((inst) => inst['id'] as int).toList();
          

          // Initialize the button press state for each inst to false
          for (var inst in insts) {
            isButtonPressedMap[inst] = false;
          }
        });

      } else {
        throw Exception('Data not in expected format');
      }
    } else {
      throw Exception('Failed to load data');
    }

    final httpHeader = await buildHTTPHeader();
    final response_user = await http.get(
      Uri.parse('http://ec2-54-234-100-83.compute-1.amazonaws.com/api/instruments/me'),
      headers: httpHeader,
    );

    if (response_user.statusCode == 201) {
      final Map<String, dynamic> responseUserData = json.decode(response_user.body);

      if (responseUserData.containsKey('data')) {
        List<dynamic> payload = responseUserData['data']['payload'];

        for (var item in payload) {
          if (item['selected'] == true) {
            selectedInsts.add(item['name']);
          }
        }

        setState(() {
          // Initialize the button press state for each inst to true
          for (var inst in insts) {
            isButtonPressedMap[inst] = selectedInsts.contains(inst);
          }
        });

      } else {
        throw Exception('Data not in expected format');
      }
    } else if (response_user.statusCode == 401) {
      print('Authentication error: ${response_user.statusCode}');
    } else {
      throw Exception('Failed to load data ${response_user.statusCode}');
    }

  }

  // Function to send the pressed inst IDs in a DELETE request
  Future<void> deleteRemovedInsts() async {
    try {
      final httpHeader = await buildHTTPHeader();

      for (int removedId in removedIds) {
        final response = await http.delete(
          Uri.parse('http://ec2-54-234-100-83.compute-1.amazonaws.com/api/instruments/me/$removedId'),
          headers: httpHeader,
        );

        if (response.statusCode == 200) {
          logger.e('DELETE request successful for ID: $removedId');
        } else if (response.statusCode == 404) {
          // Handle a not found error or specific error response here
          logger.i('Not Found Error: ${response.body}');
        } else {
          logger.i('Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      logger.i('Error during DELETE request: $e');
    }
  }

  Future<void> sendCurrInsts() async {
    try {
      final httpHeader = await buildHTTPHeader();

      // Convert the Set to a List before encoding it
      final List<int> currGenreList = newlyAddedIds.toList();
      final Map<String, dynamic> requestBody = {
        "id": currGenreList,
      };

      final response = await http.post(
        Uri.parse('http://ec2-54-234-100-83.compute-1.amazonaws.com/api/instruments/me'),
        headers: httpHeader,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        logger.e('POST request successful');

        // After successfully adding new insts, delete removed insts one-by-one
        await deleteRemovedInsts();
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
        title: "Instruments Page",
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.only(top: 16.0, bottom: 66.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3,
                  ),
                  itemCount: insts.length,
                  itemBuilder: (context, index) {
                    final inst = insts[index];
                    final isButtonPressed = isButtonPressedMap[inst] ?? false;

                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            // Toggle the button press state for the current inst
                            isButtonPressedMap[inst] = !isButtonPressed;
                            newlyAddedIds.clear();
                            removedIds.clear();

                            // Loop through all insts to update the lists
                            for (int index = 0; index < insts.length; index++) {
                              // Get the inst at the current index
                              var inst = insts[index];

                              // Check if the button for the current inst is pressed
                              if (isButtonPressedMap[inst] == true) {
                                // Remove the ID from removedIds if it exists
                                removedIds.remove(ids[index]);

                                // Add the corresponding ID to newlyAddedIds if not already present and not previously selected
                                if (!newlyAddedIds.contains(ids[index]) && !selectedInsts.contains(inst)) {
                                  newlyAddedIds.add(ids[index]);
                                }
                              } else {
                                // Remove the ID from newlyAddedIds if it exists
                                newlyAddedIds.remove(ids[index]);

                                // Add the corresponding ID to removedIds if not already present and previously selected
                                if (!removedIds.contains(ids[index]) && selectedInsts.contains(inst)) {
                                  removedIds.add(ids[index]);
                                }
                              }
                            }

                            // Debug print statements to display the current state of the lists
                            print('Newly Added IDs: $newlyAddedIds');
                            print('Removed IDs: $removedIds');
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isButtonPressed ? Color.fromARGB(255, 79, 37, 197) : Colors.white,
                          foregroundColor: isButtonPressed ? Colors.white : Colors.black54,
                        ),
                        child: Text(inst),
                      ),
                    );
                  },
                ),
              ),
              SavebuttonWidget(
                text: 'Save',
                onClicked: () async {
                  await sendCurrInsts();
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
