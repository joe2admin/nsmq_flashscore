import 'package:nsmq_flashscore/app/theme/app_colors.dart';
import 'package:nsmq_flashscore/core/constants/school_assets.dart';
import 'package:nsmq_flashscore/features/news/domain/entities/feed_post.dart';
import 'package:nsmq_flashscore/features/news/domain/entities/news_article.dart';
import 'package:nsmq_flashscore/features/news/domain/repositories/i_news_repository.dart';

class NewsRepositoryImpl implements INewsRepository {
  List<FeedPost> _posts = [];

  NewsRepositoryImpl() {
    _initMockPosts();
  }

  void _initMockPosts() {
    _posts = [
      // 1. Official Breaking Results Dispatch with Image
      FeedPost(
        id: 'post_1',
        authorName: 'NSMQ Ghana',
        authorHandle: '@NSMQGhana',
        authorInitials: 'NS',
        authorColor: NeoColors.nsmqRed,
        isVerified: true,
        authorRole: 'OFFICIAL',
        category: 'OFFICIAL',
        crestUrl: SchoolAssets.nsmqLogo,
        timeAgo: '4m',
        content:
            '🚨 OFFICIAL FINAL SCORES • SEMI-FINAL CONTEST 3:\n\n'
            '🟡 Accra Academy: 54 pts\n'
            '🟢 Bright SHS: 44 pts\n'
            '⚪ Achimota School: 41 pts\n\n'
            'HISTORY MADE! Accra Academy clinches their FIRST-EVER NSMQ Grand Finale spot, sweeps GH¢8,800 in awards, and joins PRESEC & AUGUSCO for the ultimate crown! 💛⚡\n\n'
            '#NSMQ2026 #Bleoo #AccraAcademy #NationalChampionship',
        imageUrl: 'https://i.ytimg.com/vi/ls1QJrKe_qY/maxresdefault.jpg',
        imageCaption: 'Accra Academy celebrating historic qualification at UCC Main Auditorium',
        imageAspectRatio: 16 / 9,
        likesCount: 1420,
        commentsCount: 238,
        sharesCount: 512,
        isLiked: false,
        isRetweeted: false,
        comments: [
          FeedComment(
            id: 'c1_1',
            authorName: 'Kofi Mensah',
            authorHandle: '@kofi_mensah',
            authorInitials: 'KM',
            authorColor: NeoColors.nsmqBlue,
            content: '68 points in 1/8th stage?! Blue Magicians are not playing games this year! 🔥🦁',
            timeAgo: '2m',
            likesCount: 45,
          ),
          FeedComment(
            id: 'c1_2',
            authorName: 'Akosua Frimpong',
            authorHandle: '@akosua_f',
            authorInitials: 'AF',
            authorColor: NeoColors.nsmqElectricBlue,
            content: 'Achimota tried in Round 2, but Presec’s speed in Round 5 was simply untouchable.',
            timeAgo: '1m',
            likesCount: 18,
          ),
        ],
      ),

      // 2. Interactive Twitter Poll / Quiz
      FeedPost(
        id: 'post_2',
        authorName: 'NSMQ Ghana',
        authorHandle: '@NSMQGhana',
        authorInitials: 'NS',
        authorColor: NeoColors.nsmqRed,
        isVerified: true,
        authorRole: 'OFFICIAL',
        category: 'POLLS',
        crestUrl: SchoolAssets.nsmqLogo,
        timeAgo: '22m',
        content:
            '⚡ DAILY FAN RIDDLE & PROBLEM OF THE DAY:\n\n'
            'An ideal transformer has 500 turns in the primary coil and 50 turns in the secondary coil. If primary voltage is 240V AC, what is the secondary output voltage?\n\n'
            'Can you solve it before Round 3 buzzer? Test your physics IQ! 👇🔬',
        likesCount: 890,
        commentsCount: 94,
        sharesCount: 130,
        isLiked: false,
        isRetweeted: false,
        poll: const FeedPoll(
          question: 'Secondary output voltage:',
          isQuiz: true,
          explanation: 'Formula: Vs = Vp × (Ns / Np) = 240V × (50 / 500) = 24V AC.',
          totalVotes: 3420,
          options: [
            FeedPollOption(id: 'opt_1', text: 'A) 12V AC', votes: 410, isCorrect: false),
            FeedPollOption(id: 'opt_2', text: 'B) 24V AC', votes: 2390, isCorrect: true),
            FeedPollOption(id: 'opt_3', text: 'C) 48V AC', votes: 480, isCorrect: false),
            FeedPollOption(id: 'opt_4', text: 'D) 2400V AC', votes: 140, isCorrect: false),
          ],
        ),
        comments: [
          FeedComment(
            id: 'c2_1',
            authorName: 'Physics Geek Gh',
            authorHandle: '@sci_ghana',
            authorInitials: 'PG',
            authorColor: NeoColors.green,
            content: 'Direct step-down transformer formula: Vs = Vp * (Ns/Np). Easy 24V! 💡',
            timeAgo: '15m',
            likesCount: 32,
          ),
        ],
      ),

      // 3. Quiz Mistress Commentary
      FeedPost(
        id: 'post_3',
        authorName: 'Prof. Elsie Kaufmann',
        authorHandle: '@elsie_kaufmann',
        authorInitials: 'EK',
        authorColor: NeoColors.nsmqElectricBlue,
        isVerified: true,
        authorRole: 'QUIZ MISTRESS',
        category: 'OFFICIAL',
        timeAgo: '1h',
        content:
            'Truly impressed by the speed and accuracy in Round 4 riddles today. Answering organic chemistry riddles on Clue 1 requires supreme discipline and split-second deduction under immense national spotlight. Congratulations to all 3 teams! 👏✨\n\n'
            '#NSMQ2024 #WomenInSTEM #ExcellenceInScience',
        imageUrl: 'https://images.unsplash.com/photo-1577896851231-70ef18881754?q=80&w=1000&auto=format&fit=crop',
        imageCaption: 'Quiz Mistress podium at the Saarah-Mensah Auditorium',
        imageAspectRatio: 16 / 9,
        likesCount: 3120,
        commentsCount: 184,
        sharesCount: 420,
        isLiked: true,
        isRetweeted: false,
        comments: [
          FeedComment(
            id: 'c3_1',
            authorName: 'Ebenezer Quaye',
            authorHandle: '@ebenezer_q',
            authorInitials: 'EQ',
            authorColor: NeoColors.gold,
            content: 'Mama Elsie your bell has ended many dreams today 😂 Still the best host on African television!',
            timeAgo: '45m',
            likesCount: 89,
          ),
        ],
      ),

      // 4. School Banter - PRESEC Legon
      FeedPost(
        id: 'post_4',
        authorName: 'PRESEC Legon Ɔdadeɛ',
        authorHandle: '@PresecLegon',
        authorInitials: 'PL',
        authorColor: NeoColors.nsmqBlue,
        isVerified: true,
        authorRole: '8x CHAMPIONS',
        category: 'LIVE BUZZ',
        schoolId: 'sch_presec',
        crestUrl: SchoolAssets.presec,
        timeAgo: '20h',
        content:
            'When the bell rings, blue magic speaks. 🔵🦁\n\n'
            'We held our nerve against St. John’s School and Tamale SHS to finish with 44 points and return to the Grand Finale after two years! Next stop: UG Premier Domes on September 10! The 9th trophy is calling... 🏆\n\n'
            '#PresecLegon #BlueMagic #NineLoading #NSMQ2026 #GrandFinaleBound',
        imageUrl: 'https://i.ytimg.com/vi/pR9E7vwtdqk/maxresdefault.jpg',
        imageCaption: 'PRESEC squad celebrating their return to the Grand Finale',
        imageAspectRatio: 16 / 9,
        likesCount: 2840,
        commentsCount: 390,
        sharesCount: 780,
        isLiked: false,
        isRetweeted: false,
        comments: [
          FeedComment(
            id: 'c4_1',
            authorName: 'Augusco Warrior',
            authorHandle: '@augusco_spirit',
            authorInitials: 'AW',
            authorColor: NeoColors.green,
            content: 'Meet us at the UG Premier Domes. St. Augustine\'s is taking trophy #3 home to Cape Coast! 🟢',
            timeAgo: '18h',
            likesCount: 52,
          ),
          FeedComment(
            id: 'c4_2',
            authorName: 'Bleoo Boy',
            authorHandle: '@accra_aca_rep',
            authorInitials: 'BB',
            authorColor: NeoColors.gold,
            content: 'Accra Academy is in our first-ever final. Bleoo will shock the whole nation on September 10! 🟡',
            timeAgo: '16h',
            likesCount: 74,
          ),
        ],
      ),

      // 5. Semi-Final 1 - St. Augustine's College
      FeedPost(
        id: 'post_5',
        authorName: 'St. Augustine\'s College AUGUSCO',
        authorHandle: '@AuguscoOfficial',
        authorInitials: 'SA',
        authorColor: NeoColors.green,
        isVerified: true,
        authorRole: '2x CHAMPIONS',
        category: 'LIVE BUZZ',
        schoolId: 'sch_augustines',
        crestUrl: SchoolAssets.stAugustines,
        timeAgo: '22h',
        content:
            'MONICA NE MBA! 🟢⚪\n\n'
            'In an unforgettable Semi-Final 1 clash at the UCC Main Auditorium, St. Augustine’s College finishes on 52 points to defeat Prempeh College (47 pts) and Pope John (28 pts)! 3rd consecutive Grand Finale booked! 🏆\n\n'
            '#Augusco #MonicaNeMba #NSMQ2026 #RoadTo3',
        imageUrl: 'https://i.ytimg.com/vi/6-psEFHp-14/maxresdefault.jpg',
        imageCaption: 'St. Augustine\'s College sealing their 52-point semi-final triumph',
        imageAspectRatio: 16 / 9,
        likesCount: 2980,
        commentsCount: 460,
        sharesCount: 510,
        isLiked: false,
        isRetweeted: false,
        comments: [
          FeedComment(
            id: 'c5_1',
            authorName: 'Amanfoo Alum',
            authorHandle: '@prempeh_alum',
            authorInitials: 'AA',
            authorColor: NeoColors.gold,
            content: 'Painful exit by 5 points... Congratulations Augusco. Go represent the green and yellow with pride! 🟢',
            timeAgo: '21h',
            likesCount: 68,
          ),
        ],
      ),

      // 6. Keta SHTS "Dzolali" Feature with Photo
      FeedPost(
        id: 'post_6',
        authorName: 'Keta SHTS Dzolali',
        authorHandle: '@KetascoDzolali',
        authorInitials: 'KS',
        authorColor: NeoColors.nsmqElectricBlue,
        isVerified: true,
        authorRole: 'VOLTA GIANTS',
        category: 'PHOTOS',
        schoolId: 'sch_keta',
        crestUrl: SchoolAssets.keta,
        timeAgo: '6h',
        content:
            'Fly Now or Never! 🦅⚡\n\n'
            'Final strategy revision completed at the KNUST campus. The Dzolali contingent is focused, unified, and geared up for Thursday\'s clash. Volta to the world!\n\n'
            '#Ketasco #Dzolali #VoltaExcellence #NSMQ2024',
        imageUrl: 'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?q=80&w=1000&auto=format&fit=crop',
        imageCaption: 'The Ketasco squad in high spirits during prep',
        imageAspectRatio: 16 / 9,
        likesCount: 2210,
        commentsCount: 145,
        sharesCount: 388,
        isLiked: false,
        isRetweeted: false,
        comments: [
          FeedComment(
            id: 'c6_1',
            authorName: 'Mawuli Fan',
            authorHandle: '@volta_pride',
            authorInitials: 'VF',
            authorColor: NeoColors.nsmqBlue,
            content: 'The whole Volta Region is standing behind Dzolali! Bring the trophy home! 🦅🇬🇭',
            timeAgo: '5h',
            likesCount: 78,
          ),
        ],
      ),

      // 7. Stats & Trivia Post
      FeedPost(
        id: 'post_7',
        authorName: 'NSMQ Stats & Analytics',
        authorHandle: '@NSMQStats',
        authorInitials: 'SA',
        authorColor: NeoColors.darkCanvas,
        isVerified: true,
        authorRole: 'ANALYTICS',
        category: 'LIVE BUZZ',
        timeAgo: '8h',
        content:
            '📊 STAT OF THE DAY:\n\n'
            'Across 42 contests so far in #NSMQ2024, teams buzzing on Clue 1 in Round 5 have converted 71.4% of attempts for maximum 5 points. However, wrong buzzes incurred -1 penalty in 18 instances.\n\n'
            'High risk, monumental reward. Speed wins championships.',
        likesCount: 760,
        commentsCount: 38,
        sharesCount: 195,
        isLiked: false,
        isRetweeted: false,
        comments: [],
      ),

      // 8. Opoku Ware School (OWASS) Banter with Photo
      FeedPost(
        id: 'post_8',
        authorName: 'Opoku Ware School Katakyie',
        authorHandle: '@OWASSKatakyie',
        authorInitials: 'OW',
        authorColor: NeoColors.gold,
        isVerified: true,
        authorRole: '2x CHAMPIONS',
        category: 'LIVE BUZZ',
        schoolId: 'sch_owass',
        crestUrl: SchoolAssets.opokuWare,
        timeAgo: '9h',
        content:
            'The \'Akesie\' has awakened! 🟡🦅\n\n'
            'To Prempeh College and Botwe: we heard all the noise in Kumasi today. Tomorrow on the KNUST stage, only pure science and math speak. Katakyie to the bone!\n\n'
            '#OWASS #Katakyie #AshantiDerby #NSMQ2024',
        imageUrl: 'https://images.unsplash.com/photo-1543269865-cbf427effbad?q=80&w=1000&auto=format&fit=crop',
        imageCaption: 'Katakyie contingent arriving at the KNUST auditorium',
        imageAspectRatio: 16 / 9,
        likesCount: 1940,
        commentsCount: 210,
        sharesCount: 350,
        isLiked: false,
        isRetweeted: false,
        comments: [
          FeedComment(
            id: 'c8_1',
            authorName: 'Amanfoo Warrior',
            authorHandle: '@green_machine',
            authorInitials: 'AW',
            authorColor: NeoColors.green,
            content: 'Keep that same energy when Round 2 speed race begins! 🟢',
            timeAgo: '8h',
            likesCount: 34,
          ),
        ],
      ),

      // 9. Achimota School Grace & Reflection
      FeedPost(
        id: 'post_9',
        authorName: 'Achimota School Motown',
        authorHandle: '@AchimotaSchool',
        authorInitials: 'AS',
        authorColor: NeoColors.darkCanvas,
        isVerified: true,
        authorRole: '2x CHAMPIONS',
        category: 'LIVE BUZZ',
        schoolId: 'sch_achimota',
        crestUrl: SchoolAssets.achimota,
        timeAgo: '11h',
        content:
            'Heads held high! ⚪⚫\n\n'
            'We fought hard against an inspired Presec side. Immense respect to our contestants for that stunning calculus score in Round 2. We rise, we learn, and we rebuild for 2025!\n\n'
            '#LivingWaters #Motown #UtOmnesUnumSint #NSMQ',
        likesCount: 1120,
        commentsCount: 89,
        sharesCount: 160,
        isLiked: false,
        isRetweeted: false,
        comments: [],
      ),

      // 10. Mfantsipim School Tradition with Photo
      FeedPost(
        id: 'post_10',
        authorName: 'Mfantsipim School Botwe',
        authorHandle: '@BotweBoys',
        authorInitials: 'MB',
        authorColor: NeoColors.nsmqRed,
        isVerified: true,
        authorRole: '2x CHAMPIONS',
        category: 'LIVE BUZZ',
        schoolId: 'sch_mfantsipim',
        crestUrl: SchoolAssets.mfantsipim,
        timeAgo: '12h',
        content:
            'The Faithful Eight are ready! 🔴⚪\n\n'
            'Cape Coast excellence on full display in Kumasi. When the buzzer sounds, 148 years of tradition and academic supremacy speak. Dwen Hwe Kan!\n\n'
            '#Mfantsipim #Botwe #NSMQ2024 #DwenHweKan',
        imageUrl: 'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?q=80&w=1000&auto=format&fit=crop',
        imageCaption: 'Mfantsipim squad fine-tuning speed race strategies',
        imageAspectRatio: 16 / 9,
        likesCount: 2310,
        commentsCount: 340,
        sharesCount: 510,
        isLiked: false,
        isRetweeted: false,
        comments: [],
      ),

      // 11. St. Peter's SHS (PERSCO)
      FeedPost(
        id: 'post_11',
        authorName: 'St. Peter\'s SHS Nkwatia',
        authorHandle: '@PerscoNkwatia',
        authorInitials: 'SP',
        authorColor: NeoColors.green,
        isVerified: true,
        authorRole: '3x CHAMPIONS',
        category: 'LIVE BUZZ',
        schoolId: 'sch_stpeters',
        crestUrl: SchoolAssets.stPeters,
        timeAgo: '14h',
        content:
            'The Crocodiles of the Kwahu ridge are silently sharpening their pencils. 🐊⚡\n\n'
            'Quarter-Finals pairing confirmed. We are prepared for any school in Ghana. Dignitati Hominum!\n\n'
            '#PERSCO #KwahuCrocs #NSMQ2024',
        likesCount: 1680,
        commentsCount: 115,
        sharesCount: 240,
        isLiked: false,
        isRetweeted: false,
        comments: [],
      ),

      // 12. Viral Fan Reaction with Photo
      FeedPost(
        id: 'post_12',
        authorName: 'Nana Yaa STEM Fan',
        authorHandle: '@nana_yaa_stem',
        authorInitials: 'NY',
        authorColor: NeoColors.nsmqElectricBlue,
        isVerified: false,
        authorRole: 'SUPER FAN',
        category: 'LIVE BUZZ',
        timeAgo: '16h',
        content:
            'Can we talk about that speed in Round 5?! 😭 The boy buzzed before Quiz Mistress even finished reading "I am an organic compound..."\n\n'
            'My heart cannot take NSMQ season! The electric tension in the Saarah-Mensah auditorium is unmatched 🔥🇬🇭\n\n'
            '#NSMQ2024 #AuditoriumHeartattacks #GhanaSTEM',
        imageUrl: 'https://images.unsplash.com/photo-1511578314322-379afb476865?q=80&w=1000&auto=format&fit=crop',
        imageCaption: 'Packed crowd at the Saarah-Mensah Auditorium, Kumasi',
        imageAspectRatio: 16 / 9,
        likesCount: 3420,
        commentsCount: 480,
        sharesCount: 920,
        isLiked: false,
        isRetweeted: false,
        comments: [],
      ),

      // 13. Chemistry Flash Poll
      FeedPost(
        id: 'post_13',
        authorName: 'NSMQ Ghana',
        authorHandle: '@NSMQGhana',
        authorInitials: 'NS',
        authorColor: NeoColors.nsmqRed,
        isVerified: true,
        authorRole: 'OFFICIAL',
        category: 'POLLS',
        crestUrl: SchoolAssets.nsmqLogo,
        timeAgo: '18h',
        content:
            '🧪 CHEMISTRY SPEED RACE FLASH POLL:\n\n'
            'Which of the following Period 3 elements possesses the highest first ionization energy?\n\n'
            'Lock in your answer before the bell rings! 🔔👇',
        likesCount: 1540,
        commentsCount: 112,
        sharesCount: 215,
        isLiked: false,
        isRetweeted: false,
        poll: const FeedPoll(
          question: 'Highest 1st ionization energy in Period 3:',
          isQuiz: true,
          explanation: 'Argon has a stable octet (3s² 3p⁶); removing an electron requires maximum energy across Period 3.',
          totalVotes: 4120,
          options: [
            FeedPollOption(id: 'opt_13_1', text: 'A) Sodium (Na)', votes: 120, isCorrect: false),
            FeedPollOption(id: 'opt_13_2', text: 'B) Silicon (Si)', votes: 340, isCorrect: false),
            FeedPollOption(id: 'opt_13_3', text: 'C) Phosphorus (P)', votes: 890, isCorrect: false),
            FeedPollOption(id: 'opt_13_4', text: 'D) Argon (Ar)', votes: 2770, isCorrect: true),
          ],
        ),
        comments: [],
      ),
    ];
  }

