import 'package:flutter/material.dart';
import 'package:talk/core/theme/app_colors.dart';

/// 应用装饰样式
/// 
/// 定义卡片、按钮、输入框等组件的装饰样式
class AppDecorations {
  AppDecorations._();

  static BoxDecoration get glassCard => BoxDecoration(
    color: AppColors.glassBackground,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: AppColors.glassBorder,
    ),
    boxShadow: const [
      BoxShadow(
        color: AppColors.glassShadow,
        blurRadius: 20,
        offset: Offset(0, 8),
      ),
    ],
  );

  static BoxDecoration get card => BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(16),
    boxShadow: const [
      BoxShadow(
        color: AppColors.shadow,
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration get cardHover => BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(16),
    boxShadow: const [
      BoxShadow(
        color: AppColors.shadow,
        blurRadius: 20,
        offset: Offset(0, 8),
      ),
    ],
  );

  static BoxDecoration gradientCard({
    Color startColor = AppColors.primary,
    Color endColor = AppColors.primaryDark,
  }) => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [startColor, endColor],
    ),
    borderRadius: BorderRadius.circular(16),
    boxShadow: const [
      BoxShadow(
        color: AppColors.shadow,
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
  );

  static InputDecoration inputDecoration({
    String? hintText,
    String? labelText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) => InputDecoration(
    hintText: hintText,
    labelText: labelText,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    filled: true,
    fillColor: AppColors.surfaceVariant,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: AppColors.primary,
        width: 2,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: AppColors.error,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: AppColors.error,
        width: 2,
      ),
    ),
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 14,
    ),
  );

  static BoxDecoration get bottomSheet => const BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(24),
    ),
  );

  static BoxDecoration get dialog => BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(24),
    boxShadow: const [
      BoxShadow(
        color: AppColors.shadow,
        blurRadius: 30,
        offset: Offset(0, 10),
      ),
    ],
  );

  static BoxDecoration get chip => BoxDecoration(
    color: AppColors.surfaceVariant,
    borderRadius: BorderRadius.circular(20),
  );

  static BoxDecoration get chipSelected => BoxDecoration(
    color: AppColors.primaryContainer,
    borderRadius: BorderRadius.circular(20),
  );
}

/// 按钮装饰样式
class ButtonDecorations {
  ButtonDecorations._();

  static BoxDecoration get primary => BoxDecoration(
    gradient: AppColors.primaryGradient,
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withValues(alpha: 0.3),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration get secondary => BoxDecoration(
    color: AppColors.secondary,
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      BoxShadow(
        color: AppColors.secondary.withValues(alpha: 0.3),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration get outline => BoxDecoration(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(24),
    border: Border.all(
      color: AppColors.primary,
      width: 2,
    ),
  );

  static BoxDecoration get ghost => BoxDecoration(
    color: AppColors.primary.withValues(alpha: 0.1),
    borderRadius: BorderRadius.circular(24),
  );
}
