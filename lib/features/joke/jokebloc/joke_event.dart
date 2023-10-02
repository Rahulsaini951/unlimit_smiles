part of 'joke_bloc.dart';

abstract class JokeEvent {}

class JokeInitialEvent extends JokeEvent {}

class FetchJokeEvent extends JokeEvent {}
