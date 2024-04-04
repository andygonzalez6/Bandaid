import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

class GenreApi {
  Future<List<Map<String, dynamic>>> getAllGenres() async {
    final response = await http.get(
      Uri.parse('http://ec2-54-234-100-83.compute-1.amazonaws.com/api/genres/all'),
      headers: {'accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load genres');
    }
  }
}

void main() {
  test('fetches genres successfully', () async {
    final api = GenreApi();
    final genres = await api.getAllGenres();

    // Verify that the function returned a non-empty list
    expect(genres, isNotEmpty);

    // Define the expected list
    final expectedGenres = [
      {"id": 1, "name": "Classical"},
      {"id": 2, "name": "Hip Hop"},
      {"id": 3, "name": "Rock"},
      {"id": 4, "name": "Jazz"},
      {"id": 5, "name": "Indie"},
      {"id": 6, "name": "Metal"},
      {"id": 7, "name": "Pop"},
      {"id": 8, "name": "Electronic"},
      {"id": 9, "name": "Blues"},
      {"id": 10, "name": "Rap"},
      {"id": 11, "name": "Punk"},
      {"id": 12, "name": "Folk"},
      {"id": 13, "name": "World Music"},
      {"id": 14, "name": "Gospel"},
      {"id": 15, "name": "R&B"},
    ];

    // Verify that the actual list matches the expected list
    expect(genres, equals(expectedGenres));
  });
}