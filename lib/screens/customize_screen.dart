import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../shared/avatar.dart';
import '../shared/icons.dart';
import '../shared/pill_button.dart';
import '../state/app_state.dart';
import '../theme/colors.dart';

enum _Section { body, hair, skin }

class CustomizeScreen extends StatefulWidget {
  const CustomizeScreen({super.key, this.isInitialSetup = true});
  final bool isInitialSetup;

  @override
  State<CustomizeScreen> createState() => _CustomizeScreenState();
}

class _CustomizeScreenState extends State<CustomizeScreen> {
  final PageController _pager = PageController();
  int _index = 0;

  // The pager has 5 dots in the design (body, hair, skin, outfit, pants) but
  // only 3 functional pages — outfit/pants dots are inactive visual hints.
  static const int _dotCount = 5;
  static const List<_Section> _pages = [
    _Section.body,
    _Section.hair,
    _Section.skin,
  ];

  @override
  void dispose() {
    _pager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Centered title bar (no back / level / gems on first run)
            Container(
              width: double.infinity,
              color: AppColors.lavender200,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (!widget.isInitialSetup)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkResponse(
                        radius: 22,
                        onTap: () => Navigator.of(context).maybePop(),
                        child: const SizedBox(
                          width: 36,
                          height: 36,
                          child: Center(child: BackIcon()),
                        ),
                      ),
                    ),
                  const Text(
                    'Customize Your Avatar',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
            ),
            // Avatar preview
            Padding(
              padding: const EdgeInsets.only(top: 18, bottom: 8),
              child: Avatar(
                pose: AvatarPose.stand,
                size: 150,
                skin: state.skin,
                hair: state.hair,
                outfit: state.outfit,
                pants: state.pants,
              ),
            ),
            // Customizer pages
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 132,
                    child: PageView.builder(
                      controller: _pager,
                      itemCount: _pages.length,
                      onPageChanged: (i) => setState(() => _index = i),
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 38),
                          child: Center(child: _slider(state, _pages[i])),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  // 5-dot pager (design); first 3 are real pages, last 2
                  // remain unselected hints.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(_dotCount, (i) {
                      final active = i == _index;
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: active
                              ? AppColors.lavender400
                              : const Color(0x2E2C2148),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  PillButton(
                    label: widget.isInitialSetup ? 'Finished!' : 'Done',
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                    onPressed: () {
                      if (widget.isInitialSetup) {
                        Navigator.of(context).pushReplacementNamed('/room');
                      } else {
                        Navigator.of(context).maybePop();
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _slider(AppState state, _Section section) {
    final (title, count, selected, onPick, builder) = switch (section) {
      _Section.body => (
        'Body Type',
        AppState.bodyOutfits.length,
        state.bodyIndex,
        state.chooseBody,
        (int i) => Center(child: SilBody(outfit: AppState.bodyOutfits[i])),
      ),
      _Section.hair => (
        'Hair Style',
        AppState.hairColors.length,
        state.hairIndex,
        state.chooseHair,
        (int i) => Center(
          child: SilFace(
            skin: AppColors.avatarSkin,
            hair: AppState.hairColors[i],
          ),
        ),
      ),
      _Section.skin => (
        'Skin Tone',
        AppState.skinTones.length,
        state.skinIndex,
        state.chooseSkin,
        (int i) => Center(
          child: SilFace(
            skin: AppState.skinTones[i],
            hair: AppColors.avatarHair,
          ),
        ),
      ),
    };

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 280,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.customizerAccent, width: 2),
            ),
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 8),
                Container(height: 1, color: const Color(0x0F000000)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(count, (i) {
                    final active = i == selected;
                    return Padding(
                      padding: EdgeInsets.only(left: i == 0 ? 0 : 10),
                      child: GestureDetector(
                        onTap: () => onPick(i),
                        behavior: HitTestBehavior.opaque,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 120),
                          width: 52,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: active
                                  ? AppColors.customizerAccent
                                  : AppColors.line,
                              width: active ? 2 : 1,
                            ),
                            boxShadow: active
                                ? const [
                                    BoxShadow(
                                      color: AppColors.customizerAccentGlow,
                                      blurRadius: 0,
                                      spreadRadius: 3,
                                    ),
                                  ]
                                : null,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: builder(i),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
        // side chevrons that hint at swipe
        Positioned(
          left: -22,
          child: Opacity(
            opacity: 0.6,
            child: ChevIcon(
              dir: ChevDir.left,
              size: 20,
              color: AppColors.ink.withValues(alpha: 0.7),
            ),
          ),
        ),
        Positioned(
          right: -22,
          child: Opacity(
            opacity: 0.6,
            child: ChevIcon(
              dir: ChevDir.right,
              size: 20,
              color: AppColors.ink.withValues(alpha: 0.7),
            ),
          ),
        ),
      ],
    );
  }
}
