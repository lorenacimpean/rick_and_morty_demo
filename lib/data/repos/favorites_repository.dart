import 'package:hive_ce/hive_ce.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

// Favorite character ids, kept on the device. Keys are ids; values are unused.
class FavoritesRepository {
  static const _kBoxName = 'favorites';

  final Box<bool> _box;

  const FavoritesRepository(this._box);

  static Future<FavoritesRepository> open() async {
    final directory = await getApplicationSupportDirectory();
    return FavoritesRepository(
      await Hive.openBox<bool>(_kBoxName, path: directory.path),
    );
  }

  // The current ids first, then again after every change.
  Stream<Set<String>> watchIds() =>
      Rx.defer(() => _box.watch().map((_) => _ids).startWith(_ids));

  Future<void> toggle(String id) =>
      _box.containsKey(id) ? _box.delete(id) : _box.put(id, true);

  Set<String> get _ids => _box.keys.whereType<String>().toSet();
}
