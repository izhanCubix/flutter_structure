import 'dart:typed_data';
import 'package:base_structure/data/services/hive/boxes.dart';
import 'package:base_structure/utils/result.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

class HiveService {
  HiveService._(); // Private constructor
  static final HiveService instance = HiveService._();

  static const _encryptionKeyName = 'hive_encryption_key';
  static final _secureStorage = FlutterSecureStorage();

  final Map<String, Box> _openedBoxes = {};

  /// Fetches or generates the encryption key for encrypted boxes.
  Future<Uint8List> _getOrCreateEncryptionKey() async {
    final storedKey = await _secureStorage.read(key: _encryptionKeyName);
    if (storedKey != null) {
      return Uint8List.fromList(storedKey.split(',').map(int.parse).toList());
    }

    final key = Hive.generateSecureKey();
    await _secureStorage.write(key: _encryptionKeyName, value: key.join(','));
    return Uint8List.fromList(key);
  }

  /// Returns an opened box (cached if already opened), respecting encryption.
  Future<Box> _getBox(BoxConfig boxConfig) async {
    final name = boxConfig.name;
    if (_openedBoxes.containsKey(name)) {
      return _openedBoxes[name]!;
    }

    Box box;
    if (boxConfig.encrypted) {
      final encryptionKey = await _getOrCreateEncryptionKey();
      box = await Hive.openBox(
        name,
        encryptionCipher: HiveAesCipher(encryptionKey),
      );
    } else {
      box = await Hive.openBox(name);
    }

    _openedBoxes[name] = box;
    return box;
  }

  /// Write data to a box.
  Future<void> write({
    required BoxConfig box,
    required String key,
    required dynamic value,
  }) async {
    try {
      final hiveBox = await _getBox(box);
      await hiveBox.put(key, value);
    } catch (e, stackTrace) {
      print('Hive write error [${box.name}/$key]: $e\n$stackTrace');
    }
  }

  /// Read data from a box.
  Future<Result<T>> read<T>({
    required BoxConfig box,
    required String key,
  }) async {
    try {
      final hiveBox = await _getBox(box);
      final value = hiveBox.get(key);

      if (value == null) {
        return Result.error(
          Exception('No value found for key "$key" in box "${box.name}".'),
        );
      }

      return Result.ok(value as T);
    } catch (e, stackTrace) {
      print('Hive read error [${box.name}/$key]: $e\n$stackTrace');
      return Result.error(Exception('Hive read failed: $e'));
    }
  }

  /// Delete a key from a box.
  Future<Result<bool>> delete({
    required BoxConfig box,
    required String key,
  }) async {
    try {
      final hiveBox = await _getBox(box);
      await hiveBox.delete(key);
      return Result.ok(true);
    } catch (e, stackTrace) {
      print('Hive delete error [${box.name}/$key]: $e\n$stackTrace');
      return Result.error(Exception('Hive delete failed: $e'));
    }
  }

  /// Clear an entire box.
  Future<void> clear(BoxConfig box) async {
    try {
      final hiveBox = await _getBox(box);
      await hiveBox.clear();
    } catch (e, stackTrace) {
      print('Hive clear error [${box.name}]: $e\n$stackTrace');
    }
  }

  /// Watch changes to a specific key or the whole box.
  Future<Stream<BoxEvent>> watch({required BoxConfig box, String? key}) async {
    try {
      final hiveBox = await _getBox(box);
      return hiveBox.watch(key: key);
    } catch (e, stackTrace) {
      print('Hive watch error [${box.name}/${key ?? '*'}]: $e\n$stackTrace');
      return const Stream.empty();
    }
  }

  /// Close a specific box (optional).
  Future<void> closeBox(BoxConfig box) async {
    final name = box.name;
    if (_openedBoxes.containsKey(name)) {
      await _openedBoxes[name]!.close();
      _openedBoxes.remove(name);
    }
  }

  /// Close all boxes.
  Future<void> closeAll() async {
    for (final box in _openedBoxes.values) {
      await box.close();
    }
    _openedBoxes.clear();
  }
}
