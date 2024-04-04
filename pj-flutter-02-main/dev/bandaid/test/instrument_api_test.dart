import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

class InstrumentApi {
  Future<List<Map<String, dynamic>>> getAllInstruments() async {
    final response = await http.get(
      Uri.parse('http://ec2-54-234-100-83.compute-1.amazonaws.com/api/instruments/all'),
      headers: {'accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load instruments');
    }
  }
}

void main() {
  test('fetches instruments successfully', () async {
    final api = InstrumentApi();
    final instruments = await api.getAllInstruments();

    // Verify that the function returned a non-empty list
    expect(instruments, isNotEmpty);

    // Define the expected list
    final expectedInstruments = [
      {"id": 1, "name": "Guitar"},
      {"id": 2, "name": "Cello"},
      {"id": 3, "name": "Banjo"},
      {"id": 4, "name": "Bass"},
      {"id": 5, "name": "Harp"},
      {"id": 6, "name": "Saxophone"},
      {"id": 7, "name": "Clarinet"},
      {"id": 8, "name": "Electric Keyboard"},
      {"id": 9, "name": "Glass Harmonica"},
      {"id": 10, "name": "Accordion"},
      {"id": 11, "name": "Piano"},
      {"id": 12, "name": "Drum"},
      {"id": 13, "name": "Tube"},
    ];

    // Verify that the actual list matches the expected list
    expect(instruments, equals(expectedInstruments));
  });
}