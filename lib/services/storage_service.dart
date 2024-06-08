import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Сервис для работы с хранилищем данных
class StorageService {
  // Создаем экземпляр FlutterSecureStorage для доступа к защищенному хранилищу
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  // Метод для получения токена из хранилища
  Future<String?> getToken() async {
    return await _storage.read(key: 'token'); // Возвращает значение токена или null
  }

  // Метод для сохранения токена в хранилище
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token); // Записывает значение токена по ключу 'token'
  }

  // Метод для удаления токена из хранилища
  Future<void> deleteToken() async {
    await _storage.delete(key: 'token'); // Удаляет значение токена по ключу 'token'
  }
}
