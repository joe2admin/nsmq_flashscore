import 'package:flutter/material.dart';
import '../../../../app/theme/app_borders.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_typography.dart';
import '../../domain/entities/contest.dart';

class FilterChipsRow extends StatelessWidget {
  final ContestStatus? selectedStatus;
  final ValueChanged<ContestStatus?> onStatusChanged;
  final int liveCount;

  const FilterChipsRow({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
    this.liveCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          _FilterPill(
            label: 'ALL',
            isSelected: selectedStatus == null,
            onTap: () => onStatusChanged(null),
          ),
          const SizedBox(width: 6),
          _FilterPill(
            label: 'LIVE',
            badgeCount: liveCount > 0 ? liveCount : null,
            isLive: true,
            isSelected: selectedStatus == ContestStatus.live,
            onTap: () => onStatusChanged(ContestStatus.live),
          ),
          const SizedBox(width: 6),
          _FilterPill(
            label: 'UPCOMING',
            isSelected: selectedStatus == ContestStatus.scheduled,
            onTap: () => onStatusChanged(ContestStatus.scheduled),
          ),
          const SizedBox(width: 6),
          _FilterPill(
            label: 'FINISHED',
            isSelected: selectedStatus == ContestStatus.finished,
            onTap: () => onStatusChanged(ContestStatus.finished),
          ),
        ],
      ),
    );
  }
}

class _FilterPill extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final int? badgeCount;
  final bool isLive;

  const _FilterPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.badgeCount,
    this.isLive = false,
  });

  @override
  State<_FilterPill> createState() => _FilterPillState();
}

class _FilterPillState extends State<_FilterPill> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final Color activeBg = widget.isLive ? NeoColors.nsmqBrightRed : NeoColors.textPrimary;
    final Color activeText = NeoColors.textLight;

    final translateOffset = _isPressed ? const Offset(1.5, 1.5) : Offset.zero;
    final effectiveShadow = _isPressed
        ? const [
            BoxShadow(
              color: NeoColors.shadow,
              offset: Offset(0.5, 0.5),
              blurRadius: 0.0,
            ),
          ]
        : NeoShadows.pill;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 60),
          transform: Matrix4.translationValues(translateOffset.dx, translateOffset.dy, 0),
          height: 34.0,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.isSelected ? activeBg : NeoColors.surface,
            borderRadius: NeoBorders.radiusSm,
            border: Border.all(
              color: NeoColors.border,
              width: NeoBorders.strokeDefault,
            ),
            boxShadow: effectiveShadow,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.label,
                    style: NeoTypography.badge(
                      color: widget.isSelected ? activeText : NeoColors.textPrimary,
                    ).copyWith(fontSize: 10),
                    maxLines: 1,
                  ),
                ),
              ),
              if (widget.badgeCount != null) ...[
                const SizedBox(width: 3),
                Container(
                  height: 16,
                  constraints: const BoxConstraints(minWidth: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: widget.isSelected ? NeoColors.textLight : NeoColors.nsmqBrightRed,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${widget.badgeCount}',
                    style: NeoTypography.bodyBold(
                      size: 9,
                      color: widget.isSelected ? NeoColors.nsmqBrightRed : NeoColors.textLight,
                    ).copyWith(height: 1.0),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
