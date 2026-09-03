/// NSMQ Official Rules and Round Constants
class NsmqConstants {
  NsmqConstants._();

  static const String appName = 'NSMQ FLASHSCORE';

  // Round Names
  static const String round1Name = 'Round 1: Fundamentals';
  static const String round2Name = 'Round 2: The Speed Race';
  static const String round3Name = 'Round 3: Problem of the Day';
  static const String round4Name = 'Round 4: True or False';
  static const String round5Name = 'Round 5: Riddles';

  // Scoring Rules
  static const int r1DirectPoints = 3;
  static const int r1BonusPoints = 1;
  static const int r2CorrectPoints = 3;
  static const int r2PenaltyPoints = -1;
  static const int r3MaxPoints = 10;
  static const int r4CorrectPoints = 2;
  static const int r4PenaltyPoints = -1;
  static const int r5Clue1Points = 5;
  static const int r5Clue2Points = 4;
  static const int r5Clue3Points = 3;

  // Stages
  static const List<String> stages = [
    'Regional Qualifiers',
    'Preliminary Stage',
    'One-Eighth Stage',
    'Quarter-Finals',
    'Semi-Finals',
    'Grand Finale',
  ];
}
