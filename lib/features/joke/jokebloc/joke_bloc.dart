import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../repository/joke_repository.dart';

part 'joke_event.dart';

part 'joke_state.dart';

class JokeBloc extends Bloc<JokeEvent, JokeState> {
  final JokeRepository jokeRepository;

  JokeBloc(this.jokeRepository) : super(JokeInitial()) {
    _initializeTimer();

    on<JokeInitialEvent>(jokeInitialEvent);
    on<FetchJokeEvent>(fetchJokeEvent);
  }

  Timer? timer;

  void _initializeTimer() {
    timer = Timer.periodic(const Duration(minutes: 1), (timer) {

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
    timer?.cancel();
    return super.close();
  }
}
