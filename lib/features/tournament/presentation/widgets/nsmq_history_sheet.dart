import 'package:flutter/material.dart';
import '../../../../app/theme/app_borders.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/school_assets.dart';

/// Neo-Brutalist bottom sheet presenting official NSMQ History,
/// the 3 legendary Quiz Mistresses, and the 11-Champion Hall of Fame
/// sourced from the official website (nsmq.com.gh).
class NsmqHistorySheet extends StatelessWidget {
  const NsmqHistorySheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const NsmqHistorySheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: NeoColors.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(NeoBorders.lg)),
            border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
            boxShadow: NeoShadows.elevated,
          ),
          child: Column(
            children: [
              // Sheet Header
              _buildHeader(context),

              // Scrollable Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    // 1. Origin Story Banner
                    _buildOriginCard(),
                    const SizedBox(height: 16),

                    // 2. Quiz Mistresses Section
                    _buildSectionTitle('THE QUIZ MISTRESSES (3 DECADES)'),
                    const SizedBox(height: 10),
                    _buildQuizMistressCard(
                      name: 'Prof. Marian Ewurama Addy',
                      years: '1993 – 1999',
                      role: 'First Host & Pioneer Quiz Mistress',
                      bio:
                          'First Ghanaian woman to attain the rank of full professor of natural science. Biochemist whose pioneering role inspired thousands of young Ghanaian girls in STEM.',
                      imageUrl:
                          'https://static.wixstatic.com/media/a1e1f8_ec628fbac6964380a5b1acdf18af18ab~mv2.jpg/v1/crop/x_0,y_25,w_264,h_328/fill/w_290,h_360,al_c,lg_1,q_80,enc_avif,quality_auto/Marian_Ewurama_Addy_edited.jpg',
                      color: NeoColors.surfaceYellow,
                    ),
                    const SizedBox(height: 12),
                    _buildQuizMistressCard(
                      name: 'Dr. Eureka Emefa Adomako',
                      years: '2001 – 2005',
                      role: 'Second Quiz Mistress',
                      bio:
                          'Botanist and senior academic at the Department of Plant and Environmental Biology, University of Ghana. Guided NSMQ through its critical formative expansion.',
                      imageUrl:
                          'https://static.wixstatic.com/media/a1e1f8_1271856477bb4e72be38ac5d36022f85~mv2.jpg/v1/crop/x_69,y_64,w_245,h_305/fill/w_290,h_361,al_c,lg_1,q_80,enc_avif,quality_auto/Dr_edited.jpg',
                      color: NeoColors.surfaceBlue,
                    ),
                    const SizedBox(height: 12),
                    _buildQuizMistressCard(
                      name: 'Prof. Elsie Effah Kaufmann',
                      years: '2006 – Present',
                      role: 'Current Host & Dean of Engineering Sciences',
                      bio:
                          'Biomedical engineer, Dean of the School of Engineering Sciences at UG Legon. Celebrating 20 iconic years as the intellectual pulse of the National Championship.',
                      imageUrl:
                          'https://static.wixstatic.com/media/a1e1f8_870b66ec31554cb6ab48410bf80d3b15~mv2.jpg/v1/crop/x_532,y_163,w_1436,h_1772/fill/w_290,h_358,al_c,q_80,enc_avif,quality_auto/QM%202.jpg',
                      color: NeoColors.surfaceMuted,
                      isCurrent: true,
                    ),

                    const SizedBox(height: 20),

                    // 3. Hall of Fame (11 Champions)
                    _buildSectionTitle('THE 11 NATIONAL CHAMPIONS (1993 - PRESENT)'),
                    const SizedBox(height: 10),
                    _buildChampionsGrid(),

                    const SizedBox(height: 20),

                    // 4. Official Primetime & GES Footer
                    _buildFooterInfo(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: const BoxDecoration(
        color: NeoColors.nsmqRed,
        borderRadius: BorderRadius.vertical(top: Radius.circular(NeoBorders.lg - 2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_stories, color: NeoColors.textLight, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ABOUT NSMQ & HALL OF FAME',
                  style: NeoTypography.headingMedium(color: NeoColors.textLight),
                ),
                Text(
                  'Official Archive from Primetime Limited',
                  style: NeoTypography.caption(color: NeoColors.textLight),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: NeoColors.textLight, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildOriginCard() {
    return Container(
      padding: const EdgeInsets.all(14),
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
              Image.asset(SchoolAssets.nsmqLogo, width: 32, height: 32),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'FROM A SPARK OF CURIOSITY TO A NATIONAL LEGACY',
                  style: NeoTypography.badge(color: NeoColors.nsmqRed),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'In March 1993 on the tennis court of the University of Ghana, Dr. Kwaku Mensa-Bonsu (Primetime Ltd) asked Prof. Ebenezer Awotwe why birds perching on high-voltage wires don\'t get electrocuted.\n\n'
            'That casual inquiry blossomed into the Brillant Science & Maths Quiz (sponsored by Lever Brothers). Today, produced by Primetime Limited and sponsored by GES, NSMQ is Ghana\'s longest-running independent television programme and the pinnacle of African secondary STEM excellence.',
            style: NeoTypography.bodyRegular(size: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: NeoColors.darkCanvas,
        borderRadius: NeoBorders.radiusSm,
      ),
      child: Text(
        title,
        style: NeoTypography.badge(color: NeoColors.textLight),
      ),
    );
  }

  Widget _buildQuizMistressCard({
    required String name,
    required String years,
    required String role,
    required String bio,
    required String imageUrl,
    required Color color,
    bool isCurrent = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: NeoBorders.radiusMd,
        border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
        boxShadow: NeoShadows.card,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: NeoBorders.radiusSm,
            child: Image.network(
              imageUrl,
              width: 76,
              height: 96,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                width: 76,
                height: 96,
                color: NeoColors.surfaceMuted,
                child: const Icon(Icons.person, size: 36),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: NeoTypography.headingMedium(color: NeoColors.textPrimary),
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
                          '20 YEARS',
                          style: NeoTypography.caption(color: NeoColors.textLight),
                        ),
                      ),
                  ],
                ),
                Text(
                  '$years • $role',
                  style: NeoTypography.caption(color: NeoColors.nsmqBlue),
                ),
                const SizedBox(height: 6),
                Text(
                  bio,
                  style: NeoTypography.bodyRegular(size: 11.5),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChampionsGrid() {
    final champions = [
      {'name': 'PRESEC Legon', 'titles': '8 Titles', 'years': '1995, 2003, 06, 08, 09, 20, 22, 23'},
      {'name': 'Prempeh College', 'titles': '5 Titles', 'years': '1994, 1996, 2015, 2017, 2021'},
      {'name': 'Mfantsipim School', 'titles': '4 Titles', 'years': '1999, 2014, 2024, 2025'},
      {'name': 'St. Peter\'s SHS', 'titles': '3 Titles', 'years': '2000, 2005, 2018'},
      {'name': 'Opoku Ware School', 'titles': '2 Titles', 'years': '1997, 2002'},
      {'name': 'Achimota School', 'titles': '2 Titles', 'years': '1998, 2004'},
      {'name': 'St. Augustine\'s College', 'titles': '2 Titles', 'years': '2007, 2019'},
      {'name': 'Adisadel College', 'titles': '1 Title', 'years': '2016'},
      {'name': 'St. Thomas Aquinas', 'titles': '1 Title', 'years': '2013'},
      {'name': 'GSTS Takoradi', 'titles': '1 Title', 'years': '2012'},
      {'name': 'Pope John SHS', 'titles': '1 Title', 'years': '2001'},
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: NeoColors.surface,
        borderRadius: NeoBorders.radiusMd,
        border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
        boxShadow: NeoShadows.card,
      ),
      child: Column(
        children: champions.map((c) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                const Icon(Icons.emoji_events, size: 16, color: NeoColors.gold),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    c['name']!,
                    style: NeoTypography.bodyMedium().copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: NeoColors.surfaceYellow,
                    borderRadius: NeoBorders.radiusSm,
                    border: Border.all(color: NeoColors.border, width: 1),
                  ),
                  child: Text(
                    c['titles']!,
                    style: NeoTypography.caption(color: NeoColors.textPrimary).copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '(${c['years']!})',
                  style: NeoTypography.caption(color: NeoColors.textSecondary),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFooterInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: NeoColors.surfaceMuted,
        borderRadius: NeoBorders.radiusSm,
        border: Border.all(color: NeoColors.border, width: 1),
      ),
      child: Column(
        children: [
          Text(
            'Produced by Primetime Limited • Sponsored by Ghana Education Service (GES)',
            style: NeoTypography.caption(color: NeoColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Official Partners: GOIL PLC, Prudential Life, Joy News, Pepsodent, Trustur AI, Jupay',
            style: NeoTypography.caption(color: NeoColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
