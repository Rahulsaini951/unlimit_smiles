import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../jokebloc/joke_bloc.dart';


class JokeScreen extends StatefulWidget {
  const JokeScreen({Key? key}) : super(key: key);

  @override
  State<JokeScreen> createState() => _JokeScreenState();
}

class _JokeScreenState extends State<JokeScreen> {
  late JokeBloc _jokeBloc;

  @override
  void initState() {
    super.initState();
    _jokeBloc = BlocProvider.of<JokeBloc>(context);
    _jokeBloc.add(JokeInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Joke App'),
      ),
      body: BlocConsumer<JokeBloc, JokeState>(
        bloc: _jokeBloc,
        listenWhen: (previous, current) => current is JokeActionState,
        buildWhen: (previous, current) => current is !JokeActionState,

        builder: (context, state) {
          if (state is JokeLoaded) {
            final jokes = state.jokes;

            return ListView.builder(
              itemCount: jokes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(jokes[index]),
                );
              },
            );
          } else if (state is JokeError) {
            return Center(
              child: Text(state.error),
            );
          } else if (state is JokeLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          else {
            return const SizedBox();
          }
        },

        listener: (BuildContext context, JokeState state) {
          if(state is NewJokeAddedActionState) {
            print('got a jokeState'); // will show snackBar here
          }
        },
      ),
    );
  }
}