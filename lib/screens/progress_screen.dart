import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../shared/app_header.dart';
import '../shared/icons.dart';
import '../shared/pill_button.dart';
import '../shared/progress_chart.dart';
import '../state/app_state.dart';
import '../theme/colors.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  SplitSide _side = SplitSide.left;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppHeader(showBack: true, level: state.level, gems: state.gems),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
                children: [
                  PillButton(
                    label: 'Begin Warmup',
                    fullWidth: true,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 12),
                  CtaButton(
                    label: 'Start Training',
                    fullWidth: true,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'Your Progress',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  ProgressChart(side: _side),
                  const SizedBox(height: 12),
                  _TabRow(
                    options: const ['Left', 'Right', 'Middle'],
                    selected: switch (_side) {
                      SplitSide.left => 'Left',
                      SplitSide.right => 'Right',
                      SplitSide.middle => 'Middle',
                    },
                    onSelect: (v) => setState(
                      () => _side = switch (v) {
                        'Left' => SplitSide.left,
                        'Right' => SplitSide.right,
                        _ => SplitSide.middle,
                      },
                    ),
                  ),
                  const SizedBox(height: 22),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.mint300, width: 1.5),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: const Text(
                      'Your Goals',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const _GoalBar(
                    label: 'Custom Goal',
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [AppColors.lavender200, AppColors.lavender300],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const _GoalBar(
                    label: '120° — Beginner',
                    checked: true,
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [0.0, 0.5, 1.0],
                      colors: [
                        AppColors.peach200,
                        Color(0xFFE9E1D2),
                        Color(0xFFC9E5CE),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const _GoalBar(
                    label: '135° — Flex Curious',
                    checked: true,
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFFD9DFEC), Color(0xFFEAD8DC)],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const _GoalBar(
                    label: '150° — Bendy',
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [0.0, 0.5, 1.0],
                      colors: [
                        Color(0xFFFBC0A0),
                        AppColors.peach300,
                        Color(0xFFF08989),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const _GoalBar(
                    label: '180° — Splits!',
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFFB7DDC4), Color(0xFFA6E3D2)],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabRow extends StatelessWidget {
  const _TabRow({
    required this.options,
    required this.selected,
    required this.onSelect,
  });
  final List<String> options;
  final String selected;
  final void Function(String) onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: options.map((label) {
        final active = label == selected;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: GestureDetector(
            onTap: () => onSelect(label),
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: active ? AppColors.lavender100 : AppColors.cream,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: active ? AppColors.lavender200 : AppColors.line,
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: active ? AppColors.ink : AppColors.inkSoft,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _GoalBar extends StatelessWidget {
  const _GoalBar({
    required this.label,
    required this.gradient,
    this.checked = false,
  });
  final String label;
  final LinearGradient gradient;
  final bool checked;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: checked
                  ? AppColors.mint300
                  : Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: checked
                    ? AppColors.mint300
                    : AppColors.ink.withValues(alpha: 0.15),
                width: 1.5,
              ),
            ),
            alignment: Alignment.center,
            child: checked ? const CheckIcon(size: 12) : null,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
