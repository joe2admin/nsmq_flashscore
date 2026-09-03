/// Breakdown of a school's points across all 5 NSMQ rounds
class RoundScores {
  final int r1; // Round 1: Fundamentals
  final int r2; // Round 2: Speed Race
  final int r3; // Round 3: Problem of the Day (out of 10)
  final int r4; // Round 4: True or False
  final int r5; // Round 5: Riddles
  final int penalties; // Point deductions incurred

  const RoundScores({
    this.r1 = 0,
    this.r2 = 0,
    this.r3 = 0,
    this.r4 = 0,
    this.r5 = 0,
    this.penalties = 0,
  });

  /// Total points accumulated
  int get total => r1 + r2 + r3 + r4 + r5;

  RoundScores copyWith({
    int? r1,
    int? r2,
    int? r3,
    int? r4,
    int? r5,
    int? penalties,
  }) {
    return RoundScores(
      r1: r1 ?? this.r1,
      r2: r2 ?? this.r2,
      r3: r3 ?? this.r3,
      r4: r4 ?? this.r4,
      r5: r5 ?? this.r5,
      penalties: penalties ?? this.penalties,
    );
  }
}
