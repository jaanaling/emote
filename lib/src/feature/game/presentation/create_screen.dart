import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:emote_this/src/core/dependency_injection.dart';
import 'package:emote_this/src/core/utils/size_utils.dart';
import 'package:emote_this/src/feature/game/bloc/game_bloc.dart';
import 'package:emote_this/src/feature/game/repository/achievement_repository.dart';
import 'package:emote_this/src/feature/game/repository/user_repository.dart';
import 'package:emote_this/ui_kit/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/utils/app_icon.dart';

class CreateScreen extends StatelessWidget {
  final GlobalKey shareButtonKey = GlobalKey();
  CreateScreen({super.key});

  Future<void> share(
      GlobalKey shareButtonKey, String quiz, String answer) async {
    final shareText = '''
:question: **Emoji Riddle for You:**
$quiz
Try to guess what it means!
Answer (click to reveal): ||$answer||
  ''';
    await Share.share(
      shareText,
      sharePositionOrigin: shareButtonRect(shareButtonKey),
    );
  }

  Rect? shareButtonRect(GlobalKey shareButtonKey) {
    RenderBox? renderBox =
        shareButtonKey.currentContext!.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;
    Size size = renderBox.size;
    Offset position = renderBox.localToGlobal(Offset.zero);
    return Rect.fromCenter(
      center: position + Offset(size.width / 2, size.height / 2),
      width: size.width,
      height: size.height,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    final emojiController = TextEditingController();
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        if (state is GameLoaded) {
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 76),
                child: SafeArea(
                  child: Column(
                    children: [
                      _textFieldEmoji(emojiController, 'emoji', context),
                      Gap(6),
                      _textField(textController, 'word', context),
                      Spacer(),
                      Material(
                        color: Colors.transparent,
                        child: ElevatedButton(
                          onPressed: () async {
                            showBuyHintAlertDialog(
                                context,
                                emojiController.text,
                                textController.text, () async {
                              await solveAchievement(state, context, 18, true);
                            });
                            await solveAchievement(state, context, 17, true);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8348FF),
                              elevation: 0,
                              padding: EdgeInsets.zero),
                          child: SizedBox(
                            width: 250,
                            height: 37,
                            child: Center(
                              child: const Text(
                                'Create riddle',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Baloo Bhaijaan',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Gap(16)
                    ],
                  ),
                ),
              ),
              AppBarWidget(
                tipsCount: state.user!.hints,
                coinsCount: state.user!.coins,
                title: 'Create riddle',
                hasBackButton: true,
              )
            ],
          );
        } else {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        }
      },
    );
  }

  void showBuyHintAlertDialog(BuildContext context, String emoji, String word,
      void Function() onshare) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          backgroundColor: const Color(0xFF2C00AB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(38),
          ),
          content: Padding(
            padding: const EdgeInsets.only(bottom: 3, right: 3),
            child: Container(
              width: 256,
              decoration: BoxDecoration(
                color: const Color(0xFFFF48A0),
                borderRadius: BorderRadius.circular(35),
                border: Border.all(color: const Color(0xFF8348FF), width: 5),
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
                            context.pop();
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
                  const Text(
                    "YOUR RIDDLE",
                    style: TextStyle(
                      color: Color(0xFFF7D931),
                      fontSize: 36,
                      fontFamily: 'Baloo Bhaijaan',
                    ),
                  ),
                  Gap(17),
                  DecoratedBox(
                    decoration: BoxDecoration(color: Color(0xFF6ce5e8)),
                    child: SizedBox(
                        width: 202,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            emoji,
                            style: TextStyle(fontSize: 60),
                          ),
                        )),
                  ),
                  SizedBox(
                    width: 202,
                    child: Text(
                      'Word: $word',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Baloo Bhaijaan',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const Gap(38),
                  Material(
                    color: Colors.transparent,
                    child: ElevatedButton(
                      key: shareButtonKey,
                      onPressed: () {
                        share(shareButtonKey, emoji, word);
                        onshare();
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
                            'SHARE',
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
                  Gap(20)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget _textField(
    TextEditingController controller, String hint, BuildContext context) {
  return SizedBox(
    height: 55,
    width: getWidth(1, context) - 40,
    child: CupertinoTextField(
      controller: controller,
      placeholder: hint,
      keyboardType: TextInputType.text,
      maxLength: 20,
      placeholderStyle: TextStyle(
        color: Color(0xFFC0C0C0),
        fontSize: 20,
        fontFamily: 'Baloo Bhaijaan',
        fontWeight: FontWeight.w400,
      ),
      style: TextStyle(
        color: Color(0xFF000000),
        fontSize: 20,
        fontFamily: 'Baloo Bhaijaan',
        fontWeight: FontWeight.w400,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE2E2E2)),
          borderRadius: BorderRadius.circular(10)),
    ),
  );
}

Widget _textFieldEmoji(
    TextEditingController controller, String hint, BuildContext context) {
  return SizedBox(
    height: 55,
    width: MediaQuery.of(context).size.width - 40,
    child: CupertinoTextField(
      controller: controller,
      placeholder: hint,
      maxLength: 8,
      placeholderStyle: const TextStyle(
        color: Color(0xFFC0C0C0),
        fontSize: 20,
        fontFamily: 'Baloo Bhaijaan',
        fontWeight: FontWeight.w400,
      ),
      readOnly: true,
      style: const TextStyle(
        color: Color(0xFF000000),
        fontSize: 20,
        fontFamily: 'Baloo Bhaijaan',
        fontWeight: FontWeight.w400,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE2E2E2)),
        borderRadius: BorderRadius.circular(10),
      ),
      keyboardType: TextInputType.text,
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (_) => DecoratedBox(
            decoration: BoxDecoration(color: Color(0xFFcfd3d9)),
            child: SafeArea(
              top: false,
              child: EmojiPicker(
                config: Config(
                    customBackspaceIcon: Icon(
                      CupertinoIcons.delete_left_fill,
                      color: Color(0xFF5b5f66),
                    ),
                    customSearchIcon: Icon(
                      CupertinoIcons.search,
                      color: Color(0xFF5b5f66),
                    ),
                    bottomActionBarConfig: BottomActionBarConfig(
                        backgroundColor: Color(0xFFcfd3d9),
                        buttonColor: Colors.transparent)),
                onBackspacePressed: () {
                  if (controller.text.characters.isNotEmpty) {
                    // Удаляем последнюю графему (символ или эмодзи)
                    final newText =
                        controller.text.characters.skipLast(1).toString();
                    controller.text = newText;

                    // Перемещаем курсор в конец текста
                    controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: controller.text.length),
                    );
                  }
                },
                onEmojiSelected: (category, emoji) {
                  if (controller.text.characters.length < 9) {
                    controller.text += emoji.emoji;
                    controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: controller.text.length),
                    );
                  }
                },
              ),
            ),
          ),
        );
      },
    ),
  );
}
