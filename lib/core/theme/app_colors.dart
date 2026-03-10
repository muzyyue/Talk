import 'package:flutter/material.dart';

/// 应用色彩系统
/// 
/// 定义应用的主色调、辅助色、中性色等
/// 主色调采用蓝色系 (#4A90D9)
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF4A90D9);
  static const Color primaryLight = Color(0xFF87CEEB);
  static const Color primaryDark = Color(0xFF2E5C8A);
  static const Color primaryContainer = Color(0xFFD6E9FF);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF001D36);

  static const Color secondary = Color(0xFF6C5CE7);
  static const Color secondaryLight = Color(0xFF9D91FF);
  static const Color secondaryDark = Color(0xFF5041B2);
  static const Color secondaryContainer = Color(0xFFE7E4FF);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF1D0066);

  static const Color accent = Color(0xFF00B894);
  static const Color accentLight = Color(0xFF55EFC4);
  static const Color accentDark = Color(0xFF00A085);
  static const Color accentContainer = Color(0xFFCCF5E9);
  static const Color onAccentContainer = Color(0xFF002117);

  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  static const Color onBackground = Color(0xFF212121);
  static const Color onSurface = Color(0xFF212121);
  static const Color onSurfaceVariant = Color(0xFF757575);

  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textDisabled = Color(0xFF9E9E9E);

  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x1F000000);

  static const Color glassBackground = Color(0x80FFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color glassShadow = Color(0x1A000000);

  static const Color gradientStart = primary;
  static const Color gradientEnd = primaryDark;

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientEnd],
  );

  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0x40FFFFFF), Color(0x20FFFFFF)],
  );
}

/// 深色模式色彩
class AppColorsDark {
  AppColorsDark._();

  static const Color primary = Color(0xFF87CEEB);
  static const Color primaryLight = Color(0xFFB8E0F5);
  static const Color primaryDark = Color(0xFF4A90D9);
  static const Color primaryContainer = Color(0xFF1A3A5C);
  static const Color onPrimary = Color(0xFF001D36);
  static const Color onPrimaryContainer = Color(0xFFD6E9FF);

  static const Color secondary = Color(0xFF9D91FF);
  static const Color secondaryLight = Color(0xFFBEB5FF);
  static const Color secondaryDark = Color(0xFF6C5CE7);
  static const Color secondaryContainer = Color(0xFF2D2266);
  static const Color onSecondary = Color(0xFF1D0066);
  static const Color onSecondaryContainer = Color(0xFFE7E4FF);

  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);
  static const Color surfaceVariant = Color(0xFF2C2C2C);
  static const Color onBackground = Color(0xFFECECEC);
  static const Color onSurface = Color(0xFFECECEC);
  static const Color onSurfaceVariant = Color(0xFFB0B0B0);

  static const Color textPrimary = Color(0xFFECECEC);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textHint = Color(0xFF757575);
  static const Color textDisabled = Color(0xFF616161);

  static const Color divider = Color(0xFF424242);
  static const Color border = Color(0xFF424242);
  static const Color shadow = Color(0x3D000000);

  static const Color glassBackground = Color(0x80000000);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color glassShadow = Color(0x1AFFFFFF);
}
