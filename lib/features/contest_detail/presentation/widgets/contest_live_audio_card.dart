import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/theme/app_borders.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/nsmq_constants.dart';
import '../controllers/contest_detail_controller.dart';

class ContestLiveAudioCard extends StatefulWidget {
  const ContestLiveAudioCard({super.key});

  @override
  State<ContestLiveAudioCard> createState() => _ContestLiveAudioCardState();
}

class _ContestLiveAudioCardState extends State<ContestLiveAudioCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ContestDetailController>();

    return Obx(() {
      final isPlaying = controller.isAudioPlaying.value;
      final isBuffering = controller.isAudioBuffering.value;
      final isMuted = controller.isAudioMuted.value;
      final isExpanded = controller.isAudioExpanded.value;
      final error = controller.audioError.value;
      final contest = controller.contestDetail.value?.contest;

      return Container(
        margin: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 6.0),
        decoration: BoxDecoration(
          color: NeoColors.surface,
          borderRadius: NeoBorders.radiusMd,
          border: Border.all(
            color: NeoColors.border,
            width: NeoBorders.strokeDefault,
          ),
          boxShadow: NeoShadows.card,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Bar
            InkWell(
              onTap: controller.toggleAudioExpanded,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(NeoBorders.md - 2),
                topRight: Radius.circular(NeoBorders.md - 2),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: const BoxDecoration(
                  color: NeoColors.darkCanvas,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(NeoBorders.md - 2),
                    topRight: Radius.circular(NeoBorders.md - 2),
                  ),
                ),
                child: Row(
                  children: [
                    // Pulsing Live Dot
                    AnimatedBuilder(
                      animation: _animController,
                      builder: (context, child) {
                        final opacity = isPlaying
                            ? 0.3 + (_animController.value * 0.7)
                            : 1.0;
                        return Container(
                          width: 9,
                          height: 9,
                          margin: const EdgeInsets.only(right: 7),
                          decoration: BoxDecoration(
                            color: isPlaying
                                ? NeoColors.nsmqBrightRed.withValues(alpha: opacity)
                                : NeoColors.nsmqBrightRed,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: NeoColors.surface,
                              width: 1.5,
                            ),
                          ),
                        );
                      },
                    ),

                    // Title
                    Expanded(
                      child: Text(
                        'NSMQ LIVE AUDIO • RADIO FEED',
                        style: NeoTypography.badge(color: NeoColors.textLight).copyWith(
                          letterSpacing: 0.8,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    // Live Pill Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: isPlaying ? NeoColors.nsmqBrightRed : NeoColors.surfaceYellow,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: NeoColors.border, width: 1),
                      ),
                      child: Text(
                        isPlaying ? 'ON AIR' : 'LIVE FEED',
                        style: NeoTypography.badge(
                          color: isPlaying ? NeoColors.textLight : NeoColors.textPrimary,
                        ).copyWith(fontSize: 9),
                      ),
                    ),

                    // Expand / Collapse Chevron
                    Icon(
                      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: NeoColors.textLight,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),

            // Controls Body (Collapsible)
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                child: Row(
                  children: [
                    // Play / Pause Button
                    GestureDetector(
                      onTap: controller.toggleAudioPlayback,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isPlaying ? NeoColors.nsmqRed : NeoColors.gold,
                          borderRadius: NeoBorders.radiusSm,
                          border: Border.all(
                            color: NeoColors.border,
                            width: NeoBorders.strokeDefault,
                          ),
                          boxShadow: NeoShadows.pill,
                        ),
                        child: Center(
                          child: isBuffering
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: NeoColors.textPrimary,
                                  ),
                                )
                              : Icon(
                                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                  color: isPlaying ? NeoColors.textLight : NeoColors.textPrimary,
                                  size: 28,
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // Animated Equalizer Frequency Bars
                    _buildEqualizerBars(isPlaying),

                    const SizedBox(width: 10),

                    // Metadata & Status
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isPlaying
                                ? (contest != null
                                    ? '${contest.title} (${contest.stage})'
                                    : 'Live Contest')
                                : 'Tap Play to Listen',
                            style: NeoTypography.headingMedium().copyWith(fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            error ?? NsmqConstants.defaultAudioStationName,
                            style: NeoTypography.caption(
                              color: error != null
                                  ? NeoColors.nsmqBrightRed
                                  : NeoColors.textSecondary,
                            ).copyWith(fontSize: 10),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Mute / Unmute Button
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isMuted ? NeoColors.surfaceRed : NeoColors.neutralMuted,
                          borderRadius: NeoBorders.radiusSm,
                          border: Border.all(
                            color: NeoColors.border,
                            width: NeoBorders.strokeThin,
                          ),
                        ),
                        child: Icon(
                          isMuted ? Icons.volume_off : Icons.volume_up,
                          size: 16,
                          color: isMuted ? NeoColors.nsmqBrightRed : NeoColors.textPrimary,
                        ),
                      ),
                      onPressed: controller.toggleAudioMute,
                      tooltip: isMuted ? 'Unmute' : 'Mute',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              )
            else
              // Slim Compact Bar when collapsed
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: controller.toggleAudioPlayback,
                      child: Icon(
                        isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                        color: isPlaying ? NeoColors.nsmqRed : NeoColors.textPrimary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isPlaying ? 'Broadcasting live audio...' : 'Audio paused (tap to play)',
                        style: NeoTypography.caption(
                          color: isPlaying ? NeoColors.nsmqBlue : NeoColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _buildEqualizerBars(isPlaying, compact: true),
                  ],
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildEqualizerBars(bool isPlaying, {bool compact = false}) {
    final barCount = compact ? 3 : 4;
    final maxHeights = compact ? [14.0, 18.0, 12.0] : [14.0, 24.0, 18.0, 22.0];
    final minHeights = compact ? [4.0, 5.0, 4.0] : [4.0, 6.0, 5.0, 4.0];
    final colors = [
      NeoColors.nsmqRed,
      NeoColors.nsmqBlue,
      NeoColors.gold,
      NeoColors.green,
    ];

    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(barCount, (i) {
            final phase = (i * 0.25);
            final wave = isPlaying
                ? ((_animController.value + phase) % 1.0)
                : 0.0;
            final currentHeight = minHeights[i] +
                (maxHeights[i] - minHeights[i]) *
                    (isPlaying ? (wave > 0.5 ? 2 * (1 - wave) : 2 * wave) : 0.0);

            return Container(
              width: 3.5,
              height: currentHeight,
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
              decoration: BoxDecoration(
                color: isPlaying ? colors[i % colors.length] : NeoColors.neutralMuted,
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: NeoColors.border, width: 0.8),
              ),
            );
          }),
        );
      },
    );
  }
}
