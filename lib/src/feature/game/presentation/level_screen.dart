import 'package:emote_this/routes/route_value.dart';
import 'package:emote_this/src/core/utils/app_icon.dart';
import 'package:emote_this/src/core/utils/icon_provider.dart';
import 'package:emote_this/src/feature/game/bloc/game_bloc.dart';
import 'package:emote_this/src/feature/game/model/riddle.dart';
import 'package:emote_this/src/feature/game/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../ui_kit/app_bar.dart';
import 'home_screen.dart';

class LevelScreen extends StatefulWidget {
  final int levelId;

  @override
  const LevelScreen({super.key, required this.levelId});

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  int level = 1;
  @override
  void initState() {
    super.initState();
    level = widget.levelId;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        if (state is GameLoading) {
          return const Scaffold(
            body: Center(child: CupertinoActivityIndicator()),
          );
        }
        if (state is GameError) {
          return Scaffold(body: Center(child: Text(state.message)));
        }
        if (state is GameLoaded) {
          final riddles =
              state.riddles.where((puzzle) => puzzle.level == level).toList();

          final int allScore = riddles.fold<int>(
            0,
            (previousValue, element) => previousValue + element.points,
          );
          final int userScore = riddles
              .where(
                  (element) => state.user!.solvedRiddles.contains(element.id))
              .fold<int>(
                0,
                (previousValue, element) => previousValue + element.points,
              );

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: SafeArea(
                  child: Column(
                    children: [
                      Gap(21),
                      Text(
                        'LEVEL ${level}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontFamily: 'Baloo Bhaijaan',
                          fontWeight: FontWeight.w400,
                          height: 1,
                        ),
                      ),
                      Gap(30),
                      _buildLevelContent(context, riddles, state.user!),
                      Spacer(),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          RoundedPieChart(
                            value: userScore / allScore,
                          ),
                          Text(
                            '$userScore\nSCORE',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 26, height: 0.95),
                          )
                        ],
                      ),
                      Spacer(),
                      Text(
                        '${allScore - userScore} LEFT',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 26,
                          fontFamily: 'Baloo Bhaijaan',
                          fontWeight: FontWeight.w400,
                          height: 1,
                        ),
                      ),
                      Gap(19)
                    ],
                  ),
                ),
              ),
              AppBarWidget(
                tipsCount: state.user!.hints,
                coinsCount: state.user!.coins,
                title: 'Select level',
                hasBackButton: true,
              )
            ],
          );
        }
        return const Center(child: CupertinoActivityIndicator());
      },
    );
  }

  // Средняя секция с шариками и характеристиками уровней
  Widget _buildLevelContent(
    BuildContext context,
    List<Riddle> riddles,
    User user,
  ) {
    return Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFFFF489F),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Column(
              children: List.generate(6, (index) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 6.0,
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.width * 0.12,
                    width: 30,
                    child: Center(
                      child: Text(
                        'X${6 - index}',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Expanded(
                  child: SizedBox(
                    height: (MediaQuery.of(context).size.width * 0.12 + 6) * 6,
                    child: ListView.separated(
                      reverse: true,
                      itemCount: 6,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => const Gap(6),
                      itemBuilder: (context, difficultyIndex) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.width * 0.12,
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: riddles
                                    .where(
                                      (e) =>
                                          e.level == level &&
                                          e.complexity == difficultyIndex + 1,
                                    )
                                    .map(
                                      (challenge) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 2),
                                        child: buildBall(
                                          challenge,
                                          user,
                                          context,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                if (user.currentLevel > 1 && level > 1)
                      Positioned(
                    top: 0,
                    left: 0,
                    bottom: 0,
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            level--;
                          });
                        },
                        icon: Icon(CupertinoIcons.backward_end_fill)),
                  ),
                if (user.currentLevel > 1 && level < 3)
                  Positioned(
                    top: 0,
                    right: 0,
                    bottom: 0,
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            level++;
                          });
                        },
                        icon: Icon(CupertinoIcons.forward_end_fill)),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBall(Riddle challenge, User user, BuildContext context) {
    List<Color> gradientColors = [];
    bool isUse = false;
    if (user.solvedRiddles.contains(challenge.id)) {
      gradientColors = [Color(0xFF60FF00), Color(0xFF397808)];
      isUse = true;
    } else if (user.failedRiddles.contains(challenge.id)) {
      gradientColors = [Color(0xFFFF002D), Color(0xFF78080E)];
      isUse = true;
    } else {
      gradientColors = [Color(0xFFFFC600), Color(0xFFFF9900)];
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.read<GameBloc>().currentAttempts = 0;
          isUse
            ? null
            : context.push(
                '${RouteValue.home.path}/${RouteValue.level.path}/${RouteValue.quiz.path}',
                extra: challenge.id,
              );},
        splashColor: gradientColors.first,
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Ink(
              width: MediaQuery.of(context).size.width * 0.12,
              height: MediaQuery.of(context).size.width * 0.12,
              decoration: ShapeDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.00, -1.00),
                  end: Alignment(0, 1),
                  colors: gradientColors,
                ),
                shape: OvalBorder(),
              ),
            ),
            _getIconByCategory(challenge.category)
          ],
        ),
      ),
    );
  }

  Widget _getIconByCategory(String category) {
    switch (category) {
      case 'Movies & TV':
        return AppIcon(
          asset: IconProvider.movie.buildImageUrl(),
          width: 24,
          height: 28,
        );
      case 'Fairy tales & literature':
        return AppIcon(
          asset: IconProvider.books.buildImageUrl(),
          width: 30,
          height: 26,
        );
      case 'Songs & Musicians':
        return AppIcon(
          asset: IconProvider.music.buildImageUrl(),
          width: 27,
          height: 25,
        );
      case 'Food & Drinks':
        return AppIcon(
          asset: IconProvider.food.buildImageUrl(),
          width: 26,
          height: 27,
        );
      case 'Animals & Nature':
        return AppIcon(
          asset: IconProvider.animals.buildImageUrl(),
          width: 25.14,
          height: 25.54,
        );
      case 'Celebrities & historical figures':
        return AppIcon(
          asset: IconProvider.stars.buildImageUrl(),
          width: 13,
          height: 30,
        );
    }
    return AppIcon(
      asset: IconProvider.country.buildImageUrl(),
      width: 36,
      height: 36,
    );
  }
}
