import 'package:flutter/material.dart';

import '../theme/colors.dart';

class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
    this.fontSize = 15,
    this.fullWidth = false,
  });

  final String label;
  final VoidCallback onPressed;
  final EdgeInsets padding;
  final double fontSize;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0x0A2C2148)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F2C2148),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
      ),
    );
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onPressed,
        child: fullWidth
            ? SizedBox(width: double.infinity, child: child)
            : child,
      ),
    );
  }
}

class CtaButton extends StatelessWidget {
  const CtaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.fullWidth = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.ctaStart, AppColors.ctaMid, AppColors.ctaEnd],
          stops: [0.0, 0.5, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.ctaOutline, width: 2),
        boxShadow: const [
          BoxShadow(
            color: AppColors.ctaShadow,
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
      ),
    );
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onPressed,
        child: fullWidth
            ? SizedBox(width: double.infinity, child: child)
            : child,
      ),
    );
  }
}

class GhostButton extends StatelessWidget {
  const GhostButton({super.key, required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.lavender300, width: 1.5),
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.inkSoft,
            ),
          ),
        ),
      ),
    );
  }
}
