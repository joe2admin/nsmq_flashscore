import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Neo-Brutalist Border System.
/// Distinct solid black outlines with consistent corner radii.
class NeoBorders {
  NeoBorders._();

  static const double strokeThin = 1.5;
  static const double strokeDefault = 2.5;
  static const double strokeThick = 3.0;

  // Solid Black Borders
  static Border all([double width = strokeDefault, Color color = NeoColors.border]) =>
      Border.all(color: color, width: width);

  static Border sideOnly({
    double top = 0,
    double bottom = 0,
    double left = 0,
    double right = 0,
    Color color = NeoColors.border,
  }) =>
      Border(
        top: top > 0 ? BorderSide(color: color, width: top) : BorderSide.none,
        bottom: bottom > 0 ? BorderSide(color: color, width: bottom) : BorderSide.none,
        left: left > 0 ? BorderSide(color: color, width: left) : BorderSide.none,
        right: right > 0 ? BorderSide(color: color, width: right) : BorderSide.none,
      );

  // Corner Radii
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(8.0));
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(12.0));
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(16.0));
  static const BorderRadius radiusPill = BorderRadius.all(Radius.circular(999.0));

  // Top-only & Bottom-only Radii (For Folder Tabs)
  static const BorderRadius radiusTabTop = BorderRadius.only(
    topLeft: Radius.circular(12.0),
    topRight: Radius.circular(12.0),
  );
}
