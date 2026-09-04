import 'package:nsmq_flashscore/features/live_scores/data/providers/mock_contest_data.dart';
import 'package:nsmq_flashscore/features/schools/domain/entities/school_profile.dart';
import 'package:nsmq_flashscore/features/schools/domain/repositories/i_schools_repository.dart';

class SchoolsRepositoryImpl implements ISchoolsRepository {
  final List<SchoolProfile> _schools = [
    SchoolProfile(
      school: MockContestData.schoolPresec,
      motto: 'Happy Are The Pure In Heart',
      foundedYear: '1938',
      city: 'Legon, Accra',
      championshipYears: [1995, 2003, 2006, 2008, 2009, 2020, 2022, 2023],
      finalsAppearances: 12,
      totalContestsWon: 98,
      highestScoreRecord: '82 points (2021)',
      notableContestants: ['Kwabena Mantey', 'Selorm Ohene-Amoani', 'Daniel Kekeli Gakpetor'],
      isFavorite: true,
    ),
    SchoolProfile(
      school: MockContestData.schoolPrempeh,
      motto: 'Sub Sanguine Signo (Under The Sign Of The Blood)',
      foundedYear: '1949',
      city: 'Kumasi',
      championshipYears: [1994, 1996, 2015, 2017, 2021],
      finalsAppearances: 9,
      totalContestsWon: 85,
      highestScoreRecord: '76 points (2017)',
      notableContestants: ['Wonder Sarfo-Ansah', 'Daniel Osei Badu', 'Evans Quaye'],
      isFavorite: true,
    ),
    SchoolProfile(
      school: MockContestData.schoolStPeters,
      motto: 'Dignitas Honestas (Dignity and Honesty)',
      foundedYear: '1957',
      city: 'Nkwatia, Kwahu',
      championshipYears: [2000, 2005, 2018],
      finalsAppearances: 8,
      totalContestsWon: 68,
      highestScoreRecord: '74 points (2018)',
      notableContestants: ['Kissinger Agyeman', 'Fenny Wonder'],
    ),
    SchoolProfile(
      school: MockContestData.schoolMfantsipim,
      motto: 'Dwin Hwe Kan (Think and Look Ahead)',
      foundedYear: '1876',
      city: 'Cape Coast',
      championshipYears: [1999, 2014, 2024, 2025],
      finalsAppearances: 9,
      totalContestsWon: 76,
      highestScoreRecord: '72 points (2014)',
      notableContestants: ['Isaac Mensah', 'Benjamin Kwofie', 'Botwe 2025 Champions'],
      isFavorite: true,
    ),
    SchoolProfile(
      school: MockContestData.schoolOpokuWare,
      motto: 'Deus Lux Mea (God is My Light)',
      foundedYear: '1952',
      city: 'Santasi, Kumasi',
      championshipYears: [1997, 2002],
      finalsAppearances: 9,
      totalContestsWon: 62,
      highestScoreRecord: '69 points (2020)',
      notableContestants: ['Nana Yaw Boakye', 'Stephen Kwarteng'],
    ),
    SchoolProfile(
      school: MockContestData.schoolAchimota,
      motto: 'Ut Omnes Unum Sint (That All May Be One)',
      foundedYear: '1927',
      city: 'Achimota, Accra',
      championshipYears: [1998, 2004],
      finalsAppearances: 6,
      totalContestsWon: 56,
      highestScoreRecord: '66 points (2004)',
      notableContestants: ['Kwesi Johnson', 'Eleni Amegashie'],
    ),
    SchoolProfile(
      school: MockContestData.schoolStAugustines,
      motto: 'Omnia Vincit Labor (Perseverance Conquers All)',
      foundedYear: '1930',
      city: 'Cape Coast',
      championshipYears: [2007, 2019],
      finalsAppearances: 6,
      totalContestsWon: 58,
      highestScoreRecord: '71 points (2019)',
      notableContestants: ['Nathaniel Mawuli', 'Anthony Newton', 'Augusco 2026 Finalists'],
      isFavorite: true,
    ),
    SchoolProfile(
      school: MockContestData.schoolAdisadel,
      motto: 'Vel Primus Vel Cum Primis (Either The First Or With The First)',
      foundedYear: '1910',
      city: 'Cape Coast',
      championshipYears: [2016],
      finalsAppearances: 5,
      totalContestsWon: 49,
      highestScoreRecord: '68 points (2016)',
      notableContestants: ['Philip Prempeh', 'Emmanuel Kojo'],
    ),
    SchoolProfile(
      school: MockContestData.schoolStThomasAquinas,
      motto: 'Veritas Liberat (The Truth Shall Set You Free)',
      foundedYear: '1952',
      city: 'Cantonments, Accra',
      championshipYears: [2013],
      finalsAppearances: 2,
      totalContestsWon: 45,
      highestScoreRecord: '68 points (2013)',
      notableContestants: ['Philip Gyamfi', 'Aquinas Champions 2013'],
    ),
    SchoolProfile(
      school: MockContestData.schoolGsts,
      motto: 'Mente et Manu (With Mind and Hand)',
      foundedYear: '1909',
      city: 'Takoradi',
      championshipYears: [2012],
      finalsAppearances: 3,
      totalContestsWon: 50,
      highestScoreRecord: '65 points (2012)',
      notableContestants: ['GSTS Champions 2012'],
    ),
    SchoolProfile(
      school: MockContestData.schoolPopeJohn,
      motto: 'Vela Damus (We Set Sail)',
      foundedYear: '1958',
      city: 'Effiduase, Koforidua',
      championshipYears: [2001],
      finalsAppearances: 3,
      totalContestsWon: 48,
      highestScoreRecord: '67 points (2001)',
      notableContestants: ['Dominic Asamoah', 'Samuel Ofori'],
    ),
    SchoolProfile(
      school: MockContestData.schoolAccraAcademy,
      motto: 'Esse Quam Videri (To Be, Rather Than To Seem)',
      foundedYear: '1931',
      city: 'Bubuashie, Accra',
      championshipYears: [],
      finalsAppearances: 1,
      totalContestsWon: 44,
      highestScoreRecord: '54 points (2026)',
      notableContestants: ['Nana Yaw Adu (Coord)', 'Bleoo 2026 Finalists'],
      isFavorite: true,
    ),
    SchoolProfile(
      school: MockContestData.schoolBrightShs,
      motto: 'Excellence Through Discipline',
      foundedYear: '2008',
      city: 'Kukurantumi, Eastern Region',
      championshipYears: [],
      finalsAppearances: 0,
      totalContestsWon: 18,
      highestScoreRecord: '44 points (2026)',
      notableContestants: ['Mercy Adjeley Okang', 'Franklin Ebo Odum (Coord)'],
    ),
    SchoolProfile(
      school: MockContestData.schoolStJohns,
      motto: 'Viam Parate (Prepare the Way)',
      foundedYear: '1952',
      city: 'Sekondi, Western Region',
      championshipYears: [],
      finalsAppearances: 0,
      totalContestsWon: 34,
      highestScoreRecord: '43 points (2026)',
      notableContestants: ['Michael Obeng (Coord)', 'The Saints 75th Anniv Squad'],
    ),
    SchoolProfile(
      school: MockContestData.schoolKeta,
      motto: 'Dzolali (Fly Ahead)',
      foundedYear: '1953',
      city: 'Keta, Volta Region',
      championshipYears: [],
      finalsAppearances: 2,
      totalContestsWon: 42,
      highestScoreRecord: '68 points (2021)',
      notableContestants: ['Francisca Lamini', 'James Lutterodt', 'Bright Senyo'],
      isFavorite: true,
    ),
    SchoolProfile(
      school: MockContestData.schoolWesleyGirls,
      motto: 'Live Pure, Speak True, Right Wrong',
      foundedYear: '1836',
      city: 'Cape Coast',
      championshipYears: [],
      finalsAppearances: 3,
      totalContestsWon: 44,
      highestScoreRecord: '63 points (2019)',
      notableContestants: ['Naa Korkoi', 'Abena Pokua'],
    ),
    SchoolProfile(
      school: MockContestData.schoolTamale,
      motto: 'Fortiter, Fideliter, Feliciter (Bravely, Faithfully, Happily)',
      foundedYear: '1951',
      city: 'Tamale',
      championshipYears: [],
      finalsAppearances: 0,
      totalContestsWon: 38,
      highestScoreRecord: '59 points (2020)',
      notableContestants: ['Alhassan Musah', 'Mohammed Amin', 'William James Akampulimba (Coord)'],
    ),
    SchoolProfile(
      school: MockContestData.schoolKumasiHigh,
      motto: 'Truth and Virtue',
      foundedYear: '1962',
      city: 'Gyinyase, Kumasi',
      championshipYears: [],
      finalsAppearances: 2,
      totalContestsWon: 42,
      highestScoreRecord: '62 points (2022)',
      notableContestants: ['Richmond Owusu', 'Kwame Boateng'],
    ),
    SchoolProfile(
      school: MockContestData.schoolKumasiAcademy,
      motto: 'It Matters Not How Long You Live But How Well',
      foundedYear: '1957',
      city: 'Asokore Mampong, Kumasi',
      championshipYears: [],
      finalsAppearances: 1,
      totalContestsWon: 32,
      highestScoreRecord: '56 points (2021)',
      notableContestants: ['Kofi Antwi', 'Yaw Sarfo'],
    ),
  ];

  @override
  Future<List<SchoolProfile>> getSchools({
    String? searchQuery,
    String? region,
    bool onlyChampions = false,
  }) async {
    await Future.delayed(const Duration(milliseconds: 150));

    return _schools.where((p) {
      if (onlyChampions && p.school.titlesCount == 0) return false;

      if (region != null && region != 'All Regions' && p.school.region != region) {
        return false;
      }

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.toLowerCase().trim();
        final matchesName = p.school.name.toLowerCase().contains(q);
        final matchesShort = p.school.shortName.toLowerCase().contains(q);
        final matchesCity = p.city.toLowerCase().contains(q);
        if (!matchesName && !matchesShort && !matchesCity) return false;
      }

      return true;
    }).toList();
  }

  @override
  Future<SchoolProfile?> getSchoolById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _schools.firstWhere((p) => p.school.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> toggleFavorite(String id) async {
    final index = _schools.indexWhere((p) => p.school.id == id);
    if (index != -1) {
      _schools[index] = _schools[index].copyWith(
        isFavorite: !_schools[index].isFavorite,
      );
    }
  }

  @override
  Future<List<SchoolProfile>> getFavoriteSchools() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _schools.where((p) => p.isFavorite).toList();
  }
}
