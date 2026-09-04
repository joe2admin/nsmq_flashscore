/// Standard Laravel API response envelope.
/// Matches Laravel's JsonResource / Response pattern:
/// {
///   "success": true,
///   "data": T,
///   "message": "...",
///   "meta": { ... }
/// }
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final ApiPaginationMeta? meta;

  const ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.meta,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic dataJson) fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] ?? true,
      message: json['message'] as String?,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      meta: json['meta'] != null ? ApiPaginationMeta.fromJson(json['meta']) : null,
    );
  }
}

/// Standard Laravel pagination meta
class ApiPaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  const ApiPaginationMeta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory ApiPaginationMeta.fromJson(Map<String, dynamic> json) {
    return ApiPaginationMeta(
      currentPage: json['current_page'] as int? ?? 1,
      lastPage: json['last_page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? 15,
      total: json['total'] as int? ?? 0,
    );
  }
}
