import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Neo-Brutalist Hard Drop Shadows.
/// All shadows feature 0.0 blur radius for a crisp, physical retro-pop feel.
class NeoShadows {
  NeoShadows._();

  /// Standard card shadow (Offset: 4, 4)
  static const List<BoxShadow> card = [
    BoxShadow(
      color: NeoColors.shadow,
      offset: Offset(4.0, 4.0),
      blurRadius: 0.0,
      spreadRadius: 0.0,
    ),
  ];

  /// Elevated / Hero element shadow (Offset: 6, 6)
  static const List<BoxShadow> elevated = [
    BoxShadow(
      color: NeoColors.shadow,
      offset: Offset(6.0, 6.0),
      blurRadius: 0.0,
      spreadRadius: 0.0,
    ),
  ];

  /// Small badge / tab pill shadow (Offset: 2, 2)
  static const List<BoxShadow> pill = [
    BoxShadow(
      color: NeoColors.shadow,
      offset: Offset(2.0, 2.0),
      blurRadius: 0.0,
      spreadRadius: 0.0,
    ),
  ];

  /// Pressed state shadow (Offset: 1, 1)
  static const List<BoxShadow> pressed = [
    BoxShadow(
      color: NeoColors.shadow,
      offset: Offset(1.0, 1.0),
      blurRadius: 0.0,
      spreadRadius: 0.0,
    ),
  ];

  /// Flat / completely collapsed shadow
  static const List<BoxShadow> none = [];

  /// Dynamic shadow generator
  static List<BoxShadow> custom({
    double x = 4.0,
    double y = 4.0,
    Color color = NeoColors.shadow,
  }) => [
    BoxShadow(
      color: color,
      offset: Offset(x, y),
      blurRadius: 0.0,
      spreadRadius: 0.0,
    ),
  ];
}
