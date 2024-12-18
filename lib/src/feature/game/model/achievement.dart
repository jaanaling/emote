// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Achievement extends Equatable {
  final int id;
  final String title;
  final String description;
  final int difficalty;
  final int coinReward;
  final bool unlocked;

  const Achievement({
    required this.id,
    required this.title,
    required this.difficalty,
    required this.description,
    required this.coinReward,
    required this.unlocked,
  });

  Achievement copyWith({
    int? id,
    String? title,
    String? description,
    int? difficalty,
    int? coinReward,
    bool? unlocked,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      difficalty: difficalty ?? this.difficalty,
      description: description ?? this.description,
      coinReward: coinReward ?? this.coinReward,
      unlocked: unlocked ?? this.unlocked,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'difficalty': difficalty,
      'description': description,
      'coin_reward': coinReward,
      'unlocked': unlocked,
    };
  }

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      id: map['id'] as int,
      difficalty: map['difficalty'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      coinReward: map['coin_reward'] as int,
      unlocked: map['unlocked'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Achievement.fromJson(String source) =>
      Achievement.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      title,
      difficalty,
      description,
      coinReward,
      unlocked,
    ];
  }
}
