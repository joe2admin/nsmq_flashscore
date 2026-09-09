import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../constants/api_endpoints.dart';
import '../services/device_service.dart';

/// Central HTTP API Client powered by GetConnect.
/// Configured with LAN base URL, headers, JSON serialization, and automatic X-Device-Id header.
class ApiClient extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = ApiEndpoints.baseUrl;
    httpClient.timeout = const Duration(seconds: 8);

    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/json';
      request.headers['X-Device-Id'] = DeviceService.deviceId;
      return request;
    });

    super.onInit();
  }

  /// Safe GET request with automatic error suppression and fallback handling
  Future<Response<T>> safeGet<T>(String url, {Map<String, dynamic>? query}) async {
    try {
      return await get<T>(url, query: query);
    } catch (e) {
      debugPrint('[ApiClient] GET $url network error: $e');
      return Response<T>(statusCode: null, statusText: e.toString());
    }
  }

  /// Safe POST request with automatic error suppression and fallback handling
  Future<Response<T>> safePost<T>(String url, dynamic body, {Map<String, dynamic>? query}) async {
    try {
      return await post<T>(url, body, query: query);
    } catch (e) {
      debugPrint('[ApiClient] POST $url network error: $e');
      return Response<T>(statusCode: null, statusText: e.toString());
    }
  }

  /// Safe DELETE request with automatic error suppression and fallback handling
  Future<Response<T>> safeDelete<T>(String url, {Map<String, dynamic>? query}) async {
    try {
      return await delete<T>(url, query: query);
    } catch (e) {
      debugPrint('[ApiClient] DELETE $url network error: $e');
      return Response<T>(statusCode: null, statusText: e.toString());
    }
  }
}
