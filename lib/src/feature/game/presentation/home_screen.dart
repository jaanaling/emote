import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<HomeScreen> {
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
