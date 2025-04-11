import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/mvvm/service/api_response.dart';
import 'package:drumpad_flutter/src/mvvm/service/api_service.dart';

class SongService extends ApiService {
  SongService({super.baseUrl});

  Future<ApiResponse<List<SongCollection>>> fetchSongsByCategory(String categoryCode) async {
    try {
      final jsonResponse = await getRequest('/api/ios-ai-fusions?categoryCode=$categoryCode');
      return ApiResponse.fromJson(jsonResponse.data, (data) {
        return (data as List)
            .map((item) => SongCollection.fromJsonRoot(item))
            .toList();
      },);
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<SongCollection>> fetchSong(String id) async {
    try {
      final jsonResponse = await getRequest('/api/ios-ai-fusions?id=$id');
      return ApiResponse.fromJson(jsonResponse.data, (data) {
        return SongCollection.fromJsonRoot(data);
      },);
    } catch (e) {
      rethrow;
    }
  }

}