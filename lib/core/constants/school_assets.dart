/// Registry of official school badges/crests and NSMQ branding assets
class SchoolAssets {
  SchoolAssets._();

  static const String nsmqLogo = 'assets/images/nsmq_logo.png';
  static const String nsmqTrophy = 'assets/images/nsmq_trophy.png';

  static const String presec = 'assets/images/schools/presec.png';
  static const String prempeh = 'assets/images/schools/prempeh.jpg';
  static const String mfantsipim = 'assets/images/schools/mfantsipim.png';
  static const String opokuWare = 'assets/images/schools/opoku_ware.png';
  static const String achimota = 'assets/images/schools/achimota.jpg';
  static const String stPeters = 'assets/images/schools/st_peters.png';
  static const String keta = 'assets/images/schools/keta.jpg';
  static const String wesleyGirls = 'assets/images/schools/wesley_girls.jpg';
  static const String stAugustines = 'assets/images/schools/st_augustines.jpg';
  static const String adisadel = 'assets/images/schools/adisadel.gif';
  static const String tamale = 'assets/images/schools/tamale.png';
  static const String kumasiHigh = 'assets/images/schools/kumasi_high.jpg';
  static const String accraAcademy = 'assets/images/schools/accra_academy.jpg';
  static const String popeJohn = 'assets/images/schools/pope_john.png';
  static const String kumasiAcademy = 'assets/images/schools/kumasi_academy.jpg';

  // Additional official crests from nsmq.com.gh
  static const String gsts = 'assets/images/schools/gsts.jpg';
  static const String stThomasAquinas = 'assets/images/schools/st_thomas_aquinas.png';
  static const String stJohns = 'assets/images/schools/st_johns.png';
  static const String brightShs = 'assets/images/schools/bright_shs.png';
  static const String mawuli =
      'https://static.wixstatic.com/media/e4dc52_e779747959d340efafed9e9fc48049c6~mv2.png/v1/crop/x_0,y_34,w_720,h_734/fill/w_151,h_155,al_c,q_85,enc_avif,quality_auto/MAWULI%20CORRECT.png';
  static const String archbishopPorter =
      'https://static.wixstatic.com/media/e4dc52_5d215032b9cc400eb710991c694bc150~mv2.png/v1/fill/w_174,h_174,al_c,q_85,enc_avif,quality_auto/PORTERS-01.png';
  static const String stJames =
      'https://static.wixstatic.com/media/e4dc52_716bdbb17fb946b48aab6f8cb5f1d663~mv2.png/v1/fill/w_177,h_197,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/st%20james.png';
  static const String sunyani =
      'https://static.wixstatic.com/media/e4dc52_0c3d5a29687d429fb50f4c129f93abb1~mv2.png/v1/fill/w_151,h_170,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/Sunyani%20Shs.png';
  static const String bishopHerman =
      'https://static.wixstatic.com/media/e4dc52_1aa99aaf1b13424c9bc2a261040fbb52~mv2.png/v1/fill/w_172,h_172,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/bishop%20herman.png';