  @override
  Future<List<FeedPost>> getFeedPosts({String? category}) async {
    await Future.delayed(const Duration(milliseconds: 120));
    if (category == null || category == 'FOR YOU' || category == 'ALL') {
      return List.unmodifiable(_posts);
    }
    if (category == 'PHOTOS') {
      return _posts.where((p) => p.imageUrl != null).toList();
    }
    if (category == 'POLLS') {
      return _posts.where((p) => p.poll != null).toList();
    }
    return _posts.where((p) => p.category.toUpperCase() == category.toUpperCase()).toList();
  }

  @override
  Future<bool> toggleLike(String postId) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return false;

    final post = _posts[index];
    final newLiked = !post.isLiked;
    final newLikesCount = newLiked ? post.likesCount + 1 : post.likesCount - 1;

    _posts[index] = post.copyWith(
      isLiked: newLiked,
      likesCount: newLikesCount > 0 ? newLikesCount : 0,
    );
    return newLiked;
  }

  @override
  Future<bool> toggleRetweet(String postId) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return false;

    final post = _posts[index];
    final newRetweeted = !post.isRetweeted;
    final newSharesCount = newRetweeted ? post.sharesCount + 1 : post.sharesCount - 1;

    _posts[index] = post.copyWith(
      isRetweeted: newRetweeted,
      sharesCount: newSharesCount > 0 ? newSharesCount : 0,
    );
    return newRetweeted;
  }

  @override
  Future<bool> toggleBookmark(String postId) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return false;

    final post = _posts[index];
    final newBookmarked = !post.isBookmarked;
    _posts[index] = post.copyWith(isBookmarked: newBookmarked);
    return newBookmarked;
  }

  @override
  Future<FeedComment> addComment(
    String postId,
    String commentText, {
    String authorName = 'NSMQ Fan',
    String authorHandle = '@fan_gh',
    String? replyingToHandle,
  }) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    final comment = FeedComment(
      id: 'c_${DateTime.now().millisecondsSinceEpoch}',
      authorName: authorName,
      authorHandle: authorHandle,
      authorInitials: authorName.substring(0, 1).toUpperCase(),
      authorColor: NeoColors.nsmqRed,
      content: commentText,
      timeAgo: 'Just now',
      likesCount: 0,
      isLiked: false,
      replyingToHandle: replyingToHandle,
    );

    if (index != -1) {
      final post = _posts[index];
      final updatedComments = [comment, ...post.comments];
      _posts[index] = post.copyWith(
        comments: updatedComments,
        commentsCount: post.commentsCount + 1,
      );
    }
    return comment;
  }

  @override
  Future<bool> toggleCommentLike(String postId, String commentId) async {
    final postIndex = _posts.indexWhere((p) => p.id == postId);
    if (postIndex == -1) return false;

    final post = _posts[postIndex];
    final commentIndex = post.comments.indexWhere((c) => c.id == commentId);
    if (commentIndex == -1) return false;

    final comment = post.comments[commentIndex];
    final newLiked = !comment.isLiked;
    final newCount = newLiked ? comment.likesCount + 1 : (comment.likesCount > 0 ? comment.likesCount - 1 : 0);

    final updatedComment = comment.copyWith(
      isLiked: newLiked,
      likesCount: newCount,
    );

    final updatedList = List<FeedComment>.from(post.comments);
    updatedList[commentIndex] = updatedComment;
    _posts[postIndex] = post.copyWith(comments: updatedList);

    return newLiked;
  }

  @override
  Future<FeedPost> votePoll(String postId, int optionIndex) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) throw Exception('Post not found');

    final post = _posts[index];
    if (post.poll == null) return post;

    final poll = post.poll!;
    if (poll.userVotedIndex != null) return post; // already voted

    final updatedOptions = poll.options.asMap().entries.map((entry) {
      final idx = entry.key;
      final opt = entry.value;
      if (idx == optionIndex) {
        return opt.copyWith(votes: opt.votes + 1);
      }
      return opt;
    }).toList();

    final updatedPoll = poll.copyWith(
      options: updatedOptions,
      totalVotes: poll.totalVotes + 1,
      userVotedIndex: optionIndex,
    );

    _posts[index] = post.copyWith(poll: updatedPoll);
    return _posts[index];
  }

  @override
  Future<FeedPost> createPost(FeedPost post) async {
    _posts.insert(0, post);
    return post;
  }

  @override
  Future<List<NewsArticle>> getArticles({String? category}) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final articles = const [
      NewsArticle(
        id: 'art_1',
        title:
            'Accra Academy Beats Achimota School and Bright SHS to Secure First-Ever Grand Finale Spot, Sweep GH¢8,800 in Awards!',
        summary:
            'For Accra Academy, it was a chance to make history by securing their first-ever place at the Grand Finale of the 2026 National Championship. They scored a commanding 54 points at the UCC Main Auditorium after a dramatic 5-round battle.',
        timeAgo: '13 hours ago',
        category: 'NEWS',
        readTime: '4 min read',
        isFeatured: true,
      ),
      NewsArticle(
        id: 'art_2',
        title: 'PRESEC, Legon Stands Tall, Returns to the Grand Finale After Two Years!',
        summary:
            'Eight-time champions Presbyterian Boys\' Secondary School held their nerve through a fiercely contested encounter with St. John\'s School and Tamale SHS, pulling away in the decisive rounds to finish on 44 points and book their final berth.',
        timeAgo: '20 hours ago',
        category: 'NEWS',
        readTime: '4 min read',
        isFeatured: true,
      ),
      NewsArticle(
        id: 'art_3',
        title: 'AUGUSCO Books Semi-Final Spot after Commanding Quarter-Final Victory!',
        summary:
            'Two-time champions St. Augustine\'s College proved their pedigree with a 47-point victory in the Quarter-Finals, before defeating Prempeh College (47) and Pope John (28) in Semi-Final 1 to reach their 3rd consecutive Grand Finale.',
        timeAgo: '1 day ago',
        category: 'NEWS',
        readTime: '3 min read',
        isFeatured: false,
      ),
      NewsArticle(
        id: 'art_4',
        title: 'The NSMQ Story: From a Spark of Curiosity to a National Legacy',
        summary:
            'How a March 1993 tennis court discussion at the University of Ghana between Dr. Kwaku Mensa-Bonsu and Prof. Ebenezer Awotwe about why birds don\'t get electrocuted on power lines birthed Ghana\'s most beloved academic championship.',
        timeAgo: '3 days ago',
        category: 'FEATURE',
        readTime: '5 min read',
        isFeatured: false,
      ),
      NewsArticle(
        id: 'art_5',
        title: 'Bright SHS Makes History as First Private Senior High School in NSMQ Semi-Finals',
        summary:
            'In their third appearance at the National Championship, Bright SHS stunned traditional powerhouses to reach the Semi-Finals, scoring a perfect 10/10 in the Problem of the Day and winning the Jupay Clean Sheet Award.',
        timeAgo: '2 days ago',
        category: 'FEATURE',
        readTime: '3 min read',
        isFeatured: false,
      ),
      NewsArticle(
        id: 'art_6',
        title: 'NSMQ 2026: Semi-Final Fixtures & UG Premier Domes Grand Finale Schedule',
        summary:
            'Produced by Primetime Limited and sponsored by GES, GOIL, Prudential Life, and Pepsodent, the 2026 Grand Finale will take place on Thursday, September 10, 2026, at the UG Premier Domes, Legon.',
        timeAgo: '4 days ago',
        category: 'FIXTURES',
        readTime: '2 min read',
        isFeatured: false,
      ),
    ];

    if (category == null || category == 'ALL' || category == 'FOR YOU') {
      return articles;
    }
    return articles
        .where((a) => a.category.toUpperCase() == category.toUpperCase())
        .toList();
  }
}
