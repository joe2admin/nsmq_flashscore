import '../../domain/entities/contest.dart';
import '../models/contest_model.dart';
import '../models/round_scores_model.dart';
import '../models/school_model.dart';
import '../../../../core/constants/school_assets.dart';
import '../../../../core/constants/nsmq_constants.dart';

class MockContestData {
  MockContestData._();

  // Reference Schools
  static const schoolPresec = SchoolModel(
    id: 'sch_presec',
    name: 'Presbyterian Boys\' Secondary School',
    shortName: 'PRESEC LEGON',
    region: 'Greater Accra',
    crestUrl: SchoolAssets.presec,
    titlesCount: 8,
  );

  static const schoolPrempeh = SchoolModel(
    id: 'sch_prempeh',
    name: 'Prempeh College',
    shortName: 'PREMPEH',
    region: 'Ashanti',
    crestUrl: SchoolAssets.prempeh,
    titlesCount: 5,
  );

  static const schoolMfantsipim = SchoolModel(
    id: 'sch_mfantsipim',
    name: 'Mfantsipim School',
    shortName: 'MFANTSIPIM',
    region: 'Central',
    crestUrl: SchoolAssets.mfantsipim,
    titlesCount: 4,
  );

  static const schoolStThomasAquinas = SchoolModel(
    id: 'sch_aquinas',
    name: 'St. Thomas Aquinas Senior High School',
    shortName: 'OLD TOMS',
    region: 'Greater Accra',
    crestUrl: SchoolAssets.stThomasAquinas,
    titlesCount: 1,
  );

  static const schoolGsts = SchoolModel(
    id: 'sch_gsts',
    name: 'Ghana Secondary Technical School',
    shortName: 'GSTS (GIANTS)',
    region: 'Western',
    crestUrl: SchoolAssets.gsts,
    titlesCount: 1,
  );

  static const schoolStJohns = SchoolModel(
    id: 'sch_st_johns',
    name: 'St. John\'s School, Sekondi',
    shortName: 'THE SAINTS',
    region: 'Western',
    crestUrl: SchoolAssets.stJohns,
    titlesCount: 0,
  );

  static const schoolBrightShs = SchoolModel(
    id: 'sch_bright_shs',
    name: 'Bright Senior High School',
    shortName: 'BRIGHT SHS',
    region: 'Eastern',
    crestUrl: SchoolAssets.brightShs,
    titlesCount: 0,
  );

  static const schoolKeta = SchoolModel(
    id: 'sch_keta',
    name: 'Keta Senior High Tech School',
    shortName: 'KETA SHTS (DZOLALI)',
    region: 'Volta',
    crestUrl: SchoolAssets.keta,
    titlesCount: 0,
  );

  static const schoolOpokuWare = SchoolModel(
    id: 'sch_owass',
    name: 'Opoku Ware School',
    shortName: 'OWASS (AKATAKYIE)',
    region: 'Ashanti',
    crestUrl: SchoolAssets.opokuWare,
    titlesCount: 2,
  );

  static const schoolAchimota = SchoolModel(
    id: 'sch_achimota',
    name: 'Achimota School',
    shortName: 'ACHIMOTA (MOTOWN)',
    region: 'Greater Accra',
    crestUrl: SchoolAssets.achimota,
    titlesCount: 2,
  );

  static const schoolStPeters = SchoolModel(
    id: 'sch_stpeters',
    name: 'St. Peter\'s Senior High School',
    shortName: 'ST. PETER\'S (PERSCO)',
    region: 'Eastern',
    crestUrl: SchoolAssets.stPeters,
    titlesCount: 3,
  );

  static const schoolWesleyGirls = SchoolModel(
    id: 'sch_wesley_girls',
    name: 'Wesley Girls\' High School',
    shortName: 'WEY GEY HEY',
    region: 'Central',
    crestUrl: SchoolAssets.wesleyGirls,
    titlesCount: 0,
  );

