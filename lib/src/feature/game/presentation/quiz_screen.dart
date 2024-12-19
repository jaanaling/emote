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

  final List<List<String>> keyboardRows = [
    ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
    ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
    ['Z', 'X', 'C', 'V', 'B', 'N', 'M', '⌫'],
    ['HINT', 'CONFIRM'],
  ];

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
          final riddle = state.riddles
              .firstWhere((puzzle) => puzzle.id == widget.puzzleId);
          final answerStr = riddle.answer;
          final answer = answerStr.split('');
          final answerLength = answer.length;

          // Разбиваем ответ на слова
          final words = answerStr.split(' ');

          userInput = userInput.isEmpty
              ? List.filled(answerLength, null)
              : userInput;
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
              body: LayoutBuilder(
                builder: (context, constraints) {
                  final screenWidth = constraints.maxWidth;
                  final screenHeight = constraints.maxHeight;

                  final cellWidth = screenWidth * 0.12;
                  final cellHeight = cellWidth * 1.5;

                  int maxRowLength = keyboardRows
                      .map((row) => row.length)
                      .reduce((a, b) => a > b ? a : b);

                  final keyWidth = (screenWidth - (maxRowLength * 4.0)) /
                      (maxRowLength + 0.5);
                  final keyHeight = keyWidth * 1.4;

                  return Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            riddle.emojis,
                            style: const TextStyle(fontSize: 60),
                          ),
                          SizedBox(height: screenHeight * 0.05),
                          _buildAnswerLines(words, answer, cellWidth, cellHeight),
                          SizedBox(height: screenHeight * 0.02),
                          _buildKeyboard(answerLength, answer, keyWidth, keyHeight),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  /// Отображаем ответ построчно по словам, пропуская пробелы в answer.
  Widget _buildAnswerLines(
      List<String> words, List<String> answer, double cellWidth, double cellHeight) {
    List<Widget> lines = [];
    int charIndex = 0;

    for (int w = 0; w < words.length; w++) {
      var word = words[w];
      final wordLength = word.length;
      // Ячейки одного слова
      final cells = List.generate(wordLength, (i) {
        int index = charIndex + i;
        Color color;
        if (!showColors[index]) {
          color = Colors.grey;
        } else {
          bool isGreen = (userInput[index]?.toLowerCase() ==
              answer[index].toLowerCase());
          color = isGreen ? Colors.green : Colors.red;
        }

        return Container(
          width: cellWidth,
          height: cellHeight,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              userInput[index] ?? '',
              style: TextStyle(
                fontSize: cellWidth * 0.6,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      });

      lines.add(Wrap(
        alignment: WrapAlignment.center,
        spacing: 10,
        runSpacing: 10,
        children: cells,
      ));

      // Переходим к следующему слову
      charIndex += wordLength;

      // Если не последнее слово - пропускаем пробел
      if (w < words.length - 1) {
        // В answer после слова должен быть пробел
        // Пропускаем его
        if (charIndex < answer.length && answer[charIndex] == ' ') {
          charIndex++;
        }
        // Добавляем вертикальный отступ между словами
        lines.add(SizedBox(height: cellHeight * 0.5));
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: lines,
    );
  }

  Widget _buildKeyboard(int answerLength, List<String> answer, double keyWidth,
      double keyHeight) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: keyboardRows.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.map((letter) {
            bool isWideButton = (letter == 'CONFIRM' || letter == 'HINT');

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0),
              child: SizedBox(
                width: isWideButton ? keyWidth * 4 : keyWidth,
                height: keyHeight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () => handleLetterInput(letter, answerLength, answer),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      letter,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  void revealHint(List<String> answer) {
    // Найдём первую ячейку, которая не зелёная (неправильная или пустая)
    for (int i = 0; i < answer.length; i++) {
      if (answer[i] == ' ') continue;
      bool isGreen = showColors[i] &&
          userInput[i]?.toLowerCase() == answer[i].toLowerCase();
      if (!isGreen) {
        // Ставим правильный символ
        userInput[i] = answer[i].toUpperCase();
        // Делаем сразу зелёной
        showColors[i] = true;
        setState(() {});
        break;
      }
    }
  }

  void handleLetterInput(String letter, int answerLength, List<String> answer) {
    setState(() {
      if (letter == 'HINT') {
        revealHint(answer);
        return;
      }

      if (letter == '⌫') {
        handleBackspace(answer);
      } else if (letter == 'CONFIRM') {
        handleConfirm(answerLength, answer);
      } else {
        handleCharacterInput(letter, answer);
      }
    });
  }

  void handleBackspace(List<String> answer) {
    if (currentIndex > 0) {
      int eraseIndex = currentIndex - 1;
      // Ищем ячейку для стирания, пропуская пробелы и зелёные ячейки
      while (eraseIndex >= 0) {
        if (answer[eraseIndex] == ' ') {
          eraseIndex--;
          continue;
        }
        bool isGreen = showColors[eraseIndex] &&
            userInput[eraseIndex]?.toLowerCase() == answer[eraseIndex].toLowerCase();
        if (isGreen) {
          eraseIndex--;
          continue;
        }
        break;
      }

      if (eraseIndex >= 0 && answer[eraseIndex] != ' ') {
        userInput[eraseIndex] = null;
        showColors[eraseIndex] = false;
        currentIndex = eraseIndex;
      }
    }
  }

  void handleConfirm(int answerLength, List<String> answer) {
    // Проверяем, все ли не-пробельные ячейки заполнены
    bool allFilled = true;
    for (int i = 0; i < answerLength; i++) {
      if (answer[i] == ' ') continue;
      if (userInput[i] == null) {
        allFilled = false;
        break;
      }
    }

    if (allFilled) {
      showColors = List.generate(userInput.length, (i) => true);

      bool isCorrect = true;
      for (int i = 0; i < answerLength; i++) {
        if (answer[i] == ' ') continue;
        if (userInput[i]?.toLowerCase() != answer[i].toLowerCase()) {
          isCorrect = false;
          break;
        }
      }

      context.read<GameBloc>().add(SubmitRiddleAnswer(widget.puzzleId, userInput.join()));
      if (isCorrect) {
        showResult(isCorrect);
      }
      if (!isCorrect && (context.read<GameBloc>().currentAttempts == 3)) {
        showResult(isCorrect);
      }
    }
  }

  void handleCharacterInput(String letter, List<String> answer) {
    moveCurrentIndexForward(answer, currentIndex);

    if (currentIndex < userInput.length && answer[currentIndex] != ' ') {
      bool isGreen = showColors[currentIndex] &&
          userInput[currentIndex]?.toLowerCase() == answer[currentIndex].toLowerCase();
      if (!isGreen) {
        userInput[currentIndex] = letter.toUpperCase();
      }

      int nextIndex = currentIndex + 1;
      moveCurrentIndexForward(answer, nextIndex);
    }
  }

  void moveCurrentIndexForward(List<String> answer, int startIndex) {
    int i = startIndex;
    while (i < userInput.length) {
      if (answer[i] == ' ') {
        i++;
        continue;
      }
      bool isGreen = showColors[i] &&
          userInput[i]?.toLowerCase() == answer[i].toLowerCase();
      if (isGreen) {
        i++;
        continue;
      }
      break;
    }
    currentIndex = (i <= userInput.length) ? i : userInput.length;
  }

  void handleKeyInput(
      LogicalKeyboardKey key, int answerLength, List<String> answer) {
    final keyLabel = key.keyLabel.toUpperCase();
    if (keyLabel == 'BACKSPACE') {
      handleLetterInput('⌫', answerLength, answer);
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
}
