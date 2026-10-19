import 'dart:ui';

import 'package:fossui/fossui.dart';

class MovoThemeData {
  static FossThemeData get lightTheme {
    return FossThemeData.light.copyWith(
      colors: FossColors.light.copyWith(
        primary: const Color(0xFF1A73E8),
        secondary: const Color(0xFFE0EEFF),
        secondaryForeground: const Color(0xFF001D42),
        background: const Color(0xFFF3F5F7),
        // border: const Color(0xFFD1D5DA),
        accent: const Color(0xFFFBBC05),
        successForeground: const Color(0xFFFFFFFF),
        warningForeground: const Color(0xFFFFFFFF),
        destructiveForeground: const Color(0xFFB00020),
      ),
    );
  }
}

// extension MovoThemeExtentions on FossColors {
//   merge(FossColors other) {}
// }

// class MovoColors extends FossColors {

// }

extension MovoThemeExtentions on FossColors {
  Color get primaryLight => const Color(0xFFC2D8FF);
  Color get primaryLightForeground => const Color(0xFF013A84);
  Color get accentLight => const Color(0xFFFFEDBA);
  Color get accentLightForeground => const Color(0xFF6E4000);
  Color get successLight => const Color(0xFFC0FFD2);
  Color get successLightForeground => const Color(0xFF335435);
  Color get infoLight => const Color(0xFFD9F0FF);
  Color get infoLightForeground => const Color(0xFF003A5B);
  Color get warningLight => const Color(0xFFFFE7C5);
  Color get warningLightForeground => const Color(0xFF733900);
  Color get destructiveLight => const Color(0xFFFDE7E9);
  Color get destructiveLightForeground => const Color(0xFF96003F);
}
