import 'package:intl/intl.dart';

class NumberFormatter {
  const NumberFormatter._();

  /// Formats engagement and social counts (likes, comments, shares).
  /// Shortens to "K" and "M" only when the numbers reach 10,000 and above.
  /// Numbers below 10,000 are formatted with commas (e.g. 1,420, 9,999).
  static String formatCount(int count) {
    if (count >= 1000000) {
      final val = count / 1000000.0;
      final formatted = val >= 100 ? val.toStringAsFixed(0) : val.toStringAsFixed(1);
      final clean = formatted.endsWith('.0') ? formatted.substring(0, formatted.length - 2) : formatted;
      return '${clean}M';
    }
    if (count >= 10000) {
      final val = count / 1000.0;
      final formatted = val >= 100 ? val.toStringAsFixed(0) : val.toStringAsFixed(1);
      final clean = formatted.endsWith('.0') ? formatted.substring(0, formatted.length - 2) : formatted;
      return '${clean}K';
    }
    if (count >= 1000) {
      return NumberFormat('#,###').format(count);
    }
    return count.toString();
  }
}
