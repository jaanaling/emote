part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

class LoadGameData extends GameEvent {}

class SolveRiddle extends GameEvent {
  final int riddleId;

  const SolveRiddle(this.riddleId);

  @override
  List<Object?> get props => [riddleId];
}

class UnlockAchievement extends GameEvent {
  final int achievementId;

  const UnlockAchievement(this.achievementId);

  @override
  List<Object?> get props => [achievementId];
}

class UpdateUserData extends GameEvent {
  final User user;

  const UpdateUserData(this.user);

  @override
  List<Object?> get props => [user];
}

class BuyHint extends GameEvent {}

// Вспомогательное событие, если необходимо переиздать состояние после обновлений
class UpdateUserDataPlaceholder extends GameEvent {
  const UpdateUserDataPlaceholder();
}

class SubmitRiddleAnswer extends GameEvent {
  final int riddleId;
  final String answer;

  const SubmitRiddleAnswer(this.riddleId, this.answer);

  @override
  List<Object?> get props => [riddleId, answer];
}

class UseHint extends GameEvent {}