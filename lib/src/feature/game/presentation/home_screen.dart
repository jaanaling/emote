import 'package:emote_this/src/feature/game/bloc/game_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PuzzleScreen extends StatefulWidget {
  final String puzzleId;
  const PuzzleScreen({Key? key, required this.puzzleId}) : super(key: key);

  @override
  State<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> {
  final TextEditingController _textController = TextEditingController();
  List<int> selectedNumbers = [];
  int chosenValue = 0;
  Map<String, String> userMatches = {};
  int mathAnswer = 0;
  String anagramSolution = '';
  String cipherGuess = '';

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
