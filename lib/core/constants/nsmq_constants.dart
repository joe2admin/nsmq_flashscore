/// NSMQ Official Rules and Round Constants
class NsmqConstants {
  NsmqConstants._();

  static const String appName = 'NSMQ FLASHSCORE';

  // Round Names (Official NSMQ 2026 Sponsorships)
  static const String round1Name = 'Round 1: General Questions';
  static const String round2Name = 'Round 2: Trustur AI Speed Race';
  static const String round3Name = 'Round 3: Prudential Life NSMQ Star (Problem of the Day)';
  static const String round4Name = 'Round 4: Jupay True/False';
  static const String round5Name = 'Round 5: GOIL Super Bonanza (Riddles)';

  // Venues
  static const String venueQuarterSemiFinals = 'Main Auditorium, UCC, Cape Coast';
  static const String venueGrandFinale = 'UG Premier Domes, University of Ghana, Legon';

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

  // Official Awards & Prize Values
  static const String prudentialNsmqStarPrize = 'GH¢3,400';
  static const String jupayCleanSheetPrize = 'GH¢1,500';
  static const String pepsodentHighestScorerPrize = 'GH¢3,000';
  static const String goilSuperBonanzaRiddlePrize = 'GH¢600 per riddle';

  // Stages
  static const List<String> stages = [
    'Regional Qualifiers',
    'Preliminary Stage',
    'One-Eighth Stage',
    'Quarter-Finals',
    'Semi-Finals',
    'Grand Finale',
  ];

  // Live Audio Broadcast
  static const String defaultLiveAudioStream = 'https://stream.zeno.fm/t3q5zg84n7zuv';
  static const String defaultAudioStationName = 'JOY 99.7 FM • NSMQ LIVE FEED';
}
