import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../shared/app_header.dart';
import '../shared/avatar.dart';
import '../shared/icons.dart';
import '../shared/pill_button.dart';
import '../shared/store_items.dart';
import '../state/app_state.dart';
import '../theme/colors.dart';

class RoomScreen extends StatefulWidget {
  const RoomScreen({super.key});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  bool _panelOpen = false;
  String _panelTab = 'Decor';

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AppHeader(level: state.level, gems: state.gems),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background: pink wall (62%) + mauve floor (38%) + baseboard
                  const _RoomBackground(),
                  Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: PillButton(
                            label: 'Start',
                            onPressed: () =>
                                Navigator.of(context).pushNamed('/progress'),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 36,
                              vertical: 10,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: _Window(
                            placed: state.placed,
                            compact: _panelOpen,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Side chevrons — tap to toggle panel (the "place items" mode)
                  Positioned(
                    left: 8,
                    top: 0,
                    bottom: 0,
                    child: _Chev(
                      dir: ChevDir.left,
                      onTap: () => setState(() => _panelOpen = false),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 0,
                    bottom: 0,
                    child: _Chev(
                      dir: ChevDir.right,
                      onTap: () => setState(() => _panelOpen = true),
                    ),
                  ),
                  // Character
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: _panelOpen ? 240 : 80,
                    child: Center(
                      child: GestureDetector(
                        onTap: () =>
                            Navigator.of(context).pushNamed('/customize-edit'),
                        child: Avatar(
                          pose: _panelOpen
                              ? AvatarPose.bust
                              : AvatarPose.meditate,
                          size: _panelOpen ? 110 : 180,
                          skin: state.skin,
                          hair: state.hair,
                          outfit: state.outfit,
                          pants: state.pants,
                        ),
                      ),
                    ),
                  ),
                  // Bottom area
                  if (_panelOpen)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: _StorePanel(
                        activeTab: _panelTab,
                        onTab: (t) => setState(() => _panelTab = t),
                        onClose: () => setState(() => _panelOpen = false),
                      ),
                    )
                  else
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 14,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          PillButton(
                            label: 'Go to Store',
                            fontSize: 13,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            onPressed: () =>
                                Navigator.of(context).pushNamed('/store'),
                          ),
                          PillButton(
                            label: 'Inventory',
                            fontSize: 13,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,
                              vertical: 10,
                            ),
                            onPressed: () =>
                                Navigator.of(context).pushNamed('/inventory'),
                          ),
                        ],
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

class _RoomBackground extends StatelessWidget {
  const _RoomBackground();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final wallH = c.maxHeight * 0.62;
        return Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.roomWallTop, AppColors.roomWallTop],
                ),
              ),
            ),
            Positioned(
              top: wallH,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(color: AppColors.roomWallBottom),
            ),
            Positioned(
              top: wallH,
              left: 0,
              right: 0,
              child: Container(
                height: 14,
                decoration: const BoxDecoration(
                  color: AppColors.roomBaseboard,
                  border: Border(
                    top: BorderSide(color: Color(0x0F000000), width: 1),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Window extends StatelessWidget {
  const _Window({required this.placed, required this.compact});
  final List<StoreItemKind?> placed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final width = compact ? 240.0 : 280.0;
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // sill
          Container(
            height: 14,
            decoration: BoxDecoration(
              color: AppColors.windowSill,
              borderRadius: BorderRadius.circular(4),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
          // frame + grid
          Container(
            decoration: BoxDecoration(
              color: AppColors.windowBg,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppColors.windowFrame, width: 3),
            ),
            padding: const EdgeInsets.all(4),
            child: SizedBox(
              height: compact ? 240 : 270,
              child: Column(
                children: [
                  Expanded(flex: 12, child: _row(0)),
                  const SizedBox(height: 4),
                  Expanded(flex: 10, child: _row(3)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(int offset) {
    return Row(
      children: [
        Expanded(flex: 10, child: _cell(placed[offset])),
        const SizedBox(width: 4),
        Expanded(flex: 14, child: _cell(placed[offset + 1])),
        const SizedBox(width: 4),
        Expanded(flex: 10, child: _cell(placed[offset + 2])),
      ],
    );
  }

  Widget _cell(StoreItemKind? kind) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.windowGlass,
        border: Border.all(color: AppColors.windowFrame, width: 2),
      ),
      child: kind == null
          ? null
          : Center(child: storeItemFor(kind, size: _sizeFor(kind))),
    );
  }

  static double _sizeFor(StoreItemKind kind) {
    switch (kind) {
      case StoreItemKind.plant:
        return 50;
      case StoreItemKind.table:
        return 70;
      case StoreItemKind.lamp:
        return 48;
      case StoreItemKind.picture:
        return 56;
    }
  }
}

class _Chev extends StatelessWidget {
  const _Chev({required this.dir, required this.onTap});
  final ChevDir dir;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Opacity(opacity: 0.5, child: ChevIcon(dir: dir, size: 26)),
        ),
      ),
    );
  }
}

class _StorePanel extends StatelessWidget {
  const _StorePanel({
    required this.activeTab,
    required this.onTab,
    required this.onClose,
  });
  final String activeTab;
  final void Function(String) onTab;
  final VoidCallback onClose;

  static const _tabs = ['Decor', 'Styles', 'Plants', 'Pets'];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.panelBg,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x142C2148),
            blurRadius: 24,
            offset: Offset(0, -8),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onClose,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 2),
              child: ChevIcon(dir: ChevDir.down, size: 18),
            ),
          ),
          const SizedBox(height: 8),
          Container(height: 1, color: const Color(0x142C2148)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: _tabs.map((t) {
              final active = activeTab == t;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => onTab(t),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: active ? AppColors.lavender100 : AppColors.cream,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: active ? AppColors.lavender200 : AppColors.line,
                      ),
                    ),
                    child: Text(
                      t,
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
          ),
          const SizedBox(height: 14),
          Row(
            children: const [
              _PanelThumb(kind: StoreItemKind.table),
              SizedBox(width: 10),
              _PanelThumb(kind: StoreItemKind.plant),
              SizedBox(width: 10),
              _PanelThumb(kind: StoreItemKind.lamp),
              SizedBox(width: 10),
              _PanelThumb(kind: StoreItemKind.picture),
            ],
          ),
        ],
      ),
    );
  }
}

class _PanelThumb extends StatelessWidget {
  const _PanelThumb({required this.kind});
  final StoreItemKind kind;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.tabRowBg,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: storeItemFor(kind, size: 40),
        ),
      ),
    );
  }
}
