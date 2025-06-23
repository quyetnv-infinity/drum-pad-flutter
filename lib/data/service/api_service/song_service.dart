
import 'package:and_drum_pad_flutter/data/model/category_model.dart';
import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';
import 'package:and_drum_pad_flutter/data/service/api_service/api_response.dart';
import 'package:and_drum_pad_flutter/data/service/api_service/api_service.dart';

class SongService extends ApiService {
  SongService({super.baseUrl});

  /// get category
  Future<ApiResponse<List<Category>>> fetchCategories() async {
    try {
      final jsonResponse = await getRequest('/api/ios-drumpad-categories');
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
  Future<ApiResponse<List<Category>>> fetchCategoryDataHome() async {
    try {
      final jsonResponse = await getRequest('/api/ios-drumpad/home?numberOfItem=5');
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
  Future<ApiResponse<List<SongCollection>>> fetchItemsByCategory(String categoryCode) async {
    try {
      final jsonResponse = await getRequest('/api/ios-drumpads?categoryCode=$categoryCode');
      return ApiResponse.fromJson(jsonResponse.data, (data) {
        return (data as List)
            .map((item) => SongCollection.fromJsonRoot(item))
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