import 'package:bandaid/utils/api_endpoints.dart';

class User {
  final int id;
  final String imagePath;
  final String address;
  final String name;
  final String title;
  final String preference;
  final String email;
  final String about;
  final bool isDarkMode;
  List<String> genres = [];
  List<String> instruments = [];
  List<dynamic> followers = [];
  List<dynamic> following = [];

  User({
    required this.id,
    this.imagePath = ProfilePictureEndpoints.getUserProfilePicture,
    this.address = "",
    required this.name,
    this.title = "",
    this.preference = "",
    this.email = "",
    this.about = "",
    this.isDarkMode = false,
  });

  String getName() {
    return name;
  }

  String getImage() {
    return getServerApiUrl(this.imagePath +
        "/" +
        this.id.toString() +
        "?random=${DateTime.now().millisecondsSinceEpoch}");
  }

  String getImageStatic() {
    return getServerApiUrl(this.imagePath + "/" + this.id.toString());
  }

  void printUser() {
    print(
        "First name: $name User Id: $id Instruments: $instruments Genres $genres Followers $followers Following $following ");
  }

  List<String> getInstruments() {
    return instruments;
  }

  List<String> getGenres() {
    return genres;
  }

  String getEmail() {
    return email;
  }
}
