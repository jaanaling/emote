import 'package:equatable/equatable.dart';

class Riddle extends Equatable {
  final int id;
  final int level;
  final int complexity;
  final String category;
  final String emojis;
  final String answer;
  final int points;
  final int coins;

  const Riddle({
    required this.id,
    required this.level,
    required this.complexity,
    required this.category,
    required this.emojis,
    required this.answer,
    required this.points,
    required this.coins,
  });

  factory Riddle.fromMap(Map<String, dynamic> map) {
    return Riddle(
      id: map['id'] as int,
      level: map['level'] as int,
      complexity: map['complexity'] as int,
      category: map['category'] as String,
      emojis: map['emojis'] as String,
      answer: map['answer'] as String,
      points: map['points'] as int,
      coins: map['coins'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'level': level,
      'complexity': complexity,
      'category': category,
      'emojis': emojis,
      'answer': answer,
      'points': points,
      'coins': coins,
    };
  }

  Riddle copyWith({
    int? id,
    int? level,
    int? complexity,
    String? category,
    String? emojis,
    String? answer,
    int? points,
    int? coins,
  }) {
    return Riddle(
      id: id ?? this.id,
      level: level ?? this.level,
      complexity: complexity ?? this.complexity,
      category: category ?? this.category,
      emojis: emojis ?? this.emojis,
      answer: answer ?? this.answer,
      points: points ?? this.points,
      coins: coins ?? this.coins,
    );
  }

  @override
  List<Object?> get props => [id, level, complexity, category, emojis, answer, points, coins];
}
