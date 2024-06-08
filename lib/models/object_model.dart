// Класс Object представляет собой предмет с информацией о нем
class Object {
  final String id_objects;
  final String name;
  final String? name_categories;
  final String? url;
  bool isAnswered = false;
  bool isTrueAnswer = false;

  // Конструктор класса Object
  Object({
    required this.id_objects,
    required this.name,
    this.name_categories,
    this.url,
  });

  // Фабричный конструктор для создания объекта из JSON-данных
  factory Object.fromJson(Map<String, dynamic> json) => Object(
    id_objects: json['id_objects'],
    name: json['name'],
    name_categories: json['id_categories'],
    url: json['url'],
  );

  // Метод для преобразования объекта в JSON-формат
  Map<String, dynamic> toJson() => {
    'id_objects': id_objects,
    'name': name,
    'id_categories': name_categories,
    'url': url,
  };
}

// Класс Category представляет собой категорию с информацией о ней
class Category {
  final String id; // Идентификатор категории
  final String name; // Имя категории
  final String category1; // Подкатегория 1
  final String category2; // Подкатегория 2

  // Конструктор класса Category
  const Category({
    required this.id,
    required this.name,
    required this.category1,
    required this.category2,
  });
}

// Класс User представляет собой пользователя с информацией о нем
class User {
  static String id = ''; // Идентификатор пользователя
  static String name = ''; // Имя пользователя
  static String sex = ''; // Пол пользователя
  static String age = ''; // Возраст пользователя
}
