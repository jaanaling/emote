import '../../../core/utils/json_loader.dart';
import '../model/user.dart';

class UserRepository {
  final String key = 'user';

  Future<User?> load() async {
    final users = await JsonLoader.loadData<User>(
      key,
      'assets/json/user.json', // путь к json с пользователем
      (json) => User.fromMap(json),
    );
    if (users.isNotEmpty) {
      return users.first;
    }
    return null;
  }

  Future<void> update(User updated) async {
    return JsonLoader.modifyDataList<User>(
      key,
      updated,
      () async {
        final user = await load();
        return user != null ? [user] : [];
      },
      (item) => item.toMap(),
      (itemList) async {
        if (itemList.isNotEmpty) {
          itemList[0] = updated;
        } else {
          itemList.add(updated);
        }
      },
    );
  }

  Future<void> save(User item) {
    return JsonLoader.saveAllData<User>(
      key,
      [item],
      (item) => item.toMap(),
    );
  }
}
