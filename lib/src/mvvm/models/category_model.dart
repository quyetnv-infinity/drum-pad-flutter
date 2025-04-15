import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:hive_ce/hive.dart';

class Category extends HiveObject {
  final String id;
  final String name;
  final String code;
  List<CategoryItem>? items;

  Category({
    required this.id,
    required this.name,
    required this.code,
    this.items = const [],
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List?;
    return Category(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      items: itemsList != null && itemsList.isNotEmpty
          ? itemsList.map((item) => CategoryItem.fromJson(item)).toList()
          : [],
    );
  }

  Category copyWith({List<CategoryItem>? items}) {
    return Category(
      id: id,
      name: name,
      code: code,
      items: items ?? this.items,
    );
  }

  @override
  String toString() {
    return 'Category{id: $id, name: $name, code: $code, items: $items}';
  }
}

class CategoryItem extends HiveObject {
  final String id;
  final String name;
  final String image;
  List<SongCollection>? items;

  CategoryItem({
    required this.id,
    required this.name,
    required this.image,
    this.items = const [],
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      items: json['items'] != null && (json['items'] as List).isNotEmpty
          ? (json['items'] as List).map((item) => SongCollection.fromJsonRoot(item)).toList()
          : [],
    );
  }

  CategoryItem copyWith({List<SongCollection>? items}) {
    return CategoryItem(
      id: id,
      name: name,
      image: image,
      items: items ?? this.items,
    );
  }

  @override
  String toString() {
    return 'CategoryItem{id: $id, name: $name, image: $image, items: $items}';
  }
}
