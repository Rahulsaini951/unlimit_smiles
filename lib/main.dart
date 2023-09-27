import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/joke/api/joke_api.dart';
import 'features/joke/api/joke_api_impl.dart';
import 'features/joke/jokebloc/joke_bloc.dart';
import 'features/joke/ui/joke_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final jokeRepository = JokeApiImpl(); // Use the implementation class
  await jokeRepository.initialize(); // Initialize any required resources
  runApp(MyApp(jokeRepository));
}

class MyApp extends StatelessWidget {
  final JokeRepository jokeRepository;
  const MyApp(this.jokeRepository, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => JokeBloc(jokeRepository),
        child: const JokeScreen(),
      ),
    );
  }
}
