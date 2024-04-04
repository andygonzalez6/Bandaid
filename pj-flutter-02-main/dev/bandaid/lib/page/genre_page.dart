import 'package:bandaid/components/app_bar.dart';
import 'package:bandaid/widget/savebutton_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:bandaid/utils/api_endpoints.dart';
import 'dart:convert';

class GenrePage extends StatefulWidget {
  @override
  _GenrePageState createState() => _GenrePageState();
}

class _GenrePageState extends State<GenrePage> {
  List<String> genres = [];
  List<int> ids = [];
  List<String> selectedGenres = [];

  // Lists to store newly added and removed genre IDs
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
    final response = await http.get(Uri.parse('http://ec2-54-234-100-83.compute-1.amazonaws.com/api/genres/all'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.containsKey('data') && responseData['data'] is List<dynamic>) {
        final List<dynamic> genreData = responseData['data'];

        setState(() {
          genres = genreData.map((genre) => genre['name'].toString()).toList();
          ids = genreData.map((genre) => genre['id'] as int).toList();
          

          // Initialize the button press state for each genre to false
          for (var genre in genres) {
            isButtonPressedMap[genre] = false;
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
      Uri.parse('http://ec2-54-234-100-83.compute-1.amazonaws.com/api/genres/me'),
      headers: httpHeader,
    );

    if (response_user.statusCode == 200) {
      final Map<String, dynamic> responseUserData = json.decode(response_user.body);

      if (responseUserData.containsKey('data')) {
        List<dynamic> payload = responseUserData['data']['payload'];

        for (var item in payload) {
          if (item['selected'] == true) {
            selectedGenres.add(item['name']);
          }
        }

        setState(() {
          // Initialize the button press state for each genre to true
          for (var genre in genres) {
            isButtonPressedMap[genre] = selectedGenres.contains(genre);
          }
        });

      } else {
        throw Exception('Data not in expected format');
      }
    } else if (response_user.statusCode == 401) {
      print('Authentication error: ${response_user.statusCode}');
    } else {
      throw Exception('Failed to load data');
    }

  }

  // Function to send the pressed genre IDs in a DELETE request
  Future<void> deleteRemovedGenres() async {
    try {
      final httpHeader = await buildHTTPHeader();

      for (int removedId in removedIds) {
        final response = await http.delete(
          Uri.parse('http://ec2-54-234-100-83.compute-1.amazonaws.com/api/genres/me/$removedId'),
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

  Future<void> sendCurrGenres() async {
    try {
      final httpHeader = await buildHTTPHeader();

      // Convert the Set to a List before encoding it
      final List<int> currGenreList = newlyAddedIds.toList();
      final Map<String, dynamic> requestBody = {
        "id": currGenreList,
      };

      final response = await http.post(
        Uri.parse('http://ec2-54-234-100-83.compute-1.amazonaws.com/api/genres/me'),
        headers: httpHeader,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        logger.e('POST request successful');

        // After successfully adding new genres, delete removed genres one-by-one
        await deleteRemovedGenres();
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
        title: "Genres Page",
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
                  itemCount: genres.length,
                  itemBuilder: (context, index) {
                    final genre = genres[index];
                    final isButtonPressed = isButtonPressedMap[genre] ?? false;

                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            // Toggle the button press state for the current genre
                            isButtonPressedMap[genre] = !isButtonPressed;
                            newlyAddedIds.clear();
                            removedIds.clear();

                            // Loop through all genres to update the lists
                            for (int index = 0; index < genres.length; index++) {
                              // Get the genre at the current index
                              var genre = genres[index];

                              // Check if the button for the current genre is pressed
                              if (isButtonPressedMap[genre] == true) {
                                // Remove the ID from removedIds if it exists
                                removedIds.remove(ids[index]);

                                // Add the corresponding ID to newlyAddedIds if not already present and not previously selected
                                if (!newlyAddedIds.contains(ids[index]) && !selectedGenres.contains(genre)) {
                                  newlyAddedIds.add(ids[index]);
                                }
                              } else {
                                // Remove the ID from newlyAddedIds if it exists
                                newlyAddedIds.remove(ids[index]);

                                // Add the corresponding ID to removedIds if not already present and previously selected
                                if (!removedIds.contains(ids[index]) && selectedGenres.contains(genre)) {
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
                        child: Text(genre),
                      ),
                    );
                  },
                ),
              ),
              SavebuttonWidget(
                text: 'Save',
                onClicked: () async {
                  await sendCurrGenres();
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
