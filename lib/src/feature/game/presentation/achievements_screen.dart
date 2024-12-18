
import 'package:emote_this/src/feature/game/bloc/game_bloc.dart';
import 'package:emote_this/src/feature/game/model/achievement.dart';
import 'package:emote_this/src/feature/game/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          return Column(children: [
            _buildBackButton(context),
            _buildAchievementsList(state.user!, state.achievements),
            SizedBox.shrink(),
          ]);
        }
        return const SizedBox.shrink();
      },
    );
  }

  // Кнопка "назад" сверху
  Widget _buildBackButton(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          context.pop();
        },
      ),
    );
  }

  // Список достижений
  Widget _buildAchievementsList(User user, List<Achievement> achievements) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Три карточки в ряд
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75, // Пропорции карточки
        ),
        itemCount: achievements.length, // Количество достижений
        itemBuilder: (context, index) {
          return _buildAchievementCard(index, achievements[index], user);
        },
      ),
    );
  }

  // Карточка достижения
  Widget _buildAchievementCard(int index, Achievement achievement, User user) {
    return Card(
      color: user.obtainedAchievements.contains(achievement.id)
          ? Colors.green
          : Colors.red, // Цвет чередуется
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.monetization_on, color: Colors.yellow, size: 36),
          SizedBox(height: 8),
          Text(achievement.coinReward.toString(),
              style: TextStyle(color: Colors.white, fontSize: 20)),
          SizedBox(height: 8),
          Text(achievement.title,
              style: TextStyle(color: Colors.white, fontSize: 16)),
          Text(achievement.description,
              style: TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}
