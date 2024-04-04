import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:bandaid/model/user.dart';
import 'package:bandaid/utils/helper_functions.dart';
import 'package:bandaid/utils/user_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_audio_cutter/audio_cutter.dart';
import 'package:http/http.dart' as http;
import 'package:bandaid/utils/api_endpoints.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:heif_converter/heif_converter.dart';

Future<List<User>> getAllUsersGenres(List<User> userlist) async {
  Map<int, Iterable<dynamic>> usersGenres = {};

  var url = Uri.parse(getServerApiUrl(InfoRouterEndPoints.getUsersGenres));
  var httpHeader = {'Content-Type': 'application/json'};

  try {
    http.Response response = await http.get(url, headers: httpHeader);

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body)["data"];
      for (Map<String, dynamic> item in body) {
        usersGenres[item["user_id"]] = item["genres"];
      }

      for (User user in userlist) {
        user.genres = List.from(usersGenres[user.id] ?? []);
      }
      return userlist;
    } else {
      return userlist;
    }
  } catch (e) {
    // Handle exceptions
    print("Error fetching all users genres: $e");
    return userlist;
  }
}

Future<List<User>> getAllUsersInstruments(List<User> userlist) async {
  Map<int, Iterable<dynamic>> usersInstruments = {};

  var url = Uri.parse(getServerApiUrl(InfoRouterEndPoints.getUsersInstruments));
  var httpHeader = {'Content-Type': 'application/json'};

  try {
    http.Response response = await http.get(url, headers: httpHeader);

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body)["data"];
      for (Map<String, dynamic> item in body) {
        usersInstruments[item["user_id"]] = item["instruments"];
      }

      for (User user in userlist) {
        user.instruments = List.from(usersInstruments[user.id] ?? []);
      }
      return userlist;
    } else {
      return userlist;
    }
  } catch (e) {
    // Handle exceptions
    print("Error fetching all users instruments: $e");
    return userlist;
  }
}

Future<User> getCurrentUserDetails(context) async {
  var url =
      Uri.parse(getServerApiUrl(UserRouterEndPoints.getCurrentUserDetails));
  var httpHeader = await buildHTTPHeader();

  try {
    http.Response response = await http.get(url, headers: httpHeader);

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body)["data"]["payload"];
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt("id", body["id"]);
      var user = User(
        id: body['user_id'],
        name: body['first_name'] + ' ' + body['last_name'],
        title: body['title'],
        about: body['description'],
        address: body['address'],
        preference: body['preference'],
      );
      user.followers = body['followers'];
      user.following = body['following'];
      return user;
    } else {
      logout(context);
      return User(id: -1, name: 'error', email: '');
    }
  } catch (e) {
    // Handle exceptions
    print("Error fetching current user details: $e");
    return User(id: -1, name: 'error', email: '');
  }
}

Future<List<User>> getAllUserDetails() async {
  var url = Uri.parse(getServerApiUrl(UserRouterEndPoints.getAllUserDetails));
  var httpHeader = {'Content-Type': 'application/json'};

  try {
    http.Response response = await http.get(url, headers: httpHeader);
    List<User> userlist = [];

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body)["data"];

      for (var userBody in body) {
        var user = User(
          id: userBody["user_id"],
          name: userBody['first_name'] + ' ' + userBody['last_name'],
          title: userBody['title'],
          about: userBody['description'],
          address: userBody['address'],
          preference: userBody['preference'],
        );
        user.followers = userBody['followers'];
        user.following = userBody['following'];
        userlist.add(user);
      }

      return userlist;
    } else {
      return userlist;
    }
  } catch (e) {
    // Handle exceptions
    print("Error fetching all user details: $e");
    return [];
  }
}

Future<User> getUserDetails(user_id) async {
  try {
    final users = await getAllUserDetails();
    await getAllUsersGenres(users);
    await getAllUsersInstruments(users);
    User user = users.where((user) => user.id == user_id).first;
    return user;
  } catch (e) {
    throw Exception("Error fetching all user details: $e");
  }
}

Future<List<String>> getCurrentUserItems(String item) async {
  var endpoint = "/";

  switch (item) {
    case "instruments":
      endpoint = UserRouterEndPoints.getUserInstruments;
      break;
    case "genres":
      endpoint = UserRouterEndPoints.getUserGenre;
      break;
  }

  var url = Uri.parse(getServerApiUrl(endpoint));
  var httpHeader = await buildHTTPHeader();

  try {
    http.Response response = await http.get(url, headers: httpHeader);

    if (response.statusCode == 201) {
      var body = jsonDecode(response.body)["data"]["payload"];
      return getNames(body);
    } else {
      return [""];
    }
  } catch (e) {
    // Handle exceptions
    print("Error fetching current user items: $e");
    return [""];
  }
}

