

abstract class JokeRepository {
  Future<void> initialize();
  Future<List<String>> loadJokesFromSharedPreferences();
  Future<void> saveJokesToSharedPreferences(List<String> jokes);
  Future<String> fetchJoke();
}