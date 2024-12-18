import 'package:emote_this/ui_kit/app_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppBarWidget(tipsCount: 10, coinsCount: 10)
      ],
    );
  }
}
