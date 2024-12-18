import 'package:emote_this/src/core/utils/app_icon.dart';
import 'package:emote_this/src/core/utils/icon_provider.dart';
import 'package:emote_this/src/core/utils/size_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget {
  final int tipsCount;
  final int coinsCount;
  final String? title;
  const AppBarWidget(
      {super.key,
      required this.tipsCount,
      required this.coinsCount,
      this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getWidth(1, context),
      height: 51.5+MediaQuery.of(context).padding.top,
      child: DecoratedBox(
        decoration: const BoxDecoration(
            color: Color(0xFFFF48A0),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        child: Padding(
          padding: EdgeInsets.only(
            left: 29,
            right: 29,
            bottom: 5.5,
            top: MediaQuery.of(context).padding.top,
          ),
          child: Row(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: (){},
                  borderRadius: BorderRadius.circular(32),
                  child: Ink.image(
                    width: 26,
                    fit: BoxFit.fitWidth,
                    image: AssetImage(IconProvider.achievements.buildImageUrl()),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                title ?? 'Emote This!',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              const Spacer(),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: (){},
                  borderRadius: BorderRadius.circular(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Ink.image(
                        width: 19,
                        height: 23,
                        fit: BoxFit.fitWidth,
                        image: AssetImage(IconProvider.tip.buildImageUrl()),
                      ),
                      _countContainer(tipsCount, true)
                    ],
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: (){},
                  borderRadius: BorderRadius.circular(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Ink.image(
                        width: 23,
                        height: 20,
                        fit: BoxFit.fitWidth,
                        image: AssetImage(IconProvider.coins.buildImageUrl()),
                      ),
                      _countContainer(coinsCount, false)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
              borderRadius: BorderRadius.circular(18)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 11),
              child: Text(
                count.toString(),
                style: const TextStyle(fontSize: 10,   fontFamily: 'Baloo Bhaijaan',
                  color: Colors.black,),
              ),
            ),
          ),
        ),
        if (hasAddButton)
          Positioned(
            left: 2.7,
            child: Ink(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: const Color(0xFFFBEE18),
                ),
                child: const Center(
                  child: Text(
                    '+',
                    style: TextStyle(fontSize: 4,
                      fontFamily: 'Baloo Bhaijaan',
                      color: Colors.black,),
                  ),
                )),
          )
      ],
    ),
  );
}