  static const schoolStAugustines = SchoolModel(
    id: 'sch_augustines',
    name: 'St. Augustine\'s College',
    shortName: 'AUGUSCO',
    region: 'Central',
    crestUrl: SchoolAssets.stAugustines,
    titlesCount: 2,
  );

  static const schoolAdisadel = SchoolModel(
    id: 'sch_adisadel',
    name: 'Adisadel College',
    shortName: 'ADISCO (ZEBRA)',
    region: 'Central',
    crestUrl: SchoolAssets.adisadel,
    titlesCount: 1,
  );

  static const schoolTamale = SchoolModel(
    id: 'sch_tamale',
    name: 'Tamale Senior High School',
    shortName: 'TAMASCO',
    region: 'Northern',
    crestUrl: SchoolAssets.tamale,
    titlesCount: 0,
  );

  static const schoolKumasiHigh = SchoolModel(
    id: 'sch_kuhis',
    name: 'Kumasi High School',
    shortName: 'KUHIS',
    region: 'Ashanti',
    crestUrl: SchoolAssets.kumasiHigh,
    titlesCount: 0,
  );

  static const schoolAccraAcademy = SchoolModel(
    id: 'sch_accra_academy',
    name: 'Accra Academy',
    shortName: 'BLEOO',
    region: 'Greater Accra',
    crestUrl: SchoolAssets.accraAcademy,
    titlesCount: 0,
  );

  static const schoolPopeJohn = SchoolModel(
    id: 'sch_pope_john',
    name: 'Pope John Senior High School and Minor Seminary',
    shortName: 'POJOSS',
    region: 'Eastern',
    crestUrl: SchoolAssets.popeJohn,
    titlesCount: 1,
  );

  static const schoolKumasiAcademy = SchoolModel(
    id: 'sch_kumasi_academy',
    name: 'Kumasi Academy',
    shortName: 'KUMACA',
    region: 'Ashanti',
    crestUrl: SchoolAssets.kumasiAcademy,
    titlesCount: 0,
  );