Future<void> postUserDetails(String field, String data) async {
  try {
    var url = Uri.parse(
        getServerApiUrl(UserRouterEndPoints.updateCurrentUserDetails));
    var httpHeader = await buildHTTPHeader();
    var body = <String, String>{
      "field": field,
      "data": data,
    };
    http.Response response =
        await http.put(url, headers: httpHeader, body: jsonEncode(body));
    if (response.statusCode == 200) {
    } else {
      throw Exception('Unable to add $field. Response body: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

Future<List<String>> getData(String field) async {
  try {
    String endpoint;

    // Use a switch statement for better readability
    switch (field) {
      case "instruments":
        endpoint = InfoRouterEndPoints.getInstruments;
        break;
      case "genres":
        endpoint = InfoRouterEndPoints.getGenres;
        break;
      default:
        throw Exception('Invalid field: $field');
    }

    final url = Uri.parse(getServerApiUrl(endpoint));
    final httpHeader = await buildHTTPHeader();

    final http.Response response = await http.get(url, headers: httpHeader);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List<String> data = convertToList(body["data"]);
      return data;
    } else {
      // Handle the response error, e.g., log it or throw an exception
      throw Exception('Failed to load $field. Response body: ${response.body}');
    }
  } catch (e) {
    // Handle exceptions such as network errors
    throw Exception('Error: $e');
  }
}

Future<void> createUserDetails(String firstname, String lastname, String title,
    String description, String preference, String address) async {
  try {
    var url = Uri.parse(
        getServerApiUrl(UserRouterEndPoints.updateCurrentUserDetails));
    var httpHeader = await buildHTTPHeader();
    var body = <String, dynamic>{
      "first_name": firstname,
      "last_name": lastname,
      "title": title,
      "description": description,
      "preference": preference,
      "address": address,
      "followers": [],
      "following": [],
    };
    http.Response response =
        await http.post(url, headers: httpHeader, body: jsonEncode(body));
    if (response.statusCode == 201) {
    } else {
      throw Exception(
          'Unable to create user personal details. Response body: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

Future<void> postItemsList(List<bool> selectedItems, String field) async {
  try {
    String endpoint;

    switch (field) {
      case "instruments":
        endpoint = UserRouterEndPoints.postUserInstruments;
        break;
      case "genres":
        endpoint = UserRouterEndPoints.postUserGenre;
        break;
      default:
        throw Exception('Invalid field: $field');
    }

    var url = Uri.parse(getServerApiUrl(endpoint));
    var httpHeader = await buildHTTPHeader();
    List<int> idlist = convertToID(selectedItems);
    Map<String, dynamic> body = {"id": idlist};
    http.Response response =
        await http.post(url, headers: httpHeader, body: jsonEncode(body));
    if (response.statusCode == 201) {
    } else {
      throw Exception('Unable to add $field. Response body: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

Future<bool> firstTimeUserMode(context) async {
  var url =
      Uri.parse(getServerApiUrl(UserRouterEndPoints.getCurrentUserDetails));
  var httpHeader = await buildHTTPHeader();
  http.Response response = await http.get(url, headers: httpHeader);

  if (response.statusCode == 200) {
    var body = jsonDecode(response.body)["data"]["payload"];
    if (body["first_name"] == null) {
      return false;
    }
    return true;
  } else {
    return false;
  }
}

Future<void> follow(int other_user_id) async {
  try {
    var parameters = {"other_user_id": other_user_id.toString()};
    var url = Uri.http(serverUrl, UserRouterEndPoints.followUser, parameters);
    var httpHeader = await buildHTTPHeader();
    http.Response response = await http.put(url, headers: httpHeader);
    if (response.statusCode == 200) {
    } else {
      throw Exception(
          'Unable to follower user. Response body: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

Future<void> unfollow(int other_user_id) async {
  try {
    var parameters = {"other_user_id": other_user_id.toString()};
    var url = Uri.http(serverUrl, UserRouterEndPoints.unfollowUser, parameters);
    var httpHeader = await buildHTTPHeader();
    http.Response response = await http.put(url, headers: httpHeader);
    if (response.statusCode == 200) {
    } else {
      throw Exception(
          'Unable to follower user. Response body: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

Future<void> uploadImage() async {
  final dio = Dio();
  XFile? image = await ImagePicker().pickImage(
    source: ImageSource.gallery,
  );
  if (image == null) {
    return;
  }

  String? ios_path;
  if (image.path.toLowerCase().endsWith('.heic') ||
      image.path.toLowerCase().endsWith('.heif')) {
    ios_path = await HeifConverter.convert(image.path, format: 'png');
  }

  final url = getServerApiUrl(ProfilePictureEndpoints.uploadProfilePicture);
  final formData = FormData.fromMap({
    'file':
        await MultipartFile.fromFile(ios_path == null ? image.path : ios_path),
  });
  final auth_token = await readAuthToken();
  dio.options.headers['Authorization'] = "Bearer $auth_token";
  try {
    var response = await dio.post(url, data: formData);
    if (response.statusCode == 200) {
      print('File uploaded successfully');
    } else {
      throw Exception(
          'Failed to upload file. Status code: ${await response.statusCode}');
    }
  } catch (e) {
    throw Exception("Error ${e}");
  }
}

Future<void> uploadSound() async {
  try {
    final dio = Dio();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio, // Restrict to audio files
    );

    if (result != null) {
      PlatformFile file = result.files.single;

      // Check if the selected file is an MP3 file
      if (file.extension != 'mp3') {
        throw Exception("Selected file is not an MP3 file");
      }

      final url = getServerApiUrl(SoundEndpoints.uploadUserSound);

      var file_path = await AudioCutter.cutAudio(file.path.toString(), 0, 15);

      // Upload the cropped audio file
      final formData =
          FormData.fromMap({'file': await MultipartFile.fromFile(file_path, contentType: MediaType('audio', 'mpeg'))});

      final auth_token = await readAuthToken();
      dio.options.headers['Authorization'] = "Bearer $auth_token";
      var response = await dio.post(url, data: formData);
      if (response.statusCode == 200) {
        print('Sound uploaded successfully');
      } else {
        throw Exception(
            'Failed to upload Sound. Status code: ${await response.statusCode}');
      }
    } else {
      throw Exception("File was not picked");
    }
  } catch (e) {
    throw Exception("Error: $e");
  }
}

Future<dynamic> getUserSound(int user_id) async {
  try {
    final parameters = {"user_id": user_id.toString()};
    final url =
        Uri.http(serverUrl, SoundEndpoints.getUserSound(user_id), parameters);
    var httpHeader = await buildHTTPHeader();
    http.Response response = await http.get(url, headers: httpHeader);
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Unable to fetch sound: ${response.body}');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}
