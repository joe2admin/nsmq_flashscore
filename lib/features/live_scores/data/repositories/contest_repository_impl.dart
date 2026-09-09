import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/contest.dart';
import '../../domain/repositories/i_contest_repository.dart';
import '../models/contest_model.dart';
import '../providers/mock_contest_data.dart';

class ContestRepositoryImpl implements IContestRepository {
  final ApiClient _apiClient;
  final List<Contest> _mockContests = MockContestData.getContests();

  ContestRepositoryImpl({ApiClient? apiClient})
      : _apiClient = apiClient ?? (Get.isRegistered<ApiClient>() ? Get.find<ApiClient>() : ApiClient());

  @override
  Future<List<Contest>> getContests({
    DateTime? date,
    ContestStatus? status,
    String? stage,
    String? searchQuery,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null) {
        queryParams['status'] = status.name;
      }
      if (date != null) {
        queryParams['date'] =
            '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      }
      if (stage != null && stage != 'All Stages') {
        queryParams['stage'] = stage;
      }
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        queryParams['search'] = searchQuery.trim();
      }

      final response = await _apiClient.safeGet(ApiEndpoints.contests, query: queryParams);

      if (response.isOk && response.body != null) {
        final body = response.body;
        final dynamic dataRaw = body is Map ? body['data'] : body;

        if (dataRaw is List) {
          final liveList = dataRaw
              .map((item) => ContestModel.fromJson(item as Map<String, dynamic>))
              .toList();

          return liveList;
        }
      }
    } catch (e) {
      debugPrint('[ContestRepositoryImpl] Backend error, falling back to mock: $e');
    }

    // Fallback to local mock data
    return _mockContests.where((c) {
      if (date != null) {
        final sameDay = c.scheduledAt.year == date.year &&
            c.scheduledAt.month == date.month &&
            c.scheduledAt.day == date.day;
        if (!sameDay) return false;
      }

      if (status != null && c.status != status) {
        return false;
      }

      if (stage != null && stage != 'All Stages' && c.stage != stage) {
        return false;
      }

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final query = searchQuery.trim().toLowerCase();
        final matchesTitle = c.title.toLowerCase().contains(query);
        final matchesStage = c.stage.toLowerCase().contains(query);
        final matchesSchool = c.entries.any((e) =>
            e.school.name.toLowerCase().contains(query) ||
            e.school.shortName.toLowerCase().contains(query));
        if (!matchesTitle && !matchesStage && !matchesSchool) return false;
      }

      return true;
    }).toList();
  }

  @override
  Future<Contest?> getContestById(String id) async {
    try {
      final response = await _apiClient.safeGet(ApiEndpoints.contestDetail(id));
      if (response.isOk && response.body != null) {
        final body = response.body;
        final dynamic dataRaw = body is Map ? body['data'] : body;
        if (dataRaw is Map<String, dynamic>) {
          final contestData = dataRaw['contest'] is Map<String, dynamic>
              ? dataRaw['contest'] as Map<String, dynamic>
              : dataRaw;
          return ContestModel.fromJson(contestData);
        }
      }
    } catch (e) {
      debugPrint('[ContestRepositoryImpl] getContestById backend error: $e');
    }

    try {
      return _mockContests.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
