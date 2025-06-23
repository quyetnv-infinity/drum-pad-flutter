import 'package:and_drum_pad_flutter/data/model/category_model.dart';
import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';
import 'package:and_drum_pad_flutter/data/service/api_service/song_service.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  final SongService _songService;

  CategoryProvider(this._songService){
    fetchCategories();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  Future<void> fetchCategories() async {
    if(_categories.isNotEmpty) return;
    _isLoading = true;
    notifyListeners();

    try {
      final res = await _songService.fetchCategoryDataHome();
      _categories = res.data ?? [];
      print('$_categories==================');
    } catch (e, stackTrace) {
      print('Error fetching categories: $e $stackTrace');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchItemByCategory({required String categoryCode}) async {
    final categoryIndex = _categories.indexWhere((category) => category.code == categoryCode);
    if(categoryIndex == -1 || (_categories[categoryIndex].items != null && _categories[categoryIndex].items!.isNotEmpty && _categories[categoryIndex].items!.length > 5)) return;
    _isLoading = true;
    notifyListeners();
    try {
      final res = await _songService.fetchItemsByCategory(categoryCode);
      final listSong = res.data ?? [];

      if (categoryIndex != -1) {
        _categories[categoryIndex] = _categories[categoryIndex].copyWith(
          items: listSong,
        );
      }
    } catch (e, stackTrace) {
      print('Error fetching item by category: $e $stackTrace');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<SongCollection> getAllSong() {
    List<SongCollection> result = [];
    if(_categories.isEmpty) return result;
    for(var category in _categories){
      if(category.items == null || category.items!.isEmpty) continue;
      result.addAll(category.items!);
    }
    result = _sortByDifficulty(result);
    return result;
  }

  List<SongCollection> _sortByDifficulty(List<SongCollection> songs){
    if(songs.isEmpty) return songs;
    final difficultyOrder = {
      DifficultyMode.easy: 0,
      DifficultyMode.medium: 1,
      DifficultyMode.hard: 2,
      DifficultyMode.demonic: 3,
    };

    return List<SongCollection>.from(songs)..sort((a, b) {
      final aOrder = difficultyOrder[a.difficulty] ?? 4;
      final bOrder = difficultyOrder[b.difficulty] ?? 4;
      return aOrder.compareTo(bOrder);
    });
  }
}