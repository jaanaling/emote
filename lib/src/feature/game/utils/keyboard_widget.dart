import 'package:flutter/material.dart';

class KeyboardWidget extends StatelessWidget {
  final Function(String) onLetterPressed;
  final VoidCallback onDeletePressed;
  final VoidCallback onConfirmPressed;

  KeyboardWidget({
    required this.onLetterPressed,
    required this.onDeletePressed,
    required this.onConfirmPressed,
  });

  final List<List<String>> keyboardRows = [
    ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
    ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
    ['Z', 'X', 'C', 'V', 'B', 'N', 'M'],
    ['⌫', 'CONFIRM'] // Дополнительный ряд
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: keyboardRows.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: row.map((letter) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: ElevatedButton(
                onPressed: () {
                  if (letter == '⌫') {
                    onDeletePressed();
                  } else if (letter == 'CONFIRM') {
                    onConfirmPressed();
                  } else {
                    onLetterPressed(letter);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  letter,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
