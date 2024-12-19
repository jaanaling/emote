import 'package:emote_this/routes/route_value.dart';
import 'package:emote_this/src/feature/game/bloc/game_bloc.dart';
import 'package:emote_this/src/feature/game/model/riddle.dart';
import 'package:emote_this/src/feature/game/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class LevelScreen extends StatelessWidget {
  final int levelId;

  @override
  const LevelScreen({super.key, required this.levelId});

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
          final riddles =
              state.riddles.where((puzzle) => puzzle.level == levelId).toList();

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
          return Column(
            children: [
              _buildBackButtonAndTitle(context, levelId),
              _buildLevelContent(context, riddles, state.user!),
              _buildProgressIndicator(allScore, userScore),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  // Верхняя секция с кнопкой "назад" и названием уровня
  Widget _buildBackButtonAndTitle(BuildContext context, int levelId) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              context.pop();
            },
          ),
          Text(
            "LEVEL $levelId",
            style: const TextStyle(
              color: Colors.yellow,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 40), // Пустое пространство
        ],
      ),
    );
  }

  // Средняя секция с шариками и характеристиками уровней
  Widget _buildLevelContent(
      BuildContext context, List<Riddle> riddles, User user) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
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
                Text(
                  'X${difficultyIndex + 1}',
                  style: const TextStyle(
                    fontSize: 26,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.15,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: riddles
                        .where(
                          (e) =>
                              e.level == levelId &&
                              e.complexity == difficultyIndex + 1,
                        )
                        .map(
                          (challenge) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
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
                const Spacer(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildBall(Riddle challenge, User user, BuildContext context) {
    List<Color> gradientColors = [];
    if (user.solvedRiddles.contains(challenge.id)) {
      gradientColors = [Color(0xFFFFC600), Color(0xFFFF9900)];
    } else if (user.failedRiddles.contains(challenge.id)) {
      gradientColors = [Color(0xFFFF002D), Color(0xFF78080E)];
    } else {
      gradientColors = [Color(0xFF60FF00), Color(0xFF397808)];
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push(
          '${RouteValue.home.path}/${RouteValue.level.path}/${RouteValue.quiz.path}',
          extra: challenge.id,
        ),
        splashColor: gradientColors.first,
        borderRadius: BorderRadius.circular(32),
        child: Ink(
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
      ),
    );
  }

  // Ряд с шариками и их количеством

  // Нижняя секция с прогрессом уровня
  Widget _buildProgressIndicator(int score, int userScore) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              const SizedBox(
                height: 120,
                width: 120,
                child: CircularProgressIndicator(
                  value: 0.5, // Пример значения прогресса
                  strokeWidth: 12,
                  color: Colors.pink,
                ),
              ),
              Text(
                score.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            (score - userScore).toString(),
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
