import 'package:emote_this/src/feature/game/bloc/game_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class QuizScreen extends StatefulWidget {
  final int puzzleId;

  const QuizScreen({super.key, required this.puzzleId});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<String?> userInput = [];
  List<bool> showColors = [];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        if (state is GameLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is GameError) {
          return Scaffold(body: Center(child: Text(state.message)));
        }

        if (state is GameLoaded) {
          final answer = state.riddles
              .firstWhere((puzzle) => puzzle.id == widget.puzzleId)
              .answer
              .split('');
          final answerLength = answer.length;

          userInput =
              userInput.isEmpty ? List.filled(answerLength, null) : userInput;
          showColors = showColors.isEmpty
              ? List.filled(answerLength, false)
              : showColors;

          return Focus(
            autofocus: true,
            onKey: (FocusNode node, RawKeyEvent event) {
              if (event is RawKeyDownEvent) {
                handleKeyInput(event.logicalKey, answerLength, answer);
              }
              return KeyEventResult.handled;
            },
            child: Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAnswerCells(answer, answerLength),
                  const SizedBox(height: 20),
                  _buildKeyboard(answerLength, answer),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildAnswerCells(List<String> answer, int answerLength) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(answerLength, (index) {
        Color color;
        if (!showColors[index]) {
          // Серый до подтверждения
          color = Colors.grey;
        } else {
          // После подтверждения устанавливаем цвет в зависимости от правильности
          color =
              (userInput[index] == answer[index]) ? Colors.green : Colors.red;
        }
        return Container(
          margin: const EdgeInsets.all(5),
          width: 50,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              userInput[index] ?? '',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildKeyboard(int answerLength, List<String> answer) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: keyboardRows.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.map((letter) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: ElevatedButton(
                onPressed: () =>
                    handleLetterInput(letter, answerLength, answer),
                child: Text(
                  letter,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  void handleLetterInput(String letter, int answerLength, List<String> answer) {
    setState(() {
      if (letter == '⌫') {
        // Удаление символа
        if (currentIndex > 0) {
          // Предварительно смотрим на предыдущий индекс
          int eraseIndex = currentIndex - 1;

          if (showColors[eraseIndex]) {
            // Ячейка окрашена после подтверждения
            // Проверяем правильная ли (зелёная) или нет (красная)
            bool isGreen = (userInput[eraseIndex] == answer[eraseIndex]);

            if (isGreen) {
              currentIndex = eraseIndex;
              return;
            } else {
              // Красная ячейка - стираем символ и сбрасываем цвет в серый (showColors = false)
              userInput[eraseIndex] = null;
              showColors[eraseIndex] = false;
              currentIndex = eraseIndex;
            }
          } else {
            // Ячейка не окрашена (серая/пустая) - просто стираем
            userInput[eraseIndex] = null;
            currentIndex = eraseIndex;
          }
        }
      } else if (letter == 'CONFIRM') {
        // Отобразить цвета после подтверждения (только если все заполнены)
        if (userInput.every((char) => char != null)) {
          showColors = List.generate(userInput.length, (i) => true);

          // Проверка результата
          bool isCorrect =
              List.generate(answerLength, (i) => userInput[i] == answer[i])
                  .every((val) => val);
          context
              .read<GameBloc>()
              .add(SubmitRiddleAnswer(widget.puzzleId, userInput.join()));
          if (isCorrect) {
            showResult(isCorrect);
          }
          if (!isCorrect && (context.read<GameBloc>().currentAttempts == 3)) {
            showResult(isCorrect);
          }
        }
      } else if (currentIndex < userInput.length) {
      
        userInput[currentIndex] = letter;
        
        currentIndex++;
      }
    });
  }

  void handleKeyInput(
      LogicalKeyboardKey key, int answerLength, List<String> answer) {
    final keyLabel = key.keyLabel.toUpperCase();
    if (keyLabel == 'BACKSPACE') {
      handleLetterInput('⌫', answerLength, answer);
    } else if (keyLabel == ' ') {
      handleLetterInput(' ', answerLength, answer);
    } else if (keyLabel.length == 1 && keyLabel.contains(RegExp(r'[A-Z]'))) {
      handleLetterInput(keyLabel, answerLength, answer);
    }
  }

  void showResult(bool isCorrect) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(isCorrect ? 'You Win!' : 'Try Again!'),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
              setState(() {
                userInput = List.filled(userInput.length, null);
                showColors = List.filled(userInput.length, false);
                currentIndex = 0;
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  final List<List<String>> keyboardRows = [
    ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
    ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
    ['Z', 'X', 'C', 'V', 'B', 'N', 'M', ' '],
    ['⌫', 'CONFIRM'],
  ];
}
