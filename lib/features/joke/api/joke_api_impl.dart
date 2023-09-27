import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'joke_api.dart';

class JokeApiImpl implements JokeRepository {
  static const String apiUrl = 'https://geek-jokes.sameerkumar.website/api?format=json';
  SharedPreferences? _prefs;

  @override
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<List<String>> loadJokesFromSharedPreferences() async {
    try {
      final List<String>? jokes = _prefs?.getStringList('jokes');
      return jokes ?? [];
    } catch (e) {
      throw Exception('Error loading jokes from SharedPreferences: $e');
    }
  }

  @override
  Future<void> saveJokesToSharedPreferences(List<String> jokes) async {
    try {
      await _prefs?.setStringList('jokes', jokes);
    } catch (e) {
      throw Exception('Error saving jokes to SharedPreferences: $e');
    }
  }

  @override
  Future<String> fetchJoke() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['joke'];
      } else {
        throw Exception('Failed to load joke');
      }
    } catch (e) {
      throw Exception('Error fetching joke: $e');
    }
  }
}