import 'package:flutter/material.dart';
import 'app/theme/app_borders.dart';
import 'app/theme/app_colors.dart';
import 'app/theme/app_shadows.dart';
import 'app/theme/app_theme.dart';
import 'app/theme/app_typography.dart';
import 'core/widgets/neo_badge.dart';
import 'core/widgets/neo_button.dart';
import 'core/widgets/neo_card.dart';
import 'core/widgets/neo_tab_pill.dart';
import 'features/live_scores/domain/entities/contest.dart';
import 'features/live_scores/domain/entities/round_scores.dart';
import 'features/live_scores/domain/entities/school.dart';
import 'features/live_scores/presentation/widgets/nsmq_match_card.dart';

void main() {
  runApp(const NsmqFlashscoreApp());
}

class NsmqFlashscoreApp extends StatelessWidget {
  const NsmqFlashscoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NSMQ Flashscore',
      debugShowCheckedModeBanner: false,
      theme: NeoTheme.lightTheme,
      home: const DesignSystemShowcaseScreen(),
    );
  }
}

class DesignSystemShowcaseScreen extends StatefulWidget {
  const DesignSystemShowcaseScreen({super.key});

  @override
  State<DesignSystemShowcaseScreen> createState() => _DesignSystemShowcaseScreenState();
}

