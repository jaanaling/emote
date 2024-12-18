part of 'game_bloc.dart';

abstract class GameState extends Equatable {
  const GameState();

  @override
  List<Object?> get props => [];
}

class GameInitial extends GameState {}

class GameLoading extends GameState {}

class GameLoaded extends GameState {
  final List<Riddle> riddles;
  final List<Achievement> achievements;
  final User? user;
  final String? message;

  const GameLoaded({
    required this.riddles,
    required this.achievements,
    required this.user,
    this.message,
  });

  @override
  List<Object?> get props => [riddles, achievements, user, message];
}

class GameError extends GameState {
  final String message;
  const GameError(this.message);

  @override
  List<Object?> get props => [message];
}
