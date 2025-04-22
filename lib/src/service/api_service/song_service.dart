import 'package:drumpad_flutter/src/mvvm/models/category_model.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/service/api_service/api_response.dart';
import 'package:drumpad_flutter/src/service/api_service/api_service.dart';

class SongService extends ApiService {
  SongService({super.baseUrl});

  /// get category
  Future<ApiResponse<List<Category>>> fetchCategories() async {
    try {
      final jsonResponse = await getRequest('/api/ios-drumpad/home');
      return ApiResponse.fromJson(jsonResponse.data, (data) {
        return (data as List)
            .map((item) => Category.fromJson(item))
            .toList();
      },);
    } catch (e) {
      rethrow;
    }
  }

  /// home page
  Future<ApiResponse<List<Category>>> fetchCategoriesWithNumbers({required int numberOfItem}) async {
    try {
      final jsonResponse = await getRequest('/api/ios-drumpad/home?numberOfItem=$numberOfItem');
      return ApiResponse.fromJson(jsonResponse.data, (data) {
        return (data as List)
            .map((item) => Category.fromJson(item))
            .toList();
      },);
    } catch (e) {
      rethrow;
    }
  }

  /// get item
  Future<ApiResponse<List<CategoryItem>>> fetchItemsByCategory(String categoryCode) async {
    try {
      final jsonResponse = await getRequest('/api/ios-drumpads?categoryCode=$categoryCode');
      return ApiResponse.fromJson(jsonResponse.data, (data) {
        return (data as List)
            .map((item) => CategoryItem.fromJson(item))
            .toList();
      },);
    } catch (e) {
      rethrow;
    }
  }

  /// recommend item
  Future<ApiResponse<List<SongCollection>>> fetchRecommend() async {
    try {
      final jsonResponse = await getRequest('/api/ios-drumpad/recommend');
      return ApiResponse.fromJson(jsonResponse.data, (data) {
        return (data as List)
            .map((item) => SongCollection.fromJsonRoot(item))
            .toList();
      },);
    } catch (e) {
      rethrow;
    }
  }

}