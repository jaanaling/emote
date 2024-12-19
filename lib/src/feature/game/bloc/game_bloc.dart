import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:emote_this/src/core/dependency_injection.dart';
import 'package:emote_this/src/feature/game/repository/repository.dart';
import 'package:equatable/equatable.dart';

// Импорт моделей
import '../model/riddle.dart';
import '../model/achievement.dart';
import '../model/user.dart';

// Импорт репозиториев

import '../repository/achievement_repository.dart';
import '../repository/user_repository.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final RiddleRepository riddleRepository = locator<RiddleRepository>();
  final AchievementRepository achievementRepository =
      locator<AchievementRepository>();
  final UserRepository userRepository = locator<UserRepository>();

  List<Riddle> _riddles = [];
  List<Achievement> _achievements = [];
  User? _user;
  int currentAttempts = 0; // Счётчик попыток

  GameBloc() : super(GameInitial()) {
    on<LoadGameData>(_onLoadGameData);
    on<SolveRiddle>(_onSolveRiddle);
    on<UnlockAchievement>(_onUnlockAchievement);
    on<UpdateUserData>(_onUpdateUserData);
    on<BuyHint>(_onBuyHint);
    on<SubmitRiddleAnswer>(_onSubmitRiddleAnswer);
    on<UseHint>(_onUseHint);
  }

  Future<void> _onLoadGameData(
    LoadGameData event,
    Emitter<GameState> emit,
  ) async {
    emit(GameLoading());
    try {
      final riddles = await riddleRepository.load();
      final achievements = await achievementRepository.load();
      final users = await userRepository.load();

      final user = users ??
          User(
            id: 1,
            points: 0,
            coins: 20,
            hints: 3,
            obtainedAchievements: [],
            solvedRiddles: [],
            failedRiddles: [],
            currentLevel: 1,
          );

      _riddles = riddles;
      _achievements = achievements;
      _user = user;

      emit(GameLoaded(
        riddles: _riddles,
        achievements: _achievements,
        user: _user,
      ));
    } catch (e) {
      emit(GameError('Failed to load data: $e'));
    }
  }

  Future<void> _onSolveRiddle(
    SolveRiddle event,
    Emitter<GameState> emit,
  ) async {
    if (_user == null) {
      emit(const GameError('No user loaded'));
      return;
    }

    final riddleIndex = _riddles.indexWhere((r) => r.id == event.riddleId);
    if (riddleIndex == -1) {
      emit(GameError('Riddle not found'));
      return;
    }

    final riddle = _riddles[riddleIndex];
    // Проверяем не решена ли уже загадка
    if (_user!.solvedRiddles.contains(riddle.id)) {
      // Уже решена, ничего не делаем
      return;
    }

    // Начисляем очки и монеты за решённую загадку
    final newPoints = _user!.points + riddle.points;
    final newCoins = _user!.coins + riddle.coins;
    final newSolvedRiddles = List<int>.from(_user!.solvedRiddles)
      ..add(riddle.id);

    var updatedUser = _user!.copyWith(
      points: newPoints,
      coins: newCoins,
      solvedRiddles: newSolvedRiddles,
    );

    // Проверяем прогресс по уровню после решения загадки
    updatedUser = _checkLevelProgress(updatedUser);

    try {
      // Сохраняем обновлённого пользователя
      await userRepository.update(updatedUser);
      _user = updatedUser;

      // Проверяем, не разблокировались ли новые достижения
      await _checkAchievements();

      emit(GameLoaded(
        riddles: _riddles,
        achievements: _achievements,
        user: _user,
      ));
    } catch (e) {
      emit(GameError('Failed to update user after solving riddle: $e'));
    }
  }

  Future<void> _onUnlockAchievement(
    UnlockAchievement event,
    Emitter<GameState> emit,
  ) async {
    if (_user == null) {
      emit(const GameError('No user loaded'));
      return;
    }

    final index = _achievements.indexWhere((a) => a.id == event.achievementId);
    if (index == -1) {
      emit(GameError('Achievement not found'));
      return;
    }

    final achievement = _achievements[index];
    if (achievement.unlocked) {
      // Уже разблокировано
      return;
    }

    final updatedAchievement = achievement.copyWith(unlocked: true);
    _achievements[index] = updatedAchievement;

    // Добавляем достижение к пользователю, если его там нет
    if (!_user!.obtainedAchievements.contains(achievement.id)) {
      final newObtained = List<int>.from(_user!.obtainedAchievements)
        ..add(achievement.id);
      final newCoins = _user!.coins + achievement.coinReward;

      final updatedUser = _user!.copyWith(
        obtainedAchievements: newObtained,
        coins: newCoins,
      );

      try {
        await achievementRepository.update(updatedAchievement);
        await userRepository.update(updatedUser);
        _user = updatedUser;

        emit(GameLoaded(
          riddles: _riddles,
          achievements: _achievements,
          user: _user,
        ));
      } catch (e) {
        emit(GameError('Failed to unlock achievement: $e'));
      }
    }
  }

  Future<void> _onUpdateUserData(
    UpdateUserData event,
    Emitter<GameState> emit,
  ) async {
    if (_user == null) {
      emit(const GameError('No user loaded'));
      return;
    }

    try {
      await userRepository.update(event.user);
      _user = event.user;

      // Проверяем достижения после обновления пользователя
      await _checkAchievements();

      emit(GameLoaded(
        riddles: _riddles,
        achievements: _achievements,
        user: _user,
      ));
    } catch (e) {
      emit(GameError('Failed to update user: $e'));
    }
  }

  Future<void> _onBuyHint(
    BuyHint event,
    Emitter<GameState> emit,
  ) async {
    if (_user == null) {
      emit(const GameError('No user loaded'));
      return;
    }

    if (_user!.coins < 10) {
      emit(const GameError('Not enough coins to buy a hint'));
      return;
    }

    final updatedUser = _user!.copyWith(
      coins: _user!.coins - 10,
      hints: _user!.hints + 1,
    );

    try {
      await userRepository.update(updatedUser);
      _user = updatedUser;

      // Проверяем достижения после покупки подсказки
      await _checkAchievements();

      emit(GameLoaded(
        riddles: _riddles,
        achievements: _achievements,
        user: _user,
      ));
    } catch (e) {
      emit(GameError('Failed to buy a hint: $e'));
    }
  }

  /// Проверка прогресса по уровню: если пользователь набрал >=40% от максимума очков текущего уровня, повышаем уровень.
  User _checkLevelProgress(User user) {
    final currentLevel = user.currentLevel;
    // Фильтруем загадки по текущему уровню
    final levelRiddles =
        _riddles.where((r) => r.level == currentLevel).toList();
    if (levelRiddles.isEmpty) return user;

    final totalPointsInLevel =
        levelRiddles.fold<int>(0, (sum, r) => sum + r.points);
    final userPointsInLevel = user.solvedRiddles
        .map((id) => _riddles.firstWhere((r) => r.id == id,
            orElse: () => Riddle(
                id: 0,
                level: 0,
                complexity: 0,
                category: '',
                emojis: '',
                answer: '',
                points: 0,
                coins: 0)))
        .where((r) => r.level == currentLevel)
        .fold<int>(0, (sum, r) => sum + r.points);

    if (totalPointsInLevel > 0) {
      final requiredPoints = (totalPointsInLevel * 0.4).floor();
      if (userPointsInLevel >= requiredPoints) {
        // Повышаем уровень
        return user.copyWith(currentLevel: user.currentLevel + 1);
      }
    }

    return user;
  }

  /// Проверяем, можно ли разблокировать новые достижения.
  /// Логику условий можно адаптировать. Ниже пример:
  /// Разблокируем все достижения, у которых `difficalty` <= количеству решённых загадок.
  Future<void> _checkAchievements() async {
    if (_user == null) return;

    // Получаем ID решённых загадок
    final solvedIds = _user!.solvedRiddles;

    // Подсчитываем количество решённых загадок по категориям
    final categoryCount = <String, int>{};
    for (var riddle in _riddles) {
      if (solvedIds.contains(riddle.id)) {
        categoryCount[riddle.category] =
            (categoryCount[riddle.category] ?? 0) + 1;
      }
    }

    // Список всех категорий (их нужно знать заранее или вычислить)
    // Предположим, что категории следующие:
    final allCategories = [
      "Movies & TV",
      "Fairy tales & literature",
      "Songs & Musicians",
      "Celebrities & historical figures",
      "Food & Drinks",
      "Cities & Countries",
      "Animals & Nature"
    ];

    bool updated = false;

    for (int i = 0; i < _achievements.length; i++) {
      final ach = _achievements[i];
      if (ach.unlocked) continue; // уже разблокировано

      bool unlock = false; // условие для разблокировки

      switch (ach.id) {
        case 1: // First Steps: Solve your first riddle
          unlock = solvedIds.length >= 1;
          break;
        case 2: // On a Roll: Solve 10 riddles
          unlock = solvedIds.length >= 10;
          break;
        case 3: // Riddle Master: Solve 50 riddles
          unlock = solvedIds.length >= 50;
          break;
        case 6: // Category Explorer: Solve at least one riddle from each category
          unlock = allCategories.every((cat) => (categoryCount[cat] ?? 0) >= 1);
          break;
        case 7: // Food Lover: Solve 10 Food & Drinks riddles
          unlock = (categoryCount["Food & Drinks"] ?? 0) >= 10;
          break;
        case 8: // Movie Buff: Solve 10 Movies & TV riddles
          unlock = (categoryCount["Movies & TV"] ?? 0) >= 10;
          break;
        case 9: // Book Worm: Solve 10 Fairy tales & literature riddles
          unlock = (categoryCount["Fairy tales & literature"] ?? 0) >= 10;
          break;
        case 10: // Melody Maker: Solve 10 Songs & Musicians riddles
          unlock = (categoryCount["Songs & Musicians"] ?? 0) >= 10;
          break;
        case 11: // History Fan: Solve 10 Celebrities & historical figures riddles
          unlock =
              (categoryCount["Celebrities & historical figures"] ?? 0) >= 10;
          break;
        case 12: // Globe Trotter: Solve 10 Cities & Countries riddles
          unlock = (categoryCount["Cities & Countries"] ?? 0) >= 10;
          break;
        case 13: // Wildlife Enthusiast: Solve 10 Animals & Nature riddles
          unlock = (categoryCount["Animals & Nature"] ?? 0) >= 10;
          break;
        case 14: // Wealthy: Accumulate 100 coins
          unlock = _user!.coins >= 100;
          break;
        case 15: // Brainiac: Accumulate 1000 points
          unlock = _user!.points >= 1000;
          break;

        default:
          break;
      }

      if (unlock) {
        final updatedAch = ach.copyWith(unlocked: true);
        _achievements[i] = updatedAch;

        // Добавляем ачивку пользователю, если её ещё нет
        if (!_user!.obtainedAchievements.contains(ach.id)) {
          final newObtained = List<int>.from(_user!.obtainedAchievements)
            ..add(ach.id);
          final newCoins = _user!.coins + ach.coinReward;
          final updatedUser = _user!.copyWith(
            obtainedAchievements: newObtained,
            coins: newCoins,
          );

          try {
            await achievementRepository.update(updatedAch);
            await userRepository.update(updatedUser);
            _user = updatedUser;
            updated = true;
          } catch (e) {
            // Логируем ошибку, но не ломаем логику
          }
        }
      }
    }

    if (updated) {
      emit(GameLoaded(
        riddles: _riddles,
        achievements: _achievements,
        user: _user,
      ));
    }
  }

  Future<void> _onSubmitRiddleAnswer(
    SubmitRiddleAnswer event,
    Emitter<GameState> emit,
  ) async {
    if (_user == null) {
      emit(const GameError('No user loaded'));
      return;
    }

    final riddle = _riddles.firstWhere((r) => r.id == event.riddleId);
    if (riddle == null) {
      emit(GameError('Riddle not found'));
      return;
    }

    // Проверяем ответ
    if (event.answer.toLowerCase() == riddle.answer.toLowerCase()) {
      // Загадка решена успешно
      _user = _user!.copyWith(
        points: _user!.points + riddle.points,
        coins: _user!.coins + riddle.coins,
        solvedRiddles: [..._user!.solvedRiddles, riddle.id],
      );
      currentAttempts = 0; // Сбрасываем попытки
      await userRepository.update(_user!);

      emit(GameLoaded(
        riddles: _riddles,
        achievements: _achievements,
        user: _user,
        message: 'Riddle solved successfully!',
      ));
    } else {
      // Неправильный ответ
      currentAttempts++;
      if (currentAttempts >= 3) {
        // Загадка проиграна
        _user = _user!.copyWith(
          failedRiddles: [..._user!.failedRiddles, riddle.id],
        );
        currentAttempts = 0; // Сбрасываем попытки
        await userRepository.update(_user!);

        emit(GameLoaded(
          riddles: _riddles,
          achievements: _achievements,
          user: _user,
          message: 'You failed the riddle!',
        ));
      } else {
        emit(GameLoaded(
          riddles: _riddles,
          achievements: _achievements,
          user: _user,
          message: 'Incorrect! Attempts left: ${3 - currentAttempts}',
        ));
      }
    }
  }

  /// Использование подсказки
  Future<void> _onUseHint(
    UseHint event,
    Emitter<GameState> emit,
  ) async {
    // Списываем 10 монет и добавляем подсказку
    _user = _user!.copyWith(
      hints: _user!.hints - 1,
    );

    await userRepository.update(_user!);

    emit(GameLoaded(
      riddles: _riddles,
      achievements: _achievements,
      user: _user,
      message: 'Hint used! Coins deducted: 10',
    ));
  }
}
