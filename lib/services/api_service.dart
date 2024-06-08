import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/storage_service.dart';
import 'package:EducationalApp/models/object_model.dart';

class ApiService {
  final StorageService storageService = StorageService();

  // Получить пиктограммы
  Future<Map<String, dynamic>> fetchPictograms() async {
    String? token = await storageService.getToken();
    final response = await http.get(
      Uri.parse('https://ait2-vladislav001.amvera.io/api/v1/login/get-pictograms'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error fetching data: ${response.statusCode}');
    }
  }

  // Авторизация
  Future<String> login(String login, String password) async {
    final Map<String, dynamic> data = {
      'login': login,
      'password': password,
    };

    final response = await http.post(
      Uri.parse('https://ait2-vladislav001.amvera.io/api/v1/login/pid'),
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData['token'];
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

 // Получение параметров интерфейса для данного пользователя
  Future<Map<String, dynamic>> fetchData() async {
    try {
      final String? token = await storageService.getToken();
      final response = await http.post(
        Uri.parse('https://ait2-vladislav001.amvera.io/api/v1/information/pid'),
        headers: {
          'x-access-token': '$token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final String id = responseData['_id']; // замените 'id' на актуальное поле из ответа сервера
        User.id = responseData['_id'];
        User.name = responseData['name'];
        User.age = responseData['age'];
        User.sex = responseData['gender'];
        final Map<String, dynamic> jsonData = {};

        final configResponse = await http.get(
          Uri.parse('https://ait2-vladislav001.amvera.io/api/configuration_module/settings/item/66153763bca893857e412279/$id'),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (configResponse.statusCode == 200) {
          jsonData.addAll(json.decode(configResponse.body));
        } else {
          throw Exception('Failed to load data');
        }

        return jsonData;
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
      throw Exception('Error fetching data: $error');
    }
  }
}
