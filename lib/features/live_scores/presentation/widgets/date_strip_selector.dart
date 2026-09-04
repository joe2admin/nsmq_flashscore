import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme/app_borders.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_typography.dart';

class DateStripSelector extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const DateStripSelector({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    // Generate range: 3 days back to 3 days ahead
    final dates = List.generate(7, (i) => today.add(Duration(days: i - 2)));

    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: NeoColors.background,
        border: Border(
          bottom: BorderSide(color: NeoColors.border, width: NeoBorders.strokeDefault),
        ),
      ),
      child: Row(
        children: [
          // Calendar picker button
          Container(
            margin: const EdgeInsets.only(left: 12, right: 8),
            decoration: BoxDecoration(
              color: NeoColors.surface,
              borderRadius: NeoBorders.radiusSm,
              border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
              boxShadow: NeoShadows.pill,
            ),
            child: IconButton(
              icon: const Icon(Icons.calendar_month, color: NeoColors.textPrimary, size: 20),
              tooltip: 'Choose Date',
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(now.year - 1),
                  lastDate: DateTime(now.year + 1),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: NeoColors.nsmqRed,
                          onPrimary: NeoColors.textLight,
                          surface: NeoColors.surface,
                          onSurface: NeoColors.textPrimary,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null) {
                  onDateSelected(picked);
                }
              },
            ),
          ),

          // Horizontal scrollable date pills
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              itemCount: dates.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final date = dates[index];
                final isSelected = date.year == selectedDate.year &&
                    date.month == selectedDate.month &&
                    date.day == selectedDate.day;
                final isToday = date.year == today.year &&
                    date.month == today.month &&
                    date.day == today.day;

                String dayLabel;
                if (isToday) {
                  dayLabel = 'TODAY';
                } else if (date == today.subtract(const Duration(days: 1))) {
                  dayLabel = 'YEST';
                } else if (date == today.add(const Duration(days: 1))) {
                  dayLabel = 'TOM';
                } else {
                  dayLabel = DateFormat('EEE').format(date).toUpperCase();
                }

                return GestureDetector(
                  onTap: () => onDateSelected(date),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? NeoColors.nsmqRed
                          : (isToday ? NeoColors.surfaceYellow : NeoColors.surface),
                      borderRadius: NeoBorders.radiusSm,
                      border: Border.all(
                        color: NeoColors.border,
                        width: NeoBorders.strokeDefault,
                      ),
                      boxShadow: isSelected ? NeoShadows.pill : NeoShadows.pill,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dayLabel,
                          style: NeoTypography.badge(
                            color: isSelected ? NeoColors.textLight : NeoColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          DateFormat('d MMM').format(date).toUpperCase(),
                          style: NeoTypography.bodyBold(
                            size: 11,
                            color: isSelected ? NeoColors.textLight : NeoColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
