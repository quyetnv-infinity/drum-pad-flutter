import 'package:dio/dio.dart';

class ApiService {
  late final Dio dio;
  static const String BASEURL = 'https://strapiv2.backendvn.com';
  ApiService({String baseUrl = BASEURL}) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
  }

  Future<Response> getRequest(String endpoint,{Map<String, dynamic>? params, Map<String, dynamic>? headers}) async {
    try {
      return await dio.get(
        endpoint,
        queryParameters: params,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      print("Dio error: $e");
      rethrow;
    }
  }

  Future<Response> postRequest(String endpoint, {Object? data, Map<String, dynamic>? headers}) async {
    try {
      return await dio.post(
        endpoint,
        data: data,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      print('Dio error: $e');
      rethrow;
    }
  }
}
