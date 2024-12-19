import 'package:emote_this/routes/root_navigation_screen.dart';
import 'package:emote_this/src/core/utils/app_icon.dart';
import 'package:emote_this/src/core/utils/icon_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../src/feature/game/bloc/game_bloc.dart';

void showBuyHintAlertDialog(BuildContext context, bool isEnough) {
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
            height: 312,
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
                  "BUY A HINT",
                  style: TextStyle(
                    color: Color(0xFFF7D931),
                    fontSize: 36,
                    fontFamily: 'Baloo Bhaijaan',
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Gap(10),
                        AppIcon(
                          asset: IconProvider.coins.buildImageUrl(),
                          width: 60,
                          height: 52,
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
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 2),
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
                        ),
                      ],
                    ),
                    const Gap(2),
                    const Icon(
                      CupertinoIcons.arrowtriangle_right_circle_fill,
                      color: Colors.white,
                      size: 34,
                    ),
                    const Gap(2),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppIcon(
                          asset: IconProvider.tip.buildImageUrl(),
                          width: 52,
                          height: 62,
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
                const Gap(38),
                Material(
                  color: Colors.transparent,
                  child: ElevatedButton(
                    onPressed: isEnough
                        ? () {
                            context.read<GameBloc>().add(BuyHint());
                            Navigator.of(context).pop();
                          }
                        : null,
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
                          'BUY',
                          style: TextStyle(
                            fontSize: 32,
                            fontFamily: 'Baloo Bhaijaan',
                            color: isEnough ? Colors.white : Colors.grey[200],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
