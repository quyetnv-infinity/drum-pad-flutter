import 'package:drumpad_flutter/src/mvvm/models/category_model.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/service/api_service/api_response.dart';
import 'package:drumpad_flutter/src/service/api_service/api_service.dart';

class SongService extends ApiService {
  SongService({super.baseUrl});

  Future<ApiResponse<List<Category>>> fetchCategories() async {
    try {
      final jsonResponse = await getRequest('/api/ios-drum-pad-categories');
      return ApiResponse.fromJson(jsonResponse.data, (data) {
        return (data as List)
            .map((item) => Category.fromJson(item))
            .toList();
      },);
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<List<CategoryItem>>> fetchItemsByCategory(String categoryCode) async {
    try {
      final jsonResponse = await getRequest('/api/ios-drum-pad?categoryCode=$categoryCode');
      return ApiResponse.fromJson(jsonResponse.data, (data) {
        return (data as List)
            .map((item) => CategoryItem.fromJson(item))
            .toList();
      },);
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<SongCollection>> fetchSong(String id) async {
    try {
      final jsonResponse = await getRequest('/api/ios-drum-pad?id=$id');
      return ApiResponse.fromJson(jsonResponse.data, (data) {
        return SongCollection.fromJsonRoot(data);
      },);
    } catch (e) {
      rethrow;
    }
  }

}