import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 安全存储服务
/// 
/// 基于 flutter_secure_storage 封装的安全存储
/// 用于存储敏感数据如 Token、密码等
class SecureStorage {
  SecureStorage._();

  static final SecureStorage _instance = SecureStorage._();
  static SecureStorage get instance => _instance;

  late final FlutterSecureStorage _storage;

  /// 初始化安全存储
  void init() {
    _storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    );
  }

  /// 读取数据
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// 写入数据
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// 删除数据
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// 删除所有数据
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  /// 检查是否存在
  Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }

  /// 读取所有数据
  Future<Map<String, String>> readAll() async {
    return await _storage.readAll();
  }
}
