class ApiResponse<T> {
  final T? data;
  final Pagination? meta;

  ApiResponse({required this.data, required this.meta});

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic data) fromJsonT) {
    return ApiResponse<T>(
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      meta: json["meta"] == null ? null : Pagination.fromJson(json['meta']['pagination']),
    );
  }
}

class Pagination {
  final int page;
  final int pageSize;
  final int pageCount;
  final int total;

  Pagination({
    required this.page,
    required this.pageSize,
    required this.pageCount,
    required this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'],
      pageSize: json['pageSize'],
      pageCount: json['pageCount'],
      total: json['total'],
    );
  }
}