  static List<ContestModel> getContests() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, 14, 0);
    final finaleDate = DateTime(2026, 9, 10, 14, 0);

    return [
      // 1. LIVE CONTEST: Grand Finale Live Broadcast (Round 4 True/False)
      ContestModel(
        id: 'contest_live_101',
        title: 'Grand Finale Live',
        stage: 'Grand Finale',
        scheduledAt: today,
        status: ContestStatus.live,
        currentRound: 4,
        currentRoundName: 'Round 4: Jupay True/False',
        liveAudioUrl: NsmqConstants.defaultLiveAudioStream,
        entries: [
          ContestantEntryModel(
            school: schoolPresec,
            scores: RoundScoresModel(r1: 18, r2: 12, r3: 10, r4: 8, r5: 0),
          ),
          ContestantEntryModel(
            school: schoolStAugustines,
            scores: RoundScoresModel(r1: 16, r2: 14, r3: 7, r4: 6, r5: 0),
          ),
          ContestantEntryModel(
            school: schoolAccraAcademy,
            scores: RoundScoresModel(r1: 15, r2: 11, r3: 8, r4: 7, r5: 0),
          ),
        ],
      ),

      // 2. UPCOMING: Official NSMQ 2026 Grand Finale at UG Premier Domes
      ContestModel(
        id: 'contest_sched_106',
        title: '2026 Grand Finale Climax',
        stage: 'Grand Finale',
        scheduledAt: finaleDate,
        status: ContestStatus.scheduled,
        currentRound: 0,
        currentRoundName: 'UG Premier Domes • 14:00 GMT',
        entries: [
          ContestantEntryModel(
            school: schoolPresec,
            scores: RoundScoresModel(),
          ),
          ContestantEntryModel(
            school: schoolStAugustines,
            scores: RoundScoresModel(),
          ),
          ContestantEntryModel(
            school: schoolAccraAcademy,
            scores: RoundScoresModel(),
          ),
        ],
      ),

      // 3. FINISHED: Semi-Final 3 (Historical Qualification for Accra Academy)
      ContestModel(
        id: 'contest_fin_sf3',
        title: 'Semi-Final Contest 3',
        stage: 'Semi-Finals',
        scheduledAt: DateTime(2026, 9, 3, 17, 0),
        status: ContestStatus.finished,
        currentRound: 5,
        currentRoundName: 'Accra Academy Maiden Finale Qualification',
        entries: [
          ContestantEntryModel(
            school: schoolAccraAcademy,
            scores: RoundScoresModel(r1: 16, r2: 12, r3: 10, r4: 13, r5: 3),
            isWinner: true,
          ),
          ContestantEntryModel(
            school: schoolBrightShs,
            scores: RoundScoresModel(r1: 8, r2: 7, r3: 10, r4: 16, r5: 3),
          ),
          ContestantEntryModel(
            school: schoolAchimota,
            scores: RoundScoresModel(r1: 16, r2: 1, r3: 10, r4: 10, r5: 4),
          ),
        ],
      ),

      // 4. FINISHED: Semi-Final 2 (PRESEC Returns to Finale after 2 years)
      ContestModel(
        id: 'contest_fin_sf2',
        title: 'Semi-Final Contest 2',
        stage: 'Semi-Finals',
        scheduledAt: DateTime(2026, 9, 3, 14, 0),
        status: ContestStatus.finished,
        currentRound: 5,
        currentRoundName: 'PRESEC Storms to Finals',
        entries: [
          ContestantEntryModel(
            school: schoolPresec,
            scores: RoundScoresModel(r1: 19, r2: 4, r3: 2, r4: 10, r5: 9),
            isWinner: true,
          ),
          ContestantEntryModel(
            school: schoolStJohns,
            scores: RoundScoresModel(r1: 15, r2: 6, r3: 0, r4: 5, r5: -1),
          ),
          ContestantEntryModel(
            school: schoolTamale,
            scores: RoundScoresModel(r1: 7, r2: 2, r3: 0, r4: 7, r5: 0),
          ),
        ],
      ),

      // 5. FINISHED: Semi-Final 1 (St. Augustine's edges Prempeh College)
      ContestModel(
        id: 'contest_fin_sf1',
        title: 'Semi-Final Contest 1',
        stage: 'Semi-Finals',
        scheduledAt: DateTime(2026, 9, 3, 10, 0),
        status: ContestStatus.finished,
        currentRound: 5,
        currentRoundName: 'Augusco Reaches 3rd Consecutive Finale',
        entries: [
          ContestantEntryModel(
            school: schoolStAugustines,
            scores: RoundScoresModel(r1: 15, r2: 15, r3: 0, r4: 10, r5: 12),
            isWinner: true,
          ),
          ContestantEntryModel(
            school: schoolPrempeh,
            scores: RoundScoresModel(r1: 17, r2: 11, r3: 6, r4: 8, r5: 5),
          ),
          ContestantEntryModel(
            school: schoolPopeJohn,
            scores: RoundScoresModel(r1: 12, r2: 6, r3: 2, r4: 5, r5: 3),
          ),
        ],
      ),

      // 6. FINISHED: Quarter-Final 6 (Highest Winning Score of QF Stage: 56 pts)
      ContestModel(
        id: 'contest_fin_qf6',
        title: 'Quarter-Final Contest 6',
        stage: 'Quarter-Finals',
        scheduledAt: DateTime(2026, 8, 31, 16, 0),
        status: ContestStatus.finished,
        currentRound: 5,
        currentRoundName: 'PRESEC 56 Pts Masterclass',
        entries: [
          ContestantEntryModel(
            school: schoolPresec,
            scores: RoundScoresModel(r1: 21, r2: 14, r3: 5, r4: 10, r5: 6),
            isWinner: true,
          ),
          ContestantEntryModel(
            school: schoolMfantsipim,
            scores: RoundScoresModel(r1: 16, r2: 8, r3: 3, r4: 6, r5: 6),
          ),
          ContestantEntryModel(
            school: schoolAchimota,
            scores: RoundScoresModel(r1: 11, r2: 5, r3: 2, r4: 4, r5: 2),
          ),
        ],
      ),
    ];
  }
}
