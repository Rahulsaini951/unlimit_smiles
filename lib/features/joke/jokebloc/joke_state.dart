part of 'joke_bloc.dart';

// abstract class JokeState extends Equatable {
//   const JokeState();
// }
//
// class JokeInitial extends JokeState {
//   @override
//   List<Object> get props => [];
// }

abstract class JokeState {}

abstract class JokeActionState extends JokeState {}

class JokeInitial extends JokeState {}

class JokeLoadingState extends JokeState {}

class JokeLoaded extends JokeState {
  final List<String> jokes;

  JokeLoaded(this.jokes);
}

class JokeError extends JokeState {
  final String error;

  JokeError(this.error);
}

class NewJokeAddedActionState extends JokeActionState {}

class FirstJokeAddedActionState extends JokeActionState {}
