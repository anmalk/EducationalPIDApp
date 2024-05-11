class Object{
  final String id_objects;
  final String name;
  final String? name_categories;
  final String? url;
  bool isAnswered = false;
  bool isTrueAnswer = false;

  Object({
    required this.id_objects,
    required this.name,
    this.name_categories,
    this.url
  });

  factory Object.fromJson(Map<String,dynamic> json) => Object(
      id_objects: json['id_objects'],
      name: json['name'],
      name_categories: json['id_categories'],
      url: json['url']
  );

  Map<String,dynamic> toJson() => {
    'id_objects': id_objects,
    'name': name,
    'id_categories': name_categories,
    'url': url
  };
}

class Category {
  final String id;
  final String name;
  final String category1;
  final String category2;

  const Category({
    required this.id,
    required this.name,
    required this.category1,
    required this.category2,
  });
}

class User {
  final String id;
  final String name;
  final String sex;
  final int age;

  const User({
    required this.id,
    required this.name,
    required this.sex,
    required this.age,
  });
}