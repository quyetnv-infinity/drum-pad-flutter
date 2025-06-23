import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';
import 'package:hive_ce/hive.dart';

class Category extends HiveObject {
  final String name;
  final String code;
  List<SongCollection>? items;

  Category({
    required this.name,
    required this.code,
    this.items = const [],
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    final itemsList = json['item'] as List?;
    return Category(
      name: json['name'],
      code: json['code'],
      items: itemsList != null && itemsList.isNotEmpty
          ? itemsList.map((item) => SongCollection.fromJsonRoot(item)).toList()
          : [],
    );
  }

  Category copyWith({List<SongCollection>? items}) {
    return Category(
      name: name,
      code: code,
      items: items ?? this.items,
    );
  }

  @override
  String toString() {
    return 'Category{name: $name, code: $code, items: $items}';
  }
}
