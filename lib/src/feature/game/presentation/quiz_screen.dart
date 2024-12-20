import 'package:emote_this/src/core/utils/app_icon.dart';
import 'package:emote_this/src/core/utils/icon_provider.dart';
import 'package:emote_this/src/feature/game/bloc/game_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:haptic_feedback/haptic_feedback.dart';

import '../../../../ui_kit/app_bar.dart';

class QuizScreen extends StatefulWidget {
  final int puzzleId;

  const QuizScreen({super.key, required this.puzzleId});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  List<String?> userInput = [];
  List<bool> showColors = [];
  int currentIndex = 0;

  // Анимация тряски
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  final List<List<String>> keyboardRows = [
    ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
    ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
    ['Z', 'X', 'C', 'V', 'B', 'N', 'M', '⌫'],
    ['HINT', 'CONFIRM'],
  ];

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 10)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_shakeController);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

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
            child: LayoutBuilder(
              builder: (context, constraints) {
                final screenWidth = constraints.maxWidth;
                final screenHeight = constraints.maxHeight;

                final cellWidth = screenWidth * 0.1;
                final cellHeight = cellWidth * 1.5;

                int maxRowLength = keyboardRows
                    .map((row) => row.length)
                    .reduce((a, b) => a > b ? a : b);

                final keyWidth =
                    (screenWidth - (maxRowLength * 4.0)) / (maxRowLength + 0.5);
                final keyHeight = keyWidth * 1.4;

                return Stack(
                  children: [
                    SafeArea(
                      bottom: false,
                      child: Center(
                        child: Column(
                          children: [
                            const Gap(73),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 128,
                                    width: double.infinity,
                                    decoration: ShapeDecoration(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            width: 1, color: Color(0xFFFF489F)),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        riddle.emojis,
                                        style: const TextStyle(fontSize: 60),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 10,
                                    top: 5,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AppIcon(
                                          asset: IconProvider.heart
                                              .buildImageUrl(),
                                          width: 22.17,
                                          height: 22.17,
                                        ),
                                        Container(
                                          width: 35,
                                          decoration: ShapeDecoration(
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                  width: 1,
                                                  color: Color(0xFFE2E2E2)),
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              context
                                                  .read<GameBloc>()
                                                  .currentAttempts
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10,
                                                fontFamily: 'Baloo Bhaijaan',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.05),
                            AnimatedBuilder(
                              animation: _shakeController,
                              builder: (context, child) {
                                return Transform.translate(
                                  offset: Offset(
                                    _shakeAnimation.value *
                                        (_shakeController.isAnimating ? 1 : 0),
                                    0,
                                  ),
                                  child: child,
                                );
                              },
                              child: _buildAnswerLines(
                                  words, answer, cellWidth, cellHeight),
                            ),
                            const Spacer(),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                color: Color(0xFFd1d5d8),
                              ),
                              child: SafeArea(
                                top: false,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: _buildKeyboard(answerLength, answer,
                                      keyWidth, keyHeight, state.user!.hints),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    AppBarWidget(
                      tipsCount: state.user!.hints,
                      coinsCount: state.user!.coins,
                      title: 'Level ${state.user!.currentLevel}',
                      hasBackButton: true,
                    )
                  ],
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  /// Отображаем ответ построчно по словам, пропуская пробелы в answer.
  Widget _buildAnswerLines(List<String> words, List<String> answer,
      double cellWidth, double cellHeight) {
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
          color = const Color(0xFFC4C4C4);
        } else {
          bool isGreen =
              (userInput[index]?.toLowerCase() == answer[index].toLowerCase());
          color = isGreen ? const Color(0xFFB3FFA6) : const Color(0xFFFFA6A6);
        }

        return Container(
          width: cellWidth,
          height: cellHeight,
          decoration: ShapeDecoration(
            color: color,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFFFF489F)),
              borderRadius: BorderRadius.circular(5),
            ),
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
      double keyHeight, int hintsCount) {
    bool allFilled = true;
    for (int i = 0; i < answerLength; i++) {
      if (answer[i] == ' ') continue;
      if (userInput[i] == null) {
        allFilled = false;
        break;
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: keyboardRows.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.map((letter) {
            bool isWideButton = (letter == 'CONFIRM' || letter == 'HINT');

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0),
              child: SizedBox(
                width: isWideButton ? keyWidth * 4 : keyWidth,
                height: keyHeight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: ((letter == 'CONFIRM' && !allFilled) ||
                          (letter == 'HINT' && hintsCount == 0))
                      ? null
                      : () => handleLetterInput(letter, answerLength, answer),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      letter,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
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
        context.read<GameBloc>().add(UseHint());
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
            userInput[eraseIndex]?.toLowerCase() ==
                answer[eraseIndex].toLowerCase();
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

  Future<void> handleConfirm(int answerLength, List<String> answer) async {
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

      if (!isCorrect) {
        _shakeController.reset();
        _shakeController.forward();
        final canVibrate = await Haptics.canVibrate();
        if (canVibrate) {
          await Haptics.vibrate(HapticsType.error);
        }
        final attempt = context.read<GameBloc>().currentAttempts + 1;
        if (attempt >= 3) {
          showResult(isCorrect, answer.join());
        }
        context.read<GameBloc>().add(SubmitRiddleAnswer(
            widget.puzzleId, userInput.map((e) => e ?? "").toList()));
        return;
      }
      context.read<GameBloc>().add(SubmitRiddleAnswer(
          widget.puzzleId, userInput.map((e) => e ?? "").toList()));
      showResult(isCorrect, answer.join());
    }
  }

  void handleCharacterInput(String letter, List<String> answer) {
    moveCurrentIndexForward(answer, currentIndex);

    if (currentIndex < userInput.length && answer[currentIndex] != ' ') {
      bool isGreen = showColors[currentIndex] &&
          userInput[currentIndex]?.toLowerCase() ==
              answer[currentIndex].toLowerCase();
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

  void showResult(bool isCorrect, String answer) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          backgroundColor: isCorrect ? Color(0xFF002904) : Color(0xFF530005),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(38),
          ),
          content: Padding(
            padding: const EdgeInsets.only(bottom: 3, right: 3),
            child: Container(
              decoration: BoxDecoration(
                color: isCorrect ? Color(0xFF47BB34) : Color(0xFFFF4853),
                borderRadius: BorderRadius.circular(35),
                border: Border.all(
                    color: isCorrect ? Color(0xFF005913) : Color(0xFFC00000),
                    width: 5),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Gap(11),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(35),
                          onTap: () {
                            context
                              ..pop()
                              ..pop();
                          },
                          child: Ink(
                            width: 29,
                            height: 29,
                            decoration: const ShapeDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFe5e5e5), Colors.white],
                              ),
                              shape: OvalBorder(),
                            ),
                            child: Center(
                              child: Ink(
                                width: 21,
                                height: 29,
                                decoration: const ShapeDecoration(
                                  shape: OvalBorder(),
                                  color: Colors.white,
                                ),
                                child: const Center(
                                  child: AppIcon(
                                    asset: 'assets/images/close.svg',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    isCorrect ? "YOU WIN!" : 'YOU LOSE!',
                    style: TextStyle(
                      color: Color(0xFFF7D931),
                      fontSize: 36,
                      fontFamily: 'Baloo Bhaijaan',
                    ),
                  ),
                  if (isCorrect)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 13),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Word: $answer',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Baloo Bhaijaan',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            'Your reward:',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFF7D931),
                              fontSize: 20,
                              fontFamily: 'Baloo Bhaijaan',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Gap(10),
                                  AppIcon(
                                    width: 71,
                                    height: 63.25,
                                    asset: IconProvider.score.buildImageUrl(),
                                  ),
                                  const Gap(8),
                                  Container(
                                    width: 88,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: const Color(0xFFE2E2E2),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '10',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontFamily: 'Baloo Bhaijaan',
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Gap(10),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AppIcon(
                                    asset: IconProvider.coins.buildImageUrl(),
                                    width: 55,
                                    height: 49,
                                  ),
                                  const Gap(8),
                                  Container(
                                    width: 88,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: const Color(0xFFE2E2E2),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '1',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontFamily: 'Baloo Bhaijaan',
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  AppIcon(
                    asset: isCorrect
                        ? IconProvider.win.buildImageUrl()
                        : IconProvider.lose.buildImageUrl(),
                    width: isCorrect ? 163 : 158,
                    height: isCorrect ? 158 : 159,
                  ),
                  const Gap(38),
                  Material(
                    color: Colors.transparent,
                    child: ElevatedButton(
                      onPressed: () {
                        context
                          ..pop()
                          ..pop();
                      },
                      style: ElevatedButton.styleFrom(
                        disabledBackgroundColor: Colors.grey[600],
                        backgroundColor: const Color(0xFF8348FF),
                        elevation: 0,
                        padding: EdgeInsets.zero,
                      ),
                      child: SizedBox(
                        width: 147,
                        child: Center(
                          child: Text(
                            'CLOSE',
                            style: TextStyle(
                              fontSize: 32,
                              fontFamily: 'Baloo Bhaijaan',
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Gap(17)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
