import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../shared/icons.dart';
import '../shared/pill_button.dart';
import '../shared/store_items.dart';
import '../state/app_state.dart';
import '../theme/colors.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});
  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  String _tab = 'Decor';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _Header(level: state.level, gems: state.gems),
            _TabStrip(active: _tab, onPick: (t) => setState(() => _tab = t)),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
                children: const [
                  _StoreGrid(),
                  SizedBox(height: 18),
                  _EarnGemsCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.level, required this.gems});
  final int level;
  final int gems;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lavender200,
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
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
          const Spacer(),
          Text(
            'Level: $level',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(width: 18),
          GemChip(gems: gems),
        ],
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
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: _tabs.map((t) {
          final on = t == active;
          return Expanded(
            child: GestureDetector(
              onTap: () => onPick(t),
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
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
                    fontSize: 14,
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

class _StoreGrid extends StatelessWidget {
  const _StoreGrid();
  @override
  Widget build(BuildContext context) {
    final cards = <_StoreCardData>[
      _StoreCardData(kind: StoreItemKind.table, price: 100, iconSize: 68),
      _StoreCardData(kind: StoreItemKind.plant, price: 100, iconSize: 70),
      _StoreCardData(kind: StoreItemKind.lamp, price: 150, iconSize: 72),
      _StoreCardData(kind: StoreItemKind.picture, price: 120, iconSize: 68),
      _StoreCardData(
        kind: StoreItemKind.plant,
        price: 150,
        iconSize: 70,
        lockedLevel: 3,
      ),
      _StoreCardData(
        kind: StoreItemKind.table,
        price: 200,
        iconSize: 68,
        lockedLevel: 5,
      ),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 160,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: cards.length,
      itemBuilder: (context, i) => _StoreCard(data: cards[i]),
    );
  }
}

class _StoreCardData {
  const _StoreCardData({
    required this.kind,
    required this.price,
    required this.iconSize,
    this.lockedLevel,
  });
  final StoreItemKind kind;
  final int price;
  final double iconSize;
  final int? lockedLevel;
}

class _StoreCard extends StatelessWidget {
  const _StoreCard({required this.data});
  final _StoreCardData data;
  @override
  Widget build(BuildContext context) {
    final locked = data.lockedLevel != null;
    return Container(
      decoration: BoxDecoration(
        color: locked ? AppColors.storeCardLocked : AppColors.storeCardBg,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.fromLTRB(12, 18, 12, 12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Opacity(
                  opacity: locked ? 0.5 : 1,
                  child: Center(
                    child: storeItemFor(data.kind, size: data.iconSize),
                  ),
                ),
              ),
              if (locked)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    'Level ${data.lockedLevel}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              _BuyChip(price: data.price, locked: locked),
            ],
          ),
          if (locked)
            const Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: LockIcon(size: 26, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}

class _BuyChip extends StatelessWidget {
  const _BuyChip({required this.price, required this.locked});
  final int price;
  final bool locked;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: locked ? Colors.white.withValues(alpha: 0.4) : AppColors.cream,
        borderRadius: BorderRadius.circular(999),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Buy',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: locked
                  ? AppColors.ink.withValues(alpha: 0.5)
                  : AppColors.ink,
            ),
          ),
          const SizedBox(width: 6),
          const GemIcon(size: 12),
          const SizedBox(width: 6),
          Text(
            '$price',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: locked
                  ? AppColors.ink.withValues(alpha: 0.5)
                  : AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _EarnGemsCard extends StatelessWidget {
  const _EarnGemsCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F2C2148),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.lavender100,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: const GemIcon(size: 26),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Earn more gems',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Hit a goal, earn 50.',
                  style: TextStyle(fontSize: 12, color: AppColors.inkMute),
                ),
              ],
            ),
          ),
          GhostButton(label: 'Goals', onPressed: () {}),
        ],
      ),
    );
  }
}
