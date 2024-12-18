import '../../../core/utils/json_loader.dart';
import '../model/achievement.dart';

class AchievementRepository {
  final String key = 'achievements';

  Future<List<Achievement>> load() {
    return JsonLoader.loadData<Achievement>(
      key,
      'assets/json/achievements.json', // путь к вашему json с ачивками
      (json) => Achievement.fromMap(json),
    );
  }

  Future<void> update(Achievement updated) async {
    return JsonLoader.modifyDataList<Achievement>(
      key,
      updated,
      () async => await load(),
      (item) => item.toMap(),
      (itemList) async {
        final index = itemList.indexWhere((d) => d.id == updated.id);
        if (index != -1) {
          itemList[index] = updated;
        }
      },
    );
  }

  Future<void> save(Achievement item) {
    return JsonLoader.saveData<Achievement>(
      key,
      item,
      () async => await load(),
      (item) => item.copyWith().toMap(),
    );
  }

  Future<void> remove(Achievement item) {
    return JsonLoader.removeData<Achievement>(
      key,
      item,
      () async => await load(),
      (item) => item.toMap(),
    );
  }

  Future<Achievement?> getById(String id) async {
    final achievements = await load();
    return achievements.firstWhere((a) => a.id == id);
  }

  Future<void> saveAll(List<Achievement> achievements) {
    return JsonLoader.saveAllData<Achievement>(
      key,
      achievements,
      (item) => item.toMap(),
    );
  }
}