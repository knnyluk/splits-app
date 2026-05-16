import 'package:flutter/material.dart';

import '../theme/colors.dart';
import 'icons.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({
    super.key,
    this.showBack = false,
    this.title,
    this.level = 1,
    this.gems = 350,
    this.tall = false,
    this.onBack,
    this.centerTitle = false,
    this.showLevel = true,
    this.showGems = true,
  });

  final bool showBack;
  final String? title;
  final int level;
  final int gems;
  final bool tall;
  final VoidCallback? onBack;
  final bool centerTitle;
  final bool showLevel;
  final bool showGems;

  @override
  Size get preferredSize => Size.fromHeight(tall ? 72 : 60);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lavender200,
      padding: EdgeInsets.fromLTRB(18, 12, 18, tall ? 24 : 18),
      child: Row(
        children: [
          if (showBack)
            _IconButton(
              onTap: onBack ?? () => Navigator.of(context).maybePop(),
              child: const BackIcon(),
            ),
          if (showBack && title != null) const SizedBox(width: 8),
          if (title != null && !centerTitle)
            Expanded(
              child: Text(
                title!,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            )
          else if (centerTitle && title != null)
            Expanded(
              child: Center(
                child: Text(
                  title!,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ),
            )
          else
            const Spacer(),
          if (showLevel) ...[
            Text(
              'Level: $level',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(width: 18),
          ],
          if (showGems) GemChip(gems: gems),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({required this.onTap, required this.child});
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 22,
      child: SizedBox(width: 36, height: 36, child: Center(child: child)),
    );
  }
}
