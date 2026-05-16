import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../shared/icons.dart';
import '../shared/store_items.dart';
import '../state/app_state.dart';
import '../theme/colors.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});
  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  String _tab = 'Decor';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final totalOwned = state.owned.values.fold<int>(0, (a, b) => a + b);
    final items = state.owned.keys.toList();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              color: AppColors.lavender200,
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
              child: Row(
                children: [
                  InkResponse(
                    radius: 22,
                    onTap: () => Navigator.of(context).maybePop(),
                    child: const SizedBox(
                      width: 36,
                      height: 36,
                      child: Center(child: BackIcon()),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Inventory',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const Spacer(),
                  GemChip(gems: state.gems),
                ],
              ),
            ),
            _TabStrip(active: _tab, onPick: (t) => setState(() => _tab = t)),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(14, 16, 14, 24),
                children: [
                  _SummaryCard(itemsOwned: totalOwned),
                  const SizedBox(height: 14),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisExtent: 150,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemCount: items.length,
                    itemBuilder: (context, i) => _InventoryCard(
                      kind: items[i],
                      owned: state.owned[items[i]] ?? 0,
                      placed: state.isPlaced(items[i]),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const _UnlockBanner(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabStrip extends StatelessWidget {
  const _TabStrip({required this.active, required this.onPick});
  final String active;
  final void Function(String) onPick;
  static const _tabs = ['Decor', 'Style', 'Plants', 'Pets'];
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lavender200,
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: _tabs.map((t) {
          final on = t == active;
          return Expanded(
            child: GestureDetector(
              onTap: () => onPick(t),
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: on ? AppColors.cream : Colors.transparent,
                  borderRadius: on
                      ? const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        )
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  t,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: on ? FontWeight.w700 : FontWeight.w600,
                    color: on
                        ? AppColors.ink
                        : AppColors.ink.withValues(alpha: 0.55),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.itemsOwned});
  final int itemsOwned;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F2C2148),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Text(
            '$itemsOwned items owned',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
          const Spacer(),
          const Text(
            'Tap to place →',
            style: TextStyle(fontSize: 12, color: AppColors.inkMute),
          ),
        ],
      ),
    );
  }
}

class _InventoryCard extends StatelessWidget {
  const _InventoryCard({
    required this.kind,
    required this.owned,
    required this.placed,
  });
  final StoreItemKind kind;
  final int owned;
  final bool placed;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.storeCardBg,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.fromLTRB(10, 14, 10, 12),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 70,
                child: Center(child: storeItemFor(kind, size: 56)),
              ),
              const SizedBox(height: 6),
              Text(
                labelFor(kind),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '×$owned',
                style: const TextStyle(fontSize: 11, color: AppColors.inkMute),
              ),
            ],
          ),
          if (placed)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.mint300,
                  borderRadius: BorderRadius.circular(999),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: const Text(
                  'PLACED',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _UnlockBanner extends StatelessWidget {
  const _UnlockBanner();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.lavender100, Color(0xFFC9E5DC)],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: const Text('✨', style: TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unlock more at Level 3',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Train 2 more days to level up.',
                  style: TextStyle(fontSize: 11, color: AppColors.inkMute),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
