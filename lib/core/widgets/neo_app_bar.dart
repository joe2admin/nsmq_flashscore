import 'package:flutter/material.dart';
import '../../app/theme/app_borders.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_shadows.dart';
import '../../app/theme/app_typography.dart';

/// Standard Neo-Brutalist App Bar for NSMQ Flashscore.
/// Shows official crimson branding, sharp borders, and responsive actions.
class NeoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final bool showLogo;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;

  const NeoAppBar({
    super.key,
    this.title = 'NSMQ FLASHSCORE',
    this.subtitle,
    this.showLogo = true,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: NeoColors.background,
        border: Border(
          bottom: BorderSide(color: NeoColors.border, width: NeoBorders.strokeDefault),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
          child: Row(
            children: [
              if (leading != null)
                leading!
              else if (automaticallyImplyLeading && Navigator.of(context).canPop())
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: NeoColors.surface,
                      borderRadius: NeoBorders.radiusSm,
                      border: Border.all(color: NeoColors.border, width: 2),
                      boxShadow: NeoShadows.pill,
                    ),
                    child: const Icon(Icons.arrow_back, size: 18, color: NeoColors.textPrimary),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),

              if (showLogo && (leading == null && !Navigator.of(context).canPop())) ...[
                Container(
                  width: 38,
                  height: 38,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: NeoBorders.radiusSm,
                    border: Border.all(color: NeoColors.border, width: 2),
                    boxShadow: NeoShadows.pill,
                  ),
                  child: Image.asset(
                    'assets/images/nsmq_logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => const Icon(Icons.flash_on, size: 20, color: NeoColors.nsmqRed),
                  ),
                ),
                const SizedBox(width: 10),
              ],

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: NeoTypography.headingLarge(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: NeoTypography.caption(color: NeoColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),

              ...?actions,
            ],
          ),
        ),
      ),
    );
  }
}
