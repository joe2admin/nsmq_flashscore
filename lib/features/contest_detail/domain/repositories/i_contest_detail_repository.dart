import '../entities/contest_detail.dart';

abstract class IContestDetailRepository {
  Future<ContestDetail> getContestDetail(String contestId);
}