  static final Map<String, String> _lookup = {
    // NSMQ OFFICIAL BRANDING
    'nsmq': nsmqLogo,
    'nsmq logo': nsmqLogo,
    'nsmq ghana': nsmqLogo,
    '@nsmqghana': nsmqLogo,
    'official': nsmqLogo,

    // PRESEC
    'sch_presec': presec,
    'presec': presec,
    'presec legon': presec,
    'preseclegon': presec,
    '@preseclegon': presec,
    'presbyterian boys\' secondary school': presec,
    'presbyterian boys\' senior high school': presec,
    'ɔdadeɛ': presec,
    'odade3': presec,
    'odadee': presec,

    // PREMPEH
    'sch_prempeh': prempeh,
    'prempeh': prempeh,
    'prempeh college': prempeh,
    'prempehcollege': prempeh,
    '@prempehcollege': prempeh,
    'sub sanguine signo': prempeh,
    'amanfoo': prempeh,

    // MFANTSIPIM
    'sch_mfantsipim': mfantsipim,
    'mfantsipim': mfantsipim,
    'mfantsipim school': mfantsipim,
    'botwe': mfantsipim,
    'botwe boys': mfantsipim,
    'botweboys': mfantsipim,
    '@botweboys': mfantsipim,
    'dwin hwe kan': mfantsipim,
    'dwen hwe kan': mfantsipim,

    // OPOKU WARE
    'sch_owass': opokuWare,
    'owass': opokuWare,
    'owass (akatakyie)': opokuWare,
    'opoku ware': opokuWare,
    'opoku ware school': opokuWare,
    'owasskatakyie': opokuWare,
    '@owasskatakyie': opokuWare,
    'akatakyie': opokuWare,
    'katakyie': opokuWare,

    // ACHIMOTA
    'sch_achimota': achimota,
    'achimota': achimota,
    'achimota (motown)': achimota,
    'achimota school': achimota,
    'achimotaschool': achimota,
    '@achimotaschool': achimota,
    'motown': achimota,

    // ST. PETERS
    'sch_stpeters': stPeters,
    'st. peter\'s': stPeters,
    'st. peter\'s (persco)': stPeters,
    'st. peter\'s senior high school': stPeters,
    'st. peter\'s boys senior high school': stPeters,
    'persco': stPeters,
    'persconkwatia': stPeters,
    '@persconkwatia': stPeters,

    // KETA
    'sch_keta': keta,
    'keta': keta,
    'keta shts': keta,
    'keta shts (dzolali)': keta,
    'keta senior high tech school': keta,
    'keta senior high technical school': keta,
    'dzolali': keta,
    'ketasco': keta,
    'ketascodzolali': keta,
    '@ketascodzolali': keta,

    // WESLEY GIRLS
    'sch_wesley_girls': wesleyGirls,
    'wesley girls': wesleyGirls,
    'wesley girls\' high school': wesleyGirls,
    'wesley girls\' senior high school': wesleyGirls,
    'wey gey hey': wesleyGirls,
    'weygeyhey': wesleyGirls,
    '@weygeyhey': wesleyGirls,

    // ST. AUGUSTINE'S
    'sch_augustines': stAugustines,
    'st. augustine\'s': stAugustines,
    'st. augustine\'s college': stAugustines,
    'augusco': stAugustines,

    // ADISADEL
    'sch_adisadel': adisadel,
    'adisadel': adisadel,
    'adisadel college': adisadel,
    'adisco': adisadel,
    'adisco (zebra)': adisadel,
    'santa clausian': adisadel,

    // TAMALE
    'sch_tamale': tamale,
    'tamale': tamale,
    'tamale shs': tamale,
    'tamale senior high': tamale,
    'tamale senior high school': tamale,
    'tamasco': tamale,

    // KUMASI HIGH
    'sch_kuhis': kumasiHigh,
    'kumasi high': kumasiHigh,
    'kumasi high school': kumasiHigh,
    'kuhis': kumasiHigh,

    // ACCRA ACADEMY
    'sch_accra_academy': accraAcademy,
    'accra academy': accraAcademy,
    'bleoo': accraAcademy,

    // POPE JOHN
    'sch_pope_john': popeJohn,
    'pope john': popeJohn,
    'pope john senior high': popeJohn,
    'pope john senior high school and minor seminary': popeJohn,
    'pojoss': popeJohn,

    // KUMASI ACADEMY
    'sch_kumasi_academy': kumasiAcademy,
    'kumasi academy': kumasiAcademy,
    'kumaca': kumasiAcademy,

    // GSTS
    'sch_gsts': gsts,
    'gsts': gsts,
    'ghana secondary technical school': gsts,
    'ghana secondary technical': gsts,
    'giants': gsts,

    // ST. THOMAS AQUINAS
    'sch_aquinas': stThomasAquinas,
    'st. thomas aquinas': stThomasAquinas,
    'st thomas aquinas': stThomasAquinas,
    'aquinas': stThomasAquinas,
    'old toms': stThomasAquinas,

    // ST. JOHN'S SCHOOL, SEKONDI
    'sch_st_johns': stJohns,
    'st. john\'s school': stJohns,
    'st johns school': stJohns,
    'st. john\'s': stJohns,
    'st john\'s': stJohns,
    'st johns': stJohns,
    'the saints': stJohns,

    // MAWULI SCHOOL
    'sch_mawuli': mawuli,
    'mawuli': mawuli,
    'mawuli school': mawuli,

    // BISHOP HERMAN
    'sch_bishop_herman': bishopHerman,
    'bishop herman': bishopHerman,
    'bishop herman college': bishopHerman,
    'biheco': bishopHerman,

    // BRIGHT SHS
    'sch_bright_shs': brightShs,
    'bright shs': brightShs,
    'bright senior high': brightShs,
    'bright senior high school': brightShs,
  };

  /// Resolves the badge asset path for a given school by ID, name, or nickname.
  static String? getBadge(String? query) {
    if (query == null || query.trim().isEmpty) return null;
    final normalized = query.toLowerCase().trim();

    // Direct match
    if (_lookup.containsKey(normalized)) {
      return _lookup[normalized];
    }

    // Substring contains match
    for (final entry in _lookup.entries) {
      if (normalized.contains(entry.key) || (entry.key.length >= 4 && entry.key.contains(normalized))) {
        return entry.value;
      }
    }

    // Clean match (stripping @, _, -, spaces, quotes)
    final cleanQuery = normalized.replaceAll(RegExp(r'[@_\s\-]'), '').replaceAll("'", '').replaceAll('"', '');
    if (cleanQuery.isNotEmpty) {
      for (final entry in _lookup.entries) {
        final cleanKey = entry.key.replaceAll(RegExp(r'[@_\s\-]'), '').replaceAll("'", '').replaceAll('"', '');
        if (cleanKey.length >= 4 && (cleanQuery.contains(cleanKey) || cleanKey.contains(cleanQuery))) {
          return entry.value;
        }
      }
    }

    return null;
  }
}
