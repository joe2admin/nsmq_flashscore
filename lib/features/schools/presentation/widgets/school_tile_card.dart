import 'package:flutter/material.dart';
import '../../../../app/theme/app_borders.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/school_badge_avatar.dart';
import '../../domain/entities/school_profile.dart';

class SchoolTileCard extends StatelessWidget {
  final SchoolProfile profile;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;

  const SchoolTileCard({
    super.key,
    required this.profile,
    this.onTap,
    this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    final school = profile.school;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: NeoColors.surface,
        borderRadius: NeoBorders.radiusMd,
        border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
        boxShadow: NeoShadows.card,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: NeoBorders.radiusMd,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // School Crest Badge with Champion Ribbon
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SchoolBadgeAvatar(
                      crestUrl: school.crestUrl,
                      schoolId: school.id,
                      schoolName: school.shortName.isNotEmpty
                          ? school.shortName
                          : school.name,
                      size: 46,
                      isLeader: school.titlesCount > 0,
                      showShadow: true,
                    ),
                    if (school.titlesCount > 0)
                      Positioned(
                        right: -4,
                        bottom: -4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: NeoColors.gold,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: NeoColors.border, width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.emoji_events, size: 10, color: NeoColors.nsmqRed),
                              Text(
                                '${school.titlesCount}x',
                                style: NeoTypography.badge(color: NeoColors.textPrimary).copyWith(fontSize: 8),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(width: 12),

                // Name & Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              school.shortName.isNotEmpty ? school.shortName : school.name,
                              style: NeoTypography.headingMedium(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${profile.city} • ${school.region}',
                        style: NeoTypography.caption(color: NeoColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Record: ${profile.highestScoreRecord} • ${profile.finalsAppearances} Finals',
                        style: NeoTypography.badge(color: NeoColors.nsmqBlue).copyWith(fontSize: 10),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Favorite Toggle
                IconButton(
                  icon: Icon(
                    profile.isFavorite ? Icons.star : Icons.star_border,
                    color: profile.isFavorite ? NeoColors.gold : NeoColors.textSecondary,
                    size: 24,
                  ),
                  onPressed: onFavoriteTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
