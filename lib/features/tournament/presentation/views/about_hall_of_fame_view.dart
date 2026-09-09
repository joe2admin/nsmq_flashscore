import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/routes/app_routes.dart';
import '../../../../app/theme/app_borders.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/school_assets.dart';
import '../../../../core/widgets/neo_app_bar.dart';
import '../../../../core/widgets/neo_tab_pill.dart';
import '../../../../core/widgets/school_badge_avatar.dart';

/// Redesigned About NSMQ & Hall of Fame screen.
/// Features a clean segmented interface:
/// 1. Hall of Fame (Podium top-3, full rankings, year-by-year timeline, school detail links)
/// 2. About NSMQ (Origin story, fast facts, 5 contest rounds guide, 3 iconic Quiz Mistresses)
class AboutHallOfFameView extends StatefulWidget {
  final int initialTabIndex;

  const AboutHallOfFameView({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<AboutHallOfFameView> createState() => _AboutHallOfFameViewState();
}

class _AboutHallOfFameViewState extends State<AboutHallOfFameView> {
  late int _selectedTab;
  int _hallOfFameSubTab = 0; // 0 = By Titles, 1 = Timeline

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTabIndex;
  }

  // 11 National Champions data
  static const List<Map<String, dynamic>> _champions = [
    {
      'id': 'sch_presec',
      'name': 'PRESEC Legon',
      'fullName': "Presbyterian Boys' Secondary School",
      'nickname': 'Ɔdadeɛ',
      'region': 'Greater Accra',
      'titles': 8,
      'years': [1995, 2003, 2006, 2008, 2009, 2020, 2022, 2023],
    },
    {
      'id': 'sch_prempeh',
      'name': 'Prempeh College',
      'fullName': 'Prempeh College',
      'nickname': 'Amanfoo',
      'region': 'Ashanti',
      'titles': 5,
      'years': [1994, 1996, 2015, 2017, 2021],
    },
    {
      'id': 'sch_mfantsipim',
      'name': 'Mfantsipim School',
      'fullName': 'Mfantsipim School',
      'nickname': 'The School (Botwe)',
      'region': 'Central',
      'titles': 4,
      'years': [1999, 2014, 2024, 2025],
    },
    {
      'id': 'sch_stpeters',
      'name': "St. Peter's SHS",
      'fullName': "St. Peter's Senior High School",
      'nickname': 'Persco',
      'region': 'Eastern',
      'titles': 3,
      'years': [2000, 2005, 2018],
    },
    {
      'id': 'sch_owass',
      'name': 'Opoku Ware School',
      'fullName': 'Opoku Ware School',
      'nickname': 'Akatakyie',
      'region': 'Ashanti',
      'titles': 2,
      'years': [1997, 2002],
    },
    {
      'id': 'sch_achimota',
      'name': 'Achimota School',
      'fullName': 'Achimota School',
      'nickname': 'Motown',
      'region': 'Greater Accra',
      'titles': 2,
      'years': [1998, 2004],
    },
    {
      'id': 'sch_augustines',
      'name': "St. Augustine's College",
      'fullName': "St. Augustine's College",
      'nickname': 'Augusco',
      'region': 'Central',
      'titles': 2,
      'years': [2007, 2019],
    },
    {
      'id': 'sch_adisadel',
      'name': 'Adisadel College',
      'fullName': 'Adisadel College',
      'nickname': 'Adisco / Zebra Boys',
      'region': 'Central',
      'titles': 1,
      'years': [2016],
    },
    {
      'id': 'sch_aquinas',
      'name': 'St. Thomas Aquinas',
      'fullName': 'St. Thomas Aquinas SHS',
      'nickname': 'Old Toms',
      'region': 'Greater Accra',
      'titles': 1,
      'years': [2013],
    },
    {
      'id': 'sch_gsts',
      'name': 'GSTS Takoradi',
      'fullName': 'Ghana Secondary Technical School',
      'nickname': 'Giants',
      'region': 'Western',
      'titles': 1,
      'years': [2012],
    },
    {
      'id': 'sch_pope_john',
      'name': 'Pope John SHS',
      'fullName': 'Pope John Senior High School & Minor Seminary',
      'nickname': 'Pojoss (Daasebre)',
      'region': 'Eastern',
      'titles': 1,
      'years': [2001],
    },
  ];

  // Year-by-year chronological timeline data
  static const List<Map<String, dynamic>> _timeline = [
    {'year': 2025, 'school': 'Mfantsipim School', 'id': 'sch_mfantsipim', 'titleNum': '4th Title', 'edition': '31st Edition'},
    {'year': 2024, 'school': 'Mfantsipim School', 'id': 'sch_mfantsipim', 'titleNum': '3rd Title', 'edition': '30th Edition'},
    {'year': 2023, 'school': 'PRESEC Legon', 'id': 'sch_presec', 'titleNum': '8th Title', 'edition': '29th Edition'},
    {'year': 2022, 'school': 'PRESEC Legon', 'id': 'sch_presec', 'titleNum': '7th Title', 'edition': '28th Edition'},
    {'year': 2021, 'school': 'Prempeh College', 'id': 'sch_prempeh', 'titleNum': '5th Title', 'edition': '27th Edition'},
    {'year': 2020, 'school': 'PRESEC Legon', 'id': 'sch_presec', 'titleNum': '6th Title', 'edition': '26th Edition'},
    {'year': 2019, 'school': "St. Augustine's College", 'id': 'sch_augustines', 'titleNum': '2nd Title', 'edition': '25th Edition'},
    {'year': 2018, 'school': "St. Peter's SHS", 'id': 'sch_stpeters', 'titleNum': '3rd Title', 'edition': '24th Edition'},
    {'year': 2017, 'school': 'Prempeh College', 'id': 'sch_prempeh', 'titleNum': '4th Title', 'edition': '23rd Edition'},
    {'year': 2016, 'school': 'Adisadel College', 'id': 'sch_adisadel', 'titleNum': '1st Title', 'edition': '22nd Edition'},
    {'year': 2015, 'school': 'Prempeh College', 'id': 'sch_prempeh', 'titleNum': '3rd Title', 'edition': '21st Edition'},
    {'year': 2014, 'school': 'Mfantsipim School', 'id': 'sch_mfantsipim', 'titleNum': '2nd Title', 'edition': '20th Edition'},
    {'year': 2013, 'school': 'St. Thomas Aquinas', 'id': 'sch_aquinas', 'titleNum': '1st Title', 'edition': '19th Edition'},
    {'year': 2012, 'school': 'GSTS Takoradi', 'id': 'sch_gsts', 'titleNum': '1st Title', 'edition': '18th Edition'},
    {'year': 2009, 'school': 'PRESEC Legon', 'id': 'sch_presec', 'titleNum': '5th Title', 'edition': '17th Edition'},
    {'year': 2008, 'school': 'PRESEC Legon', 'id': 'sch_presec', 'titleNum': '4th Title', 'edition': '16th Edition'},
    {'year': 2007, 'school': "St. Augustine's College", 'id': 'sch_augustines', 'titleNum': '1st Title', 'edition': '15th Edition'},
    {'year': 2006, 'school': 'PRESEC Legon', 'id': 'sch_presec', 'titleNum': '3rd Title', 'edition': '14th Edition'},
    {'year': 2005, 'school': "St. Peter's SHS", 'id': 'sch_stpeters', 'titleNum': '2nd Title', 'edition': '13th Edition'},
    {'year': 2004, 'school': 'Achimota School', 'id': 'sch_achimota', 'titleNum': '2nd Title', 'edition': '12th Edition'},
    {'year': 2003, 'school': 'PRESEC Legon', 'id': 'sch_presec', 'titleNum': '2nd Title', 'edition': '11th Edition'},
    {'year': 2002, 'school': 'Opoku Ware School', 'id': 'sch_owass', 'titleNum': '2nd Title', 'edition': '10th Edition'},
    {'year': 2001, 'school': 'Pope John SHS', 'id': 'sch_pope_john', 'titleNum': '1st Title', 'edition': '9th Edition'},
    {'year': 2000, 'school': "St. Peter's SHS", 'id': 'sch_stpeters', 'titleNum': '1st Title', 'edition': '8th Edition'},
    {'year': 1999, 'school': 'Mfantsipim School', 'id': 'sch_mfantsipim', 'titleNum': '1st Title', 'edition': '7th Edition'},
    {'year': 1998, 'school': 'Achimota School', 'id': 'sch_achimota', 'titleNum': '1st Title', 'edition': '6th Edition'},
    {'year': 1997, 'school': 'Opoku Ware School', 'id': 'sch_owass', 'titleNum': '1st Title', 'edition': '5th Edition'},
    {'year': 1996, 'school': 'Prempeh College', 'id': 'sch_prempeh', 'titleNum': '2nd Title', 'edition': '4th Edition'},
    {'year': 1995, 'school': 'PRESEC Legon', 'id': 'sch_presec', 'titleNum': '1st Title', 'edition': '3rd Edition'},
    {'year': 1994, 'school': 'Prempeh College', 'id': 'sch_prempeh', 'titleNum': 'Inaugural Champion', 'edition': '2nd Edition'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoColors.background,
      appBar: NeoAppBar(
        title: 'NSMQ ARCHIVE',
        subtitle: _selectedTab == 0 ? 'HALL OF FAME & CHAMPIONS' : 'HISTORY, RULES & MISTRESSES',
        leading: GestureDetector(
          onTap: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Get.back();
            }
          },
          child: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: NeoColors.surface,
              borderRadius: NeoBorders.radiusSm,
              border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
              boxShadow: NeoShadows.pill,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 16,
              color: NeoColors.textPrimary,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Top Segment Switcher: [🏆 Hall of Fame] | [📖 About NSMQ]
          _buildTopSegmentedTabs(),

          // Main Tab Body
          Expanded(
            child: _selectedTab == 0
                ? _buildHallOfFameTab(context)
                : _buildAboutNsmqTab(context),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Top Segmented Switcher
  // ---------------------------------------------------------------------------
  Widget _buildTopSegmentedTabs() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: const BoxDecoration(
        color: NeoColors.surface,
        border: Border(
          bottom: BorderSide(color: NeoColors.border, width: NeoBorders.strokeDefault),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildTopTabButton(
                  label: 'HALL OF FAME',
                  icon: Icons.emoji_events,
                  isSelected: _selectedTab == 0,
                  activeColor: NeoColors.nsmqRed,
                  onTap: () {
                    if (_selectedTab != 0) setState(() => _selectedTab = 0);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildTopTabButton(
                  label: 'ABOUT NSMQ',
                  icon: Icons.auto_stories,
                  isSelected: _selectedTab == 1,
                  activeColor: NeoColors.nsmqBlue,
                  onTap: () {
                    if (_selectedTab != 1) setState(() => _selectedTab = 1);
                  },
                ),
              ),
            ],
          ),
          if (_selectedTab == 0) ...[
            const SizedBox(height: 8),
            _buildSubTabSelector(),
          ],
        ],
      ),
    );
  }

  Widget _buildTopTabButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : NeoColors.surface,
          borderRadius: NeoBorders.radiusPill,
          border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
          boxShadow: isSelected ? NeoShadows.pill : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 13,
              color: isSelected ? NeoColors.textLight : NeoColors.textSecondary,
            ),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                style: NeoTypography.badge(
                  color: isSelected ? NeoColors.textLight : NeoColors.textSecondary,
                ).copyWith(fontSize: 10.5),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 1: HALL OF FAME
  // ---------------------------------------------------------------------------
  Widget _buildHallOfFameTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      children: [
        // 1. Quick Stat Highlights
        _buildStatSummaryRow(),
        const SizedBox(height: 14),

        if (_hallOfFameSubTab == 0) ...[
          // Top 3 Podium Cards
          _buildPodiumHeader(),
          const SizedBox(height: 10),
          _buildTopPodiumCards(context),
          const SizedBox(height: 20),

          // Remaining Champions (Rank 4 to 11)
          _buildRemainingChampionsHeader(),
          const SizedBox(height: 10),
          ..._buildRemainingChampionsList(context),
        ] else ...[
          // Year-by-year Chronological Timeline
          _buildTimelineHeader(),
          const SizedBox(height: 10),
          ..._buildTimelineList(context),
        ],

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildStatSummaryRow() {
    return Row(
      children: [
        _buildStatItem('31', 'TOURNAMENTS', NeoColors.surfaceYellow, NeoColors.textPrimary),
        const SizedBox(width: 8),
        _buildStatItem('11', 'CHAMPIONS', NeoColors.surfaceBlue, NeoColors.nsmqBlue),
        const SizedBox(width: 8),
        _buildStatItem('8', 'RECORD TITLES', NeoColors.surfaceRed, NeoColors.nsmqRed),
      ],
    );
  }

  Widget _buildStatItem(String stat, String label, Color bg, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: NeoBorders.radiusSm,
          border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
          boxShadow: NeoShadows.card,
        ),
        child: Column(
          children: [
            Text(
              stat,
              style: NeoTypography.displayLarge(color: textColor).copyWith(fontSize: 22),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: NeoTypography.badge(color: NeoColors.textPrimary).copyWith(fontSize: 9.5),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubTabSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: NeoColors.surfaceMuted,
        borderRadius: NeoBorders.radiusPill,
        border: Border.all(color: NeoColors.border, width: NeoBorders.strokeThin),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _hallOfFameSubTab = 0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: 7),
                decoration: BoxDecoration(
                  color: _hallOfFameSubTab == 0 ? NeoColors.nsmqRed : Colors.transparent,
                  borderRadius: NeoBorders.radiusPill,
                ),
                child: Text(
                  'BY TITLES (RANKINGS)',
                  textAlign: TextAlign.center,
                  style: NeoTypography.badge(
                    color: _hallOfFameSubTab == 0 ? NeoColors.textLight : NeoColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _hallOfFameSubTab = 1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(vertical: 7),
                decoration: BoxDecoration(
                  color: _hallOfFameSubTab == 1 ? NeoColors.nsmqRed : Colors.transparent,
                  borderRadius: NeoBorders.radiusPill,
                ),
                child: Text(
                  'CHRONOLOGICAL TIMELINE',
                  textAlign: TextAlign.center,
                  style: NeoTypography.badge(
                    color: _hallOfFameSubTab == 1 ? NeoColors.textLight : NeoColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumHeader() {
    return Row(
      children: [
        const Icon(Icons.workspace_premium, size: 18, color: NeoColors.gold),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            'THE TOP 3 POWERHOUSES',
            style: NeoTypography.headingMedium(color: NeoColors.textPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildTopPodiumCards(BuildContext context) {
    final first = _champions[0]; // PRESEC (8)
    final second = _champions[1]; // Prempeh (5)
    final third = _champions[2]; // Mfantsipim (4)

    return Column(
      children: [
        // #1 PRESEC - Grand Gold Spotlight Card
        _buildPodiumCard(
          context: context,
          champion: first,
          rank: 1,
          rankLabel: '1ST • 8 TITLES',
          badgeColor: NeoColors.gold,
          cardColor: NeoColors.surfaceYellow,
          accentColor: NeoColors.nsmqRed,
          crownIcon: Icons.emoji_events,
          subHighlight: 'Defending National Record Holder',
        ),
        const SizedBox(height: 10),

        // #2 Prempeh College - Silver Card
        _buildPodiumCard(
          context: context,
          champion: second,
          rank: 2,
          rankLabel: '2ND • 5 TITLES',
          badgeColor: const Color(0xFFE2E2EA),
          cardColor: NeoColors.surface,
          accentColor: NeoColors.border,
          crownIcon: Icons.military_tech,
          subHighlight: '5-Time National Champions',
        ),
        const SizedBox(height: 10),

        // #3 Mfantsipim School - Bronze Card
        _buildPodiumCard(
          context: context,
          champion: third,
          rank: 3,
          rankLabel: '3RD • 4 TITLES',
          badgeColor: const Color(0xFFFFE5D0),
          cardColor: NeoColors.surface,
          accentColor: NeoColors.nsmqRed,
          crownIcon: Icons.workspace_premium,
          subHighlight: 'Reigning Back-to-Back Champions (2024, 2025)',
        ),
      ],
    );
  }

  Widget _buildPodiumCard({
    required BuildContext context,
    required Map<String, dynamic> champion,
    required int rank,
    required String rankLabel,
    required Color badgeColor,
    required Color cardColor,
    required Color accentColor,
    required IconData crownIcon,
    required String subHighlight,
  }) {
    final years = (champion['years'] as List<int>).join(', ');

    return GestureDetector(
      onTap: () => _navigateToSchool(champion['id']),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: NeoBorders.radiusMd,
          border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
          boxShadow: NeoShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SchoolBadgeAvatar(
                  schoolId: champion['id'],
                  schoolName: champion['name'],
                  size: 44,
                  isLeader: rank == 1,
                  showShadow: true,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: badgeColor,
                              borderRadius: NeoBorders.radiusSm,
                              border: Border.all(color: NeoColors.border, width: 1.5),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(crownIcon, size: 13, color: NeoColors.textPrimary),
                                const SizedBox(width: 4),
                                Text(
                                  rankLabel,
                                  style: NeoTypography.badge(color: NeoColors.textPrimary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        champion['name'],
                        style: NeoTypography.headingLarge(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 14, color: NeoColors.textSecondary),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: NeoColors.surface,
                borderRadius: NeoBorders.radiusSm,
                border: Border.all(color: NeoColors.border, width: 1),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 12, color: NeoColors.nsmqRed),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Years Won: $years',
                      style: NeoTypography.bodyBold(size: 11.5, color: NeoColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemainingChampionsHeader() {
    return Row(
      children: [
        const Icon(Icons.format_list_numbered, size: 18, color: NeoColors.textPrimary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            'HONOUR ROLL (RANKS 4 - 11)',
            style: NeoTypography.headingMedium(color: NeoColors.textPrimary),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildRemainingChampionsList(BuildContext context) {
    // Ranks 4 through 11
    final remaining = _champions.sublist(3);

    return remaining.asMap().entries.map((entry) {
      final rank = entry.key + 4;
      final champion = entry.value;
      final years = (champion['years'] as List<int>).join(', ');
      final titles = champion['titles'] as int;

      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: GestureDetector(
          onTap: () => _navigateToSchool(champion['id']),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: NeoColors.surface,
              borderRadius: NeoBorders.radiusSm,
              border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
              boxShadow: NeoShadows.pill,
            ),
            child: Row(
              children: [
                // Rank Circle
                Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: NeoColors.neutralMuted,
                    shape: BoxShape.circle,
                    border: Border.all(color: NeoColors.border, width: 1),
                  ),
                  child: Text(
                    '$rank',
                    style: NeoTypography.badge(color: NeoColors.textPrimary).copyWith(fontSize: 10),
                  ),
                ),
                const SizedBox(width: 10),

                // School Crest
                SchoolBadgeAvatar(
                  schoolId: champion['id'],
                  schoolName: champion['name'],
                  size: 34,
                ),
                const SizedBox(width: 10),

                // Name & Years
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              champion['name'],
                              style: NeoTypography.bodyBold(size: 13),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: titles > 1 ? NeoColors.surfaceBlue : NeoColors.surfaceMuted,
                              borderRadius: NeoBorders.radiusSm,
                              border: Border.all(color: NeoColors.border, width: 1),
                            ),
                            child: Text(
                              titles == 1 ? '1 TITLE' : '$titles TITLES',
                              style: NeoTypography.badge(
                                color: titles > 1 ? NeoColors.nsmqBlue : NeoColors.textSecondary,
                              ).copyWith(fontSize: 9.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Won: $years',
                        style: NeoTypography.caption(color: NeoColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.arrow_forward_ios, size: 12, color: NeoColors.textSecondary),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildTimelineHeader() {
    return Row(
      children: [
        const Icon(Icons.history, size: 18, color: NeoColors.nsmqRed),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            'CHAMPIONS BY YEAR (1994 - 2025)',
            style: NeoTypography.headingMedium(color: NeoColors.textPrimary),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildTimelineList(BuildContext context) {
    return _timeline.map((item) {
      final isRecent = item['year'] >= 2020;

      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: GestureDetector(
          onTap: () => _navigateToSchool(item['id']),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: isRecent ? NeoColors.surfaceYellow : NeoColors.surface,
              borderRadius: NeoBorders.radiusSm,
              border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
              boxShadow: NeoShadows.pill,
            ),
            child: Row(
              children: [
                // Year Tag
                Container(
                  width: 52,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isRecent ? NeoColors.nsmqRed : NeoColors.darkCanvas,
                    borderRadius: NeoBorders.radiusSm,
                  ),
                  child: Text(
                    '${item['year']}',
                    style: NeoTypography.badge(color: NeoColors.textLight).copyWith(fontSize: 11),
                  ),
                ),
                const SizedBox(width: 10),

                // Crest
                SchoolBadgeAvatar(
                  schoolId: item['id'],
                  schoolName: item['school'],
                  size: 32,
                ),
                const SizedBox(width: 10),

                // Champion Name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['school'],
                        style: NeoTypography.bodyBold(size: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${item['titleNum']} • ${item['edition']}',
                        style: NeoTypography.caption(color: NeoColors.textSecondary),
                      ),
                    ],
                  ),
                ),

                const Icon(Icons.arrow_forward_ios, size: 12, color: NeoColors.textSecondary),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  // ---------------------------------------------------------------------------
  // TAB 2: ABOUT NSMQ
  // ---------------------------------------------------------------------------
  Widget _buildAboutNsmqTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      children: [
        // 1. Hero Card & Origin Story
        _buildOriginHeroCard(),
        const SizedBox(height: 16),

        // 2. 4 Fast Facts Grid
        _buildFastFactsGrid(),
        const SizedBox(height: 20),

        // 3. The 5 Contest Rounds Explained
        _buildSectionHeader(Icons.quiz, 'HOW THE CONTEST WORKS (5 ROUNDS)'),
        const SizedBox(height: 10),
        _buildRoundsBreakdown(),
        const SizedBox(height: 20),

        // 4. The 3 Quiz Mistresses
        _buildSectionHeader(Icons.school, 'THE 3 QUIZ MISTRESSES (1993 - PRESENT)'),
        const SizedBox(height: 10),
        _buildQuizMistressesList(),
        const SizedBox(height: 20),

        // 5. Official Partners & Primetime Footer
        _buildFooter(),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildOriginHeroCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NeoColors.surface,
        borderRadius: NeoBorders.radiusMd,
        border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
        boxShadow: NeoShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(SchoolAssets.nsmqLogo, width: 36, height: 36),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NATIONAL SCIENCE & MATHS QUIZ',
                      style: NeoTypography.headingMedium(color: NeoColors.nsmqRed),
                    ),
                    Text(
                      'Promoting STEM Excellence Since 1993',
                      style: NeoTypography.caption(color: NeoColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: NeoColors.surfaceYellow,
              borderRadius: NeoBorders.radiusSm,
              border: Border.all(color: NeoColors.border, width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.format_quote, size: 20, color: NeoColors.nsmqRed),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '"Why don\'t birds perching on high-voltage wires get electrocuted?"\n— Dr. Kwaku Mensa-Bonsu to Prof. Ebenezer Awotwe, Legon Tennis Courts (1993)',
                    style: NeoTypography.bodyRegular(size: 11.5, color: NeoColors.textPrimary)
                        .copyWith(fontStyle: FontStyle.italic, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'That single inquisitive question sparked the creation of Ghana\'s longest-running independent television programme. Originally sponsored by Lever Brothers as the Brillant Science & Maths Quiz, today\'s NSMQ is produced by Primetime Limited with GES and Ministry of Education backing, serving as the crown jewel of African secondary academic sports.',
            style: NeoTypography.bodyRegular(size: 12.5),
          ),
        ],
      ),
    );
  }

  Widget _buildFastFactsGrid() {
    final facts = [
      {'val': '30+ Years', 'label': 'Longest Running TV Show', 'icon': Icons.tv},
      {'val': '150+ Schools', 'label': 'From All 16 Regions', 'icon': Icons.account_balance},
      {'val': '5 Stages', 'label': 'Prelims to Grand Finale', 'icon': Icons.military_tech},
      {'val': '5 Rounds', 'label': 'High-Stakes Mental Battle', 'icon': Icons.timer},
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.2,
      children: facts.map((f) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: NeoColors.surface,
            borderRadius: NeoBorders.radiusSm,
            border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
            boxShadow: NeoShadows.pill,
          ),
          child: Row(
            children: [
              Icon(f['icon'] as IconData, size: 20, color: NeoColors.nsmqBlue),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      f['val'] as String,
                      style: NeoTypography.bodyBold(size: 13, color: NeoColors.textPrimary),
                    ),
                    Text(
                      f['label'] as String,
                      style: NeoTypography.caption(color: NeoColors.textSecondary).copyWith(fontSize: 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 18, color: NeoColors.nsmqRed),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            title,
            style: NeoTypography.headingMedium(color: NeoColors.textPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildRoundsBreakdown() {
    final rounds = [
      {
        'num': 'R1',
        'title': 'Fundamental Concepts',
        'desc': 'Fundamental questions in Physics, Chemistry, Biology, and Mathematics. Each school answers questions alternately within 30 seconds for 3 points.',
        'color': NeoColors.surfaceBlue,
      },
      {
        'num': 'R2',
        'title': 'The Speed Race',
        'desc': 'All three schools compete concurrently using buzzers. Speed and precision are critical: correct answers yield 3 points, but incorrect buzzes lose 1 point.',
        'color': NeoColors.surfaceRed,
      },
      {
        'num': 'R3',
        'title': 'Problem of the Day',
        'desc': 'A heavyweight single analytical calculation or proof. Teams have 4 minutes to work simultaneously for up to 10 maximum points.',
        'color': NeoColors.surfaceYellow,
      },
      {
        'num': 'R4',
        'title': 'True or False',
        'desc': 'Rapid-fire statements. Correct answers score 2 points; wrong answers suffer a 1-point penalty. Passing is permitted with no penalty.',
        'color': NeoColors.surface,
      },
      {
        'num': 'R5',
        'title': 'Riddles (The Clincher)',
        'desc': 'Progressive clues read by the Quiz Mistress. Solving on the 1st clue gives 5 points, 2nd gives 4 points, and 3rd/4th clue gives 3 points.',
        'color': NeoColors.surfaceBlue,
      },
    ];

    return Column(
      children: rounds.map((r) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: r['color'] as Color,
            borderRadius: NeoBorders.radiusSm,
            border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
            boxShadow: NeoShadows.pill,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: NeoColors.darkCanvas,
                  borderRadius: NeoBorders.radiusSm,
                ),
                child: Text(
                  r['num'] as String,
                  style: NeoTypography.badge(color: NeoColors.textLight),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r['title'] as String,
                      style: NeoTypography.bodyBold(size: 13),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      r['desc'] as String,
                      style: NeoTypography.bodyRegular(size: 11.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuizMistressesList() {
    final mistresses = [
      {
        'name': 'Prof. Elsie Effah Kaufmann',
        'years': '2006 – Present (20 Years)',
        'role': 'Dean of Engineering Sciences, UG Legon',
        'bio': 'Biomedical engineer and academic leader. Celebrating two iconic decades as the intellectual pulse and signature voice of the National Championship.',
        'imageUrl':
            'https://static.wixstatic.com/media/a1e1f8_870b66ec31554cb6ab48410bf80d3b15~mv2.jpg/v1/crop/x_532,y_163,w_1436,h_1772/fill/w_290,h_358,al_c,q_80,enc_avif,quality_auto/QM%202.jpg',
        'isCurrent': true,
        'color': NeoColors.surfaceYellow,
      },
      {
        'name': 'Dr. Eureka Emefa Adomako',
        'years': '2001 – 2005',
        'role': 'Senior Academic, Plant & Environmental Biology',
        'bio': 'Botanist and distinguished scholar who guided NSMQ through its critical formative expansion across all 10 administrative regions.',
        'imageUrl':
            'https://static.wixstatic.com/media/a1e1f8_1271856477bb4e72be38ac5d36022f85~mv2.jpg/v1/crop/x_69,y_64,w_245,h_305/fill/w_290,h_361,al_c,lg_1,q_80,enc_avif,quality_auto/Dr_edited.jpg',
        'isCurrent': false,
        'color': NeoColors.surfaceBlue,
      },
      {
        'name': 'Prof. Marian Ewurama Addy',
        'years': '1993 – 1999',
        'role': 'First Host & Pioneer Quiz Mistress',
        'bio': 'First Ghanaian woman to attain the rank of full professor of natural science. Renowned biochemist whose pioneering presence inspired generations in STEM.',
        'imageUrl':
            'https://static.wixstatic.com/media/a1e1f8_ec628fbac6964380a5b1acdf18af18ab~mv2.jpg/v1/crop/x_0,y_25,w_264,h_328/fill/w_290,h_360,al_c,lg_1,q_80,enc_avif,quality_auto/Marian_Ewurama_Addy_edited.jpg',
        'isCurrent': false,
        'color': NeoColors.surfaceMuted,
      },
    ];

    return Column(
      children: mistresses.map((m) {
        final isCurrent = m['isCurrent'] as bool;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: m['color'] as Color,
            borderRadius: NeoBorders.radiusMd,
            border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
            boxShadow: NeoShadows.card,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo with graceful fallback
              ClipRRect(
                borderRadius: NeoBorders.radiusSm,
                child: Container(
                  width: 70,
                  height: 84,
                  color: NeoColors.neutralMuted,
                  child: Image.network(
                    m['imageUrl'] as String,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.person,
                      size: 36,
                      color: NeoColors.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Bio
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            m['name'] as String,
                            style: NeoTypography.headingMedium(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isCurrent)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: NeoColors.nsmqRed,
                              borderRadius: NeoBorders.radiusSm,
                            ),
                            child: Text(
                              'CURRENT',
                              style: NeoTypography.badge(color: NeoColors.textLight).copyWith(fontSize: 9),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      m['years'] as String,
                      style: NeoTypography.caption(color: NeoColors.nsmqBlue).copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      m['role'] as String,
                      style: NeoTypography.caption(color: NeoColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      m['bio'] as String,
                      style: NeoTypography.bodyRegular(size: 11.5),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: NeoColors.surfaceMuted,
        borderRadius: NeoBorders.radiusSm,
        border: Border.all(color: NeoColors.border, width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(SchoolAssets.nsmqLogo, width: 20, height: 20),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'PRIMETIME LIMITED • GHANA EDUCATION SERVICE',
                  style: NeoTypography.badge(color: NeoColors.textPrimary).copyWith(fontSize: 10),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Official Partners: GOIL PLC, Prudential Life, Joy News, Pepsodent, Trustur AI, Jupay',
            style: NeoTypography.caption(color: NeoColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _navigateToSchool(String? schoolId) {
    if (schoolId != null && schoolId.isNotEmpty) {
      Get.toNamed(AppRoutes.schoolDetail, arguments: schoolId);
    }
  }
}
