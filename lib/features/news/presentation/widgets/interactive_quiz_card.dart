import 'package:flutter/material.dart';
import '../../../../app/theme/app_borders.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/neo_button.dart';

class InteractiveQuizCard extends StatelessWidget {
  final int selectedOption;
  final bool isSubmitted;
  final int correctOption;
  final ValueChanged<int> onSelectOption;
  final VoidCallback onReset;

  const InteractiveQuizCard({
    super.key,
    required this.selectedOption,
    required this.isSubmitted,
    required this.correctOption,
    required this.onSelectOption,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    const options = [
      'A) 12V AC',
      'B) 24V AC',
      'C) 48V AC',
      'D) 2400V AC',
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: NeoColors.surface,
        borderRadius: NeoBorders.radiusMd,
        border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
        boxShadow: NeoShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: NeoColors.nsmqElectricBlue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(NeoBorders.sm),
                topRight: Radius.circular(NeoBorders.sm),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.bolt, color: NeoColors.textLight, size: 18),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          'DAILY FAN RIDDLE & PROBLEM',
                          style: NeoTypography.badge(color: NeoColors.textLight),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: NeoColors.gold,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: NeoColors.border, width: 1),
                  ),
                  child: Text(
                    '+5 PTS',
                    style: NeoTypography.badge(color: NeoColors.textPrimary).copyWith(fontSize: 10),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Physics • Electromagnetism',
                  style: NeoTypography.caption(color: NeoColors.nsmqBlue),
                ),
                const SizedBox(height: 4),
                Text(
                  'An ideal transformer has 500 turns in the primary coil and 50 turns in the secondary coil. If the primary voltage is 240V AC, what is the secondary output voltage?',
                  style: NeoTypography.bodyBold(size: 13),
                ),
                const SizedBox(height: 12),

                // Options
                for (int i = 0; i < options.length; i++) ...[
                  _buildOptionTile(
                    text: options[i],
                    index: i,
                  ),
                  if (i < options.length - 1) const SizedBox(height: 8),
                ],

                if (isSubmitted) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: selectedOption == correctOption
                          ? NeoColors.surfaceYellow
                          : NeoColors.surfaceRed,
                      borderRadius: NeoBorders.radiusSm,
                      border: Border.all(color: NeoColors.border, width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedOption == correctOption
                              ? '🎉 SPOT ON! +5 POINTS EARNED!'
                              : '❌ INCORRECT. THE CORRECT ANSWER IS (B) 24V.',
                          style: NeoTypography.bodyBold(
                            size: 12,
                            color: selectedOption == correctOption
                                ? NeoColors.textPrimary
                                : NeoColors.nsmqBrightRed,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Formula: Vs = Vp × (Ns / Np) = 240V × (50 / 500) = 24V.',
                          style: NeoTypography.caption(color: NeoColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: NeoButton(
                      text: 'TRY ANOTHER',
                      onPressed: onReset,
                      isDense: true,
                      backgroundColor: NeoColors.surfaceMuted,
                      textColor: NeoColors.textPrimary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({required String text, required int index}) {
    Color bg = NeoColors.surfaceMuted;
    Color border = NeoColors.border;

    if (isSubmitted) {
      if (index == correctOption) {
        bg = const Color(0xFFD1FAE5); // soft green
        border = NeoColors.green;
      } else if (index == selectedOption) {
        bg = NeoColors.surfaceRed;
        border = NeoColors.nsmqBrightRed;
      }
    }

    return GestureDetector(
      onTap: () => onSelectOption(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: NeoBorders.radiusSm,
          border: Border.all(color: border, width: isSubmitted && (index == correctOption || index == selectedOption) ? 2 : 1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: NeoTypography.bodyBold(size: 12),
              ),
            ),
            if (isSubmitted && index == correctOption)
              const Icon(Icons.check_circle, color: NeoColors.green, size: 18)
            else if (isSubmitted && index == selectedOption)
              const Icon(Icons.cancel, color: NeoColors.nsmqBrightRed, size: 18),
          ],
        ),
      ),
    );
  }
}