class _DesignSystemShowcaseScreenState extends State<DesignSystemShowcaseScreen> {
  int _selectedDayIndex = 1; // 0: Yesterday, 1: Today, 2: Tomorrow
  int _selectedFilterIndex = 1; // 0: All, 1: Live, 2: Finished
  int _testScore = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoColors.background,
      appBar: AppBar(
        backgroundColor: NeoColors.background,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: NeoColors.nsmqRed,
                borderRadius: NeoBorders.radiusSm,
                border: Border.all(color: NeoColors.border, width: 2),
                boxShadow: NeoShadows.pill,
              ),
              child: const Icon(Icons.flash_on, size: 20, color: NeoColors.textLight),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'NSMQ FLASHSCORE',
                    style: NeoTypography.headingLarge(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'OFFICIAL NSMQ COLOR SYSTEM & NEO-BRUTALISM',
                    style: NeoTypography.caption(color: NeoColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        children: [
          // -------------------------------------------------------------------
          // SECTION 1: OFFICIAL NSMQ PALETTE SPECIFICATION
          // -------------------------------------------------------------------
          _buildSectionHeader('1. OFFICIAL NSMQ COLOR PALETTE', Icons.palette),
          const SizedBox(height: 6),
          Text(
            'Exact brand colors from NSMQ identity carefully balanced with neo-brutalism best practices for high commercial legibility:',
            style: NeoTypography.bodyRegular(),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final double cardWidth = (constraints.maxWidth - 10) / 2;
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildColorSwatch(
                    cardWidth,
                    'NSMQ CRIMSON',
                    '#D00606',
                    NeoColors.nsmqRed,
                    'Primary Brand Anchor',
                    isDark: true,
                  ),
                  _buildColorSwatch(
                    cardWidth,
                    'ELECTRIC RED',
                    '#FF1E27',
                    NeoColors.nsmqBrightRed,
                    'Live Alert & Penalties',
                    isDark: true,
                  ),
                  _buildColorSwatch(
                    cardWidth,
                    'ROYAL BLUE',
                    '#1611D4',
                    NeoColors.nsmqBlue,
                    'Stages & Headers',
                    isDark: true,
                  ),
                  _buildColorSwatch(
                    cardWidth,
                    'ELECTRIC INDIGO',
                    '#4400FF',
                    NeoColors.nsmqElectricBlue,
                    'POD & Bonanza',
                    isDark: true,
                  ),
                  _buildColorSwatch(
                    cardWidth,
                    'PITCH BLACK',
                    '#000000',
                    NeoColors.border,
                    'Outlines & Shadows',
                    isDark: true,
                  ),
                  _buildColorSwatch(
                    cardWidth,
                    'CRISP WHITE',
                    '#FFFFFF',
                    NeoColors.surface,
                    'Card Face Surface',
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 16),

          // -------------------------------------------------------------------
          // COMMERCIAL COMPLEMENTS & FUNCTIONAL TINTS
          // -------------------------------------------------------------------
          Text(
            'Commercial Functional Complements:',
            style: NeoTypography.bodyBold(size: 13),
          ),
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              final double cardWidth = (constraints.maxWidth - 10) / 2;
              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildColorSwatch(
                    cardWidth,
                    'TROPHY GOLD',
                    '#FFC700',
                    NeoColors.gold,
                    'Leader & Championship',
                  ),
                  _buildColorSwatch(
                    cardWidth,
                    'MINT GREEN',
                    '#10B981',
                    NeoColors.green,
                    'Bonus (+1) / Correct',
                    isDark: true,
                  ),
                  _buildColorSwatch(
                    cardWidth,
                    'IVORY CANVAS',
                    '#FAF8F5',
                    NeoColors.background,
                    'Anti-Glare Page Canvas',
                  ),
                  _buildColorSwatch(
                    cardWidth,
                    'BLUE TINT',
                    '#ECEBFF',
                    NeoColors.surfaceBlue,
                    'POD Sub-Container',
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 24),

          // -------------------------------------------------------------------
          // SECTION 2: LIVE NSMQ CONTEST CARD WITH NSMQ IDENTITY
          // -------------------------------------------------------------------
          _buildSectionHeader('2. LIVE CONTEST CARD (OFFICIAL THEME)', Icons.sports_score),
          const SizedBox(height: 10),
          NsmqMatchCard(
            contest: _sampleLiveContest,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Opening Round Breakdown Scoreboard...'),
                  backgroundColor: NeoColors.nsmqRed,
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // -------------------------------------------------------------------
          // SECTION 3: DATE & STATUS PILLS (NSMQ Blue & Red Accents)
          // -------------------------------------------------------------------
          _buildSectionHeader('3. DATE & STATUS FILTER PILLS', Icons.calendar_today),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                NeoTabPill(
                  label: 'YESTERDAY',
                  isSelected: _selectedDayIndex == 0,
                  activeColor: NeoColors.nsmqBlue,
                  onTap: () => setState(() => _selectedDayIndex = 0),
                ),
                const SizedBox(width: 8),
                NeoTabPill(
                  label: 'TODAY',
                  isSelected: _selectedDayIndex == 1,
                  activeColor: NeoColors.nsmqBlue,
                  onTap: () => setState(() => _selectedDayIndex = 1),
                ),
                const SizedBox(width: 8),
                NeoTabPill(
                  label: 'TOMORROW',
                  isSelected: _selectedDayIndex == 2,
                  activeColor: NeoColors.nsmqBlue,
                  onTap: () => setState(() => _selectedDayIndex = 2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                NeoTabPill(
                  label: 'ALL CONTESTS (9)',
                  isSelected: _selectedFilterIndex == 0,
                  activeColor: NeoColors.nsmqBlue,
                  onTap: () => setState(() => _selectedFilterIndex = 0),
                ),
                const SizedBox(width: 8),
                NeoTabPill(
                  label: '🔴 LIVE NOW (3)',
                  isSelected: _selectedFilterIndex == 1,
                  activeColor: NeoColors.nsmqBrightRed,
                  onTap: () => setState(() => _selectedFilterIndex = 1),
                ),
                const SizedBox(width: 8),
                NeoTabPill(
                  label: 'FINISHED (6)',
                  isSelected: _selectedFilterIndex == 2,
                  activeColor: NeoColors.neutralMuted,
                  activeTextColor: NeoColors.textPrimary,
                  onTap: () => setState(() => _selectedFilterIndex = 2),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // -------------------------------------------------------------------
          // SECTION 4: TACTILE BUTTONS (NSMQ Red & Blue Action Buttons)
          // -------------------------------------------------------------------
          _buildSectionHeader('4. TACTILE ACTION BUTTONS', Icons.touch_app),
          const SizedBox(height: 6),
          Text(
            'Physical arcade press feedback in NSMQ theme colors:',
            style: NeoTypography.bodyRegular(),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              NeoButton(
                text: 'BUZZER (+3 PTS)',
                icon: Icons.notifications_active,
                backgroundColor: NeoColors.nsmqRed,
                textColor: NeoColors.textLight,
                onPressed: () => setState(() => _testScore += 3),
              ),
              NeoButton(
                text: 'BONUS (+1 PT)',
                icon: Icons.add_circle_outline,
                backgroundColor: NeoColors.green,
                textColor: NeoColors.textLight,
                onPressed: () => setState(() => _testScore += 1),
              ),
              NeoButton(
                text: 'PENALTY (-1 PT)',
                icon: Icons.remove_circle_outline,
                backgroundColor: NeoColors.nsmqBrightRed,
                textColor: NeoColors.textLight,
                onPressed: () => setState(() => _testScore -= 1),
              ),
              NeoButton(
                text: 'VIEW BRACKET',
                icon: Icons.account_tree_outlined,
                backgroundColor: NeoColors.nsmqBlue,
                textColor: NeoColors.textLight,
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 10),
          NeoCard(
            backgroundColor: NeoColors.surface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'SIMULATED SCORE TOTAL:',
                    style: NeoTypography.bodyBold(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: NeoColors.gold,
                    borderRadius: NeoBorders.radiusSm,
                    border: Border.all(color: NeoColors.border, width: 2),
                    boxShadow: NeoShadows.pill,
                  ),
                  child: Text('$_testScore PTS', style: NeoTypography.scoreText(size: 18)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // -------------------------------------------------------------------
          // SECTION 5: BADGES & PILLS
          // -------------------------------------------------------------------
          _buildSectionHeader('5. NSMQ BADGES & STATUS PILLS', Icons.label_outline),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              NeoBadge.live(),
              NeoBadge.finished(),
              NeoBadge.penalty(),
              NeoBadge.bonus(),
              NeoBadge.stage('1/8TH STAGE'),
              NeoBadge.stage('QUARTER-FINALS'),
              NeoBadge.round('R1: FUNDAMENTALS', isActive: false),
              NeoBadge.round('R2: SPEED RACE', isActive: false),
              NeoBadge.round('R3: PROBLEM OF THE DAY', isActive: true),
              NeoBadge.round('R4: TRUE/FALSE', isActive: false),
              NeoBadge.round('R5: RIDDLES', isActive: false),
              const NeoBadge(
                text: 'GOIL RIDDLE BONANZA 🌟',
                backgroundColor: NeoColors.nsmqElectricBlue,
                textColor: NeoColors.textLight,
              ),
              const NeoBadge(
                text: 'AIRTELTIGO HIGHEST SCORER 🏆',
                backgroundColor: NeoColors.gold,
                textColor: NeoColors.textPrimary,
              ),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: NeoColors.nsmqRed),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: NeoTypography.headingMedium(color: NeoColors.textPrimary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildColorSwatch(
    double width,
    String name,
    String hex,
    Color color,
    String role, {
    bool isDark = false,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: NeoBorders.radiusSm,
        border: Border.all(color: NeoColors.border, width: 2),
        boxShadow: NeoShadows.pill,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: NeoTypography.badge(
              color: isDark ? NeoColors.textLight : NeoColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            hex,
            style: NeoTypography.caption(
              color: isDark ? NeoColors.textLight : NeoColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            role,
            style: NeoTypography.caption(
              color: isDark ? NeoColors.textLight : NeoColors.textSecondary,
            ).copyWith(fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  static final Contest _sampleLiveContest = Contest(
    id: 'contest-14',
    title: 'CONTEST 14',
    stage: '1/8TH STAGE',
    scheduledAt: DateTime.now(),
    status: ContestStatus.live,
    currentRound: 3,
    currentRoundName: 'Round 3: Problem of the Day',
    entries: const [
      ContestantEntry(
        school: School(
          id: 'presec',
          name: 'Presbyterian Boys\' Secondary',
          shortName: 'PRESEC LEGON',
          region: 'Greater Accra',
          titlesCount: 8,
        ),
        scores: RoundScores(r1: 18, r2: 24, r3: 10, r4: 12, r5: 15),
      ),
      ContestantEntry(
        school: School(
          id: 'mfantsipim',
          name: 'Mfantsipim School',
          shortName: 'MFANTSIPIM',
          region: 'Central Region',
          titlesCount: 2,
        ),
        scores: RoundScores(r1: 15, r2: 18, r3: 8, r4: 10, r5: 10),
      ),
      ContestantEntry(
        school: School(
          id: 'prempeh',
          name: 'Prempeh College',
          shortName: 'PREMPEH',
          region: 'Ashanti Region',
          titlesCount: 5,
        ),
        scores: RoundScores(r1: 14, r2: 15, r3: 7, r4: 8, r5: 12),
      ),
    ],
  );
}
