import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../api/joke_api.dart';
part 'joke_event.dart';
part 'joke_state.dart';


class JokeBloc extends Bloc<JokeEvent, JokeState> {
  final JokeRepository jokeRepository;

  JokeBloc(this.jokeRepository) : super(JokeInitial()) {
    _initializeTimer();

    on<JokeInitialEvent>(jokeInitialEvent);
    on<FetchJokeEvent>(fetchJokeEvent);
  }

  Timer? _timer;

  void _initializeTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      add(FetchJokeEvent());
    });
  }

  Future<void> jokeInitialEvent(JokeInitialEvent event, Emitter<JokeState> emit) async {
    emit(JokeLoadingState());
    emit(await mapEventToState(FetchJokeEvent()));
  }

  Future<void> fetchJokeEvent(FetchJokeEvent event, Emitter<JokeState> emit) async {
    emit(await fetchJokeAndUpdateCache());
  }

  Future<JokeLoaded> fetchJokeAndUpdateCache() async {
    String newJoke = await jokeRepository.fetchJoke();

    if (state is JokeLoaded) {
      print("state is JokeLoaded");
      final List<String> updatedJokes = (state as JokeLoaded).jokes;
      updatedJokes.add(newJoke);
      if (updatedJokes.length > 10) {
        updatedJokes.removeAt(0);
      }

      await jokeRepository.saveJokesToSharedPreferences(updatedJokes);
      return JokeLoaded(updatedJokes);
    } else {
      print("state is not JokeLoaded thus loading the first joke");

      await jokeRepository.saveJokesToSharedPreferences([newJoke]);
      return JokeLoaded([newJoke]);
    }
  }

  Future<JokeState> mapEventToState(JokeEvent event) async {
      print('event in mapEventToState is -> $event');

      try {
        List<String> existingJokes = await jokeRepository.loadJokesFromSharedPreferences();

        if (existingJokes.isNotEmpty) {
          return JokeLoaded(existingJokes);
        } else {
          print('existing jokes are empty');
        }
        return fetchJokeAndUpdateCache();
      } catch (e) {
        return JokeError('Error fetching or loading jokes: $e');
      }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}



// class JokeBloc extends Bloc<JokeEvent, JokeState> {
//   final JokeRepository jokeRepository;
//
//   JokeBloc(this.jokeRepository) : super(JokeInitial()) {
//     _initializeTimer();
//   }
//
//   Timer? _timer;
//
//   void _initializeTimer() {
//     _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
//       add(FetchJokeEvent());
//     });
//   }
//
//   @override
//   Stream<JokeState> mapEventToState(JokeEvent event) async* {
//     if (event is FetchJokeEvent) {
//       yield JokeInitial();
//
//       try {
//         final newJoke = await jokeRepository.fetchJoke();
//
//         if (state is JokeLoaded) {
//           final List<String> updatedJokes = (state as JokeLoaded).jokes;
//           updatedJokes.add(newJoke);
//           if (updatedJokes.length > 10) {
//             updatedJokes.removeAt(0);
//           }
//           yield JokeLoaded(updatedJokes);
//           _saveJokesToSharedPreferences(updatedJokes);
//         } else {
//           yield JokeLoaded([newJoke]);
//           _saveJokesToSharedPreferences([newJoke]);
//         }
//       } catch (e) {
//         yield JokeError('Error fetching joke: $e');
//       }
//     }
//   }
//
//   // Future<void> _saveJokesToSharedPreferences(List<String> jokes) async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   prefs.setStringList('jokes', jokes);
//   // }
//   //
//   // Future<List<String>> _loadJokesFromSharedPreferences() async {
//   //   final prefs = await SharedPreferences.getInstance();
//   //   return prefs.getStringList('jokes') ?? [];
//   // }
//
//   // Future<void> loadJokesFromSharedPreferences() async {
//   //   try {
//   //     final List<String> existingJokes = await jokeRepository.loadJokesFromSharedPreferences();
//   //     if (existingJokes.isNotEmpty) {
//   //       yield JokeLoaded(existingJokes);
//   //     }
//   //   } catch (e) {
//   //     print('Error loading jokes from SharedPreferences: $e');
//   //   }
//   // }
//
//
//   void loadJokes() {
//     add(FetchJokeEvent());
//   }
//
//   @override
//   Future<void> close() {
//     _timer?.cancel();
//     return super.close();
//   }
// }
