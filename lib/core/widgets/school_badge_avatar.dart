import 'package:flutter/material.dart';
import '../../app/theme/app_borders.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_shadows.dart';
import '../../app/theme/app_typography.dart';
import '../constants/school_assets.dart';

/// Neo-Brutalist School Badge / Crest Avatar.
/// Automatically resolves school crests from assets, network, or name/id lookups,
/// with robust fallback to school initials.
class SchoolBadgeAvatar extends StatelessWidget {
  final String? crestUrl;
  final String? schoolName;
  final String? schoolId;
  final double size;
  final bool isLeader;
  final int? titlesCount;
  final bool isCircle;
  final Color? backgroundColor;
  final bool showBorder;
  final bool showShadow;

  const SchoolBadgeAvatar({
    super.key,
    this.crestUrl,
    this.schoolName,
    this.schoolId,
    this.size = 36.0,
    this.isLeader = false,
    this.titlesCount,
    this.isCircle = false,
    this.backgroundColor,
    this.showBorder = true,
    this.showShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Resolve crest path
    final resolvedPath = crestUrl ??
        SchoolAssets.getBadge(schoolId) ??
        SchoolAssets.getBadge(schoolName);

    final borderRadius = isCircle
        ? BorderRadius.circular(size / 2)
        : (size > 48 ? NeoBorders.radiusMd : NeoBorders.radiusSm);

    final bg = backgroundColor ??
        (isLeader ? NeoColors.surfaceYellow : Colors.white);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: borderRadius,
        border: showBorder
            ? Border.all(
                color: isLeader ? NeoColors.nsmqRed : NeoColors.border,
                width: isLeader ? 2.0 : (size > 48 ? 2.0 : NeoBorders.strokeThin),
              )
            : null,
        boxShadow: showShadow
            ? (isLeader ? NeoShadows.pill : NeoShadows.card)
            : null,
      ),
      child: ClipRRect(
        borderRadius: isCircle ? BorderRadius.circular(size / 2) : borderRadius,
        child: Padding(
          padding: EdgeInsets.all(size * 0.08),
          child: resolvedPath != null
              ? _buildImage(resolvedPath)
              : _buildFallback(),
        ),
      ),
    );
  }

  Widget _buildImage(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => _buildFallback(),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Center(
            child: SizedBox(
              width: size * 0.4,
              height: size * 0.4,
              child: const CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
      );
    }

    return Image.asset(
      path,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => _buildFallback(),
    );
  }

  Widget _buildFallback() {
    final name = (schoolName ?? schoolId ?? 'S').trim();
    String initials = 'S';
    if (name.isNotEmpty) {
      final words = name.split(RegExp(r'\s+'));
      if (words.length >= 2) {
        initials = '${words[0][0]}${words[1][0]}'.toUpperCase();
      } else {
        initials = name.substring(0, 1).toUpperCase();
      }
    }

    return Center(
      child: Text(
        initials,
        style: NeoTypography.headingMedium(
          color: isLeader ? NeoColors.nsmqRed : NeoColors.nsmqBlue,
        ).copyWith(
          fontSize: size * 0.38,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
