import 'package:bandaid/utils/user_preferences.dart';

// Define all API constants and routers
const String base = 'http://';
const String serverUrl = 'ec2-54-234-100-83.compute-1.amazonaws.com';
const String serverBaseUrl = 'http://ec2-54-234-100-83.compute-1.amazonaws.com';

class AuthRouterEndPoints {
  static const String login = 'token';
  static const String register = 'signup';
  static const String google_oauth = 'google_oauth';
}

class UserRouterEndPoints {
  static const String getCurrentUser = 'api/users/me';
  static const String getCurrentUserDetails = 'api/users/details/me';
  static const String getAllUserDetails = 'api/users/details/all';
  static const String postUserInstruments = 'api/instruments/me';
  static const String postUserGenre = 'api/genres/me';
  static const String getUserInstruments = 'api/instruments/me';
  static const String getUserGenre = 'api/genres/me';
  static const String updateCurrentUserDetails = 'api/users/details/me';
  static const String followUser = 'api/users/follow';
  static const String unfollowUser = 'api/users/unfollow';
}

class ProfilePictureEndpoints {
  static const String uploadProfilePicture = 'api/files/upload';
  static const String getUserProfilePicture = 'api/files/profile';
}

class SoundEndpoints {
  static const String uploadUserSound = 'api/files/upload_audio';
  static String getUserSound(int user_id) {
    return 'api/files/audio/${user_id}';
  }
}

class InfoRouterEndPoints {
  static const String getGenres = 'api/genres/all';
  static const String getInstruments = 'api/instruments/all';
  static const String getUsers = 'api/users/all';
  static const String getUsersGenres = 'api/users/all/genres';
  static const String getUsersInstruments = 'api/users/all/instruments';
}

class ChatRouterEndPoints {
  static String getAllMessage(int user_id) {
    return 'api/chats/${user_id}';
  }

  static String getCurrentUserDms(int correspondent_id) {
    return 'api/chats/me/${correspondent_id}';
  }

  static const String createMessage = 'api/chats';
}

// Build server API URL
String getServerApiUrl(String path) {
  return '$serverBaseUrl/$path';
}

// Build HTTP header to include auth token
Future<Map<String, String>> buildHTTPHeader() async {
  var authToken = await readAuthToken();
  if (authToken.isEmpty) {
    return {};
  }

  return {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $authToken',
  };
}
