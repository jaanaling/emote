import 'package:emote_this/routes/go_router_config.dart';
import 'package:emote_this/routes/route_value.dart';
import 'package:emote_this/src/core/utils/app_icon.dart';
import 'package:emote_this/src/core/utils/icon_provider.dart';
import 'package:emote_this/src/core/utils/size_utils.dart';
import 'package:emote_this/ui_kit/alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AppBarWidget extends StatelessWidget {
  final int tipsCount;
  final int coinsCount;
  final String? title;
  final bool hasBackButton;
  final bool hasChallengeIcon;
  const AppBarWidget({
    super.key,
    required this.tipsCount,
    required this.coinsCount,
    this.title,
    this.hasBackButton = false,
    this.hasChallengeIcon = true
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          width: getWidth(1, context),
          height: 46.5 + MediaQuery.of(context).padding.top,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Color(0xFFFF48A0),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: hasBackButton ? 15 : 29,
                right: 29,
                bottom: 5.5,
                top: MediaQuery.of(context).padding.top,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (hasBackButton)
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            context.pop();
                          },
                          borderRadius: BorderRadius.circular(32),
                          child: const Icon(
                            CupertinoIcons.arrowtriangle_left_circle_fill,
                            color: Colors.white,
                            size: 34,
                          ),
                        ),
                      ),
                    ),
                  if(hasChallengeIcon)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          context.push(
                            '${RouteValue.home.path}/${RouteValue.achievements.path}',
                          );
                        },
                        borderRadius: BorderRadius.circular(32),
                        child: Ink.image(
                          width: 26,
                          height: 25,
                          image: AssetImage(
                              IconProvider.achievements.buildImageUrl()),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4, left: 4),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          context.push(
                            '${RouteValue.home.path}/${RouteValue.privicy.path}',
                          );
                        },
                        borderRadius: BorderRadius.circular(32),
                        child: Ink(
                          width: 26,
                          height: 25,
                          child: Icon(Icons.privacy_tip, size: 25, color: Colors.white,),
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        showBuyHintAlertDialog(context, coinsCount >= 10);
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Ink.image(
                              width: 19,
                              height: 23,
                              fit: BoxFit.fitWidth,
                              image:
                                  AssetImage(IconProvider.tip.buildImageUrl()),
                            ),
                            _countContainer(tipsCount, true),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Gap(5),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Ink.image(
                            width: 23,
                            height: 20,
                            fit: BoxFit.fitWidth,
                            image:
                                AssetImage(IconProvider.coins.buildImageUrl()),
                          ),
                          _countContainer(coinsCount, false),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 5,
          child: Text(
            title ?? 'Emote This!',
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ],
    );
  }
}

Widget _countContainer(int count, bool hasAddButton) {
  return Padding(
    padding: const EdgeInsets.only(top: 2),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE2E2E2), width: 1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                count.toString(),
                style: const TextStyle(
                  fontSize: 10,
                  fontFamily: 'Baloo Bhaijaan',
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        if (hasAddButton)
          Positioned(
            right: 3,
            child: Ink(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: const Color(0xFFFBEE18),
              ),
              child: const Center(
                child: Text(
                  '+',
                  style: TextStyle(
                    fontSize: 8,
                    fontFamily: 'Baloo Bhaijaan',
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
