import 'package:flutter/material.dart';

import '../theme/colors.dart';

enum StoreItemKind { table, plant, lamp, picture }

class AppState extends ChangeNotifier {
  int level = 1;
  int gems = 350;

  // Avatar
  Color skin = AppColors.avatarSkin;
  Color hair = AppColors.avatarHair;
  Color outfit = AppColors.avatarOutfit;
  Color pants = AppColors.avatarPants;

  // 6-slot Window grid; matches the prototype's default placement.
  // [top-left, top-mid, top-right, bottom-left, bottom-mid, bottom-right]
  final List<StoreItemKind?> placed = <StoreItemKind?>[
    null,
    null,
    StoreItemKind.plant,
    StoreItemKind.table,
    null,
    StoreItemKind.lamp,
  ];

  // Owned counts (default matches inventory screen: 4 items owned)
  final Map<StoreItemKind, int> owned = <StoreItemKind, int>{
    StoreItemKind.table: 1,
    StoreItemKind.plant: 2,
    StoreItemKind.lamp: 1,
    StoreItemKind.picture: 1,
  };

  // Avatar option indexes
  int bodyIndex = 0;
  int hairIndex = 0;
  int skinIndex = 0;

  static const List<Color> bodyOutfits = <Color>[
    Color(0xFFB83A4A),
    Color(0xFF3D7A5C),
    Color(0xFFD08856),
  ];
  static const List<Color> hairColors = <Color>[
    Color(0xFF3A2A2E),
    Color(0xFF8B5E3C),
    Color(0xFFD9A45A),
  ];
  static const List<Color> skinTones = <Color>[
    Color(0xFFF2D2BA),
    Color(0xFFD9A781),
    Color(0xFF8C5A3D),
  ];

  void chooseBody(int i) {
    bodyIndex = i;
    outfit = bodyOutfits[i];
    notifyListeners();
  }

  void chooseHair(int i) {
    hairIndex = i;
    hair = hairColors[i];
    notifyListeners();
  }

  void chooseSkin(int i) {
    skinIndex = i;
    skin = skinTones[i];
    notifyListeners();
  }

  bool isPlaced(StoreItemKind kind) => placed.contains(kind);
}
