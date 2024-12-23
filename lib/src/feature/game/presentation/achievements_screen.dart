import 'package:emote_this/src/core/utils/app_icon.dart';
import 'package:emote_this/src/core/utils/icon_provider.dart';
import 'package:emote_this/src/core/utils/size_utils.dart';
import 'package:emote_this/src/feature/game/bloc/game_bloc.dart';
import 'package:emote_this/src/feature/game/model/achievement.dart';
import 'package:emote_this/src/feature/game/model/user.dart';
import 'package:emote_this/ui_kit/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AchievementsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        if (state is GameLoading) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        if (state is GameError) {
          return Scaffold(body: Center(child: Text(state.message)));
        }
        if (state is GameLoaded) {
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(top: 78),
                child: SafeArea(
                  child: _buildAchievementsList(
                      state.user!, state.achievements, context),
                ),
              ),
              AppBarWidget(
                tipsCount: state.user!.hints,
                coinsCount: state.user!.coins,
                hasBackButton: true,
                hasChallengeIcon: false,
                title: 'Your achievements',
              )
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  double _calculateAspectRatio(
      BuildContext context, double baseWidth, double baseHeight) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    (screenWidth * screenHeight) / (baseWidth * baseHeight);

    return (screenWidth * screenHeight) / (baseWidth * baseHeight);
  }

  // Список достижений
  Widget _buildAchievementsList(
      User user, List<Achievement> achievements, BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 7,
        runSpacing: 7,
        children: achievements.map((achievement) {
          return _buildAchievementCard(achievement, user);
        }).toList(),
      ),
    );
  }

  Widget _buildAchievementCard(Achievement achievement, User user) {
    return Stack(
      children: [
        Container(
          width: 130.0,
          height: 160,
          decoration: ShapeDecoration(
            color: user.obtainedAchievements.contains(achievement.id) || achievement.unlocked
                ? Color(0xFFB3FFA6)
                : Color(0xFFFFA6A6),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 2, color: Color(0xFFFF489F)),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppIcon(
                asset: achievement.difficalty == 1
                    ? IconProvider.third.buildImageUrl()
                    : achievement.difficalty == 2
                        ? IconProvider.second.buildImageUrl()
                        : IconProvider.first.buildImageUrl(),
                width: 64,
                height: 76,
              ),
              SizedBox(height: 6),
              Text(
                achievement.title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontFamily: 'Baloo Bhaijaan',
                  fontWeight: FontWeight.w400,
                ),
              ),
              Gap(2),
              Text(
                achievement.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontFamily: 'Arial',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 5,
          top: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppIcon(
                width: 23,
                height: 20,
                fit: BoxFit.fitWidth,
                asset: IconProvider.coins.buildImageUrl(),
              ),
              Gap(2),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE2E2E2), width: 1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      achievement.coinReward.toString(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontFamily: 'Baloo Bhaijaan',
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
