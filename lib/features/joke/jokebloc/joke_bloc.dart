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
      final List<String> updatedJokes = (state as JokeLoaded).jokes;
      updatedJokes.add(newJoke);
      emit(NewJokeAddedActionState());
      if (updatedJokes.length > 10) {
        updatedJokes.removeAt(0);
      }

      await jokeRepository.saveJokesToSharedPreferences(updatedJokes);
      return JokeLoaded(updatedJokes);
    } else {
      await jokeRepository.saveJokesToSharedPreferences([newJoke]);
      emit(FirstJokeAddedActionState());
      return JokeLoaded([newJoke]);
    }
  }

  Future<JokeState> mapEventToState(JokeEvent event) async {

      try {
        List<String> existingJokes = await jokeRepository.loadJokesFromSharedPreferences();

        if (existingJokes.isNotEmpty) {
          return JokeLoaded(existingJokes);
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

