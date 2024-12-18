import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final int points;
  final int coins;
  final int hints;
  final int currentLevel;
  final List<int> solvedRiddles;
  final List<int> failedRiddles;
  final List<int> obtainedAchievements;

  const User({
    required this.id,
    required this.points,
    required this.coins,
    required this.hints,
    required this.currentLevel,
    required this.failedRiddles,
    required this.solvedRiddles,
    required this.obtainedAchievements,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      points: map['points'] as int,
      coins: map['coins'] as int,
      hints: map['hints'] as int,
      currentLevel: map['currentLevel'] as int,
      failedRiddles: List<int>.from((map['failedRiddles'] as List?) ?? []),
      solvedRiddles: List<int>.from((map['solvedRiddles'] as List?) ?? []),
      obtainedAchievements:
          List<int>.from((map['obtainedAchievements'] as List?) ?? []),
    );
  }

  User copyWith({
    int? id,
    int? points,
    int? coins,
    int? hints,
    List<int>? solvedRiddles,
    int? currentLevel,
    List<int>? failedRiddles,
    List<int>? obtainedAchievements,
  }) {
    return User(
      id: id ?? this.id,
      points: points ?? this.points,
      currentLevel: currentLevel ?? this.currentLevel,
      coins: coins ?? this.coins,
      hints: hints ?? this.hints,
      failedRiddles: failedRiddles ?? this.failedRiddles,
      solvedRiddles: solvedRiddles ?? this.solvedRiddles,
      obtainedAchievements: obtainedAchievements ?? this.obtainedAchievements,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'points': points,
      'coins': coins,
      'currentLevel': currentLevel,
      'hints': hints,
      'solvedRiddles': solvedRiddles,
      'failedRiddles': failedRiddles,
      'obtainedAchievements': obtainedAchievements,
    };
  }

  @override
  List<Object?> get props => [
        id,
        points,
        coins,
        hints,
        solvedRiddles,
        obtainedAchievements,
        currentLevel,
        failedRiddles
      ];
}
