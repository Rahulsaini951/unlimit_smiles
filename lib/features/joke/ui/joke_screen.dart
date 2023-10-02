import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unlimit_smiles/features/joke/ui/joke_card_widget.dart';
import 'package:unlimit_smiles/utils/constants.dart';
import '../../../utils/strings.dart';
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
      backgroundColor: AppColors.primary_background,
      appBar: AppBar(
        backgroundColor: AppColors.primary_background,
        title: const Text(
          appTitle,
          style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.black),
        ),
      ),
      body: BlocConsumer<JokeBloc, JokeState>(
        bloc: _jokeBloc,
        listenWhen: (previous, current) => current is JokeActionState,
        buildWhen: (previous, current) => current is! JokeActionState,
        builder: (context, state) {
          if (state is JokeLoaded) {
            final jokes = state.jokes.reversed.toList();

            return ListView.builder(
              itemCount: jokes.length,
              itemBuilder: (context, index) {
                return JokeCard(joke: jokes[index]);
              },
            );
          } else if (state is JokeError) {
            return Center(
              child: Text(state.error, style: const TextStyle(fontWeight: FontWeight.normal, color: AppColors.reddish)),
            );
          } else if (state is JokeLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const SizedBox();
          }
        },
        listener: (BuildContext context, JokeState state) {
          if (state is NewJokeAddedActionState) {
            final snackBar = SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'TAdA!! 😆',
                message: 'Hold On Tight, Here Comes a New Joke! 🚀',
                contentType: ContentType.success,
                color: AppColors.surfaceColorLight,
                messageFontSize: AppFontSizes.small,
                titleFontSize: AppFontSizes.large,
              ),
            );
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);
          }

          if (state is FirstJokeAddedActionState) {
            final snackBar = SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'Awesome!!',
                message: 'Congratulations! You\'ve Just Unlocked the First Joke! 🎉',
                color: AppColors.black,
                contentType: ContentType.success,
              ),
            );
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);
          }
        },
      ),
    );
  }
}
