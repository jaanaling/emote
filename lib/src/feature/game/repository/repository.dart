import '../../../core/utils/json_loader.dart';
import '../model/riddle.dart';

class RiddleRepository {
  final String key = 'riddles';

  Future<List<Riddle>> load() {
    return JsonLoader.loadData<Riddle>(
      key,
      'assets/json/$key.json', // путь к вашему json с загадками
      (json) => Riddle.fromMap(json),
    );
  }

  Future<void> update(Riddle updated) async {
    return JsonLoader.modifyDataList<Riddle>(
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

  Future<void> save(Riddle item) {
    return JsonLoader.saveData<Riddle>(
      key,
      item,
      () async => await load(),
      (item) => item.copyWith().toMap(),
    );
  }

  Future<void> remove(Riddle item) {
    return JsonLoader.removeData<Riddle>(
      key,
      item,
      () async => await load(),
      (item) => item.toMap(),
    );
  }

  Future<Riddle?> getById(int id) async {
    final riddles = await load();
    return riddles.firstWhere((r) => r.id == id);
  }

  Future<void> saveAll(List<Riddle> riddles) {
    return JsonLoader.saveAllData<Riddle>(
      key,
      riddles,
      (item) => item.toMap(),
    );
  }
}
