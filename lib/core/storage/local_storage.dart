import 'package:hive_flutter/hive_flutter.dart';
import 'package:talk/core/constants/storage_keys.dart';

/// 本地存储服务
/// 
/// 基于 Hive 封装的本地存储服务
/// 提供键值对存储和类型安全的存储接口
class LocalStorage {
  LocalStorage._();

  static final LocalStorage _instance = LocalStorage._();
  static LocalStorage get instance => _instance;

  late Box<dynamic> _box;

  /// 初始化本地存储
  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(StorageKeys.settingsBox);
  }

  /// 读取数据
  T? read<T>(String key) {
    return _box.get(key) as T?;
  }

  /// 写入数据
  Future<void> write<T>(String key, T value) async {
    await _box.put(key, value);
  }

  /// 删除数据
  Future<void> delete(String key) async {
    await _box.delete(key);
  }

  /// 检查是否存在
  bool containsKey(String key) {
    return _box.containsKey(key);
  }

  /// 清空所有数据
  Future<void> clear() async {
    await _box.clear();
  }

  /// 获取所有键
  Iterable<String> get keys {
    return _box.keys.cast<String>();
  }

  /// 获取所有数据
  Map<String, dynamic> get allData {
    return Map<String, dynamic>.from(_box.toMap());
  }

  /// 监听数据变化
  Stream<BoxEvent> watch(String key) {
    return _box.watch(key: key);
  }
}

/// 特定 Box 的存储服务基类
/// 
/// 提供类型安全的存储接口
abstract class BoxStorage<T> {
  final String boxName;
  late Box<T> _box;

  BoxStorage(this.boxName);

  /// 初始化 Box
  Future<void> init() async {
    _box = await Hive.openBox<T>(boxName);
  }

  /// 获取所有数据
  List<T> get all => _box.values.toList();

  /// 根据索引获取
  T? getAt(int index) => _box.getAt(index);

  /// 根据键获取
  T? get(String key) => _box.get(key);

  /// 添加数据
  Future<void> add(T value) async {
    await _box.add(value);
  }

  /// 根据键写入
  Future<void> put(String key, T value) async {
    await _box.put(key, value);
  }

  /// 根据索引写入
  Future<void> putAt(int index, T value) async {
    await _box.putAt(index, value);
  }

  /// 根据键删除
  Future<void> delete(String key) async {
    await _box.delete(key);
  }

  /// 根据索引删除
  Future<void> deleteAt(int index) async {
    await _box.deleteAt(index);
  }

  /// 清空
  Future<void> clear() async {
    await _box.clear();
  }

  /// 数量
  int get length => _box.length;

  /// 是否为空
  bool get isEmpty => _box.isEmpty;

  /// 是否非空
  bool get isNotEmpty => _box.isNotEmpty;

  /// 监听变化
  Stream<BoxEvent> watch({String? key}) {
    return _box.watch(key: key);
  }
}
