import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/core/theme/app_palette.dart';
import 'package:rick_and_morty_demo/core/theme/app_tokens.dart';

abstract final class AppTheme {
  static const _kBodyFont = 'Nunito';
  // Letters and digits only, no punctuation: use for tab titles, never for API text.
  static const _kTitleFont = 'GetSchwifty';

  static ThemeData dark() {
    final base = ThemeData(
      colorScheme: _colorScheme,
      fontFamily: _kBodyFont,
      scaffoldBackgroundColor: AppPalette.kDeepSpace,
    );
    return base.copyWith(
      textTheme: _textTheme(base.textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppPalette.kDeepSpace,
        foregroundColor: AppPalette.kStarWhite,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      cardTheme: const CardThemeData(
        color: AppPalette.kSpace,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppTokens.kRadius400)),
        ),
      ),
    );
  }

  static const _colorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppPalette.kPortalGreen,
    onPrimary: AppPalette.kDeepSpace,
    secondary: AppPalette.kRickBlue,
    onSecondary: AppPalette.kDeepSpace,
    tertiary: AppPalette.kMortyYellow,
    onTertiary: AppPalette.kDeepSpace,
    error: AppPalette.kAlarm,
    onError: AppPalette.kDeepSpace,
    surface: AppPalette.kDeepSpace,
    onSurface: AppPalette.kStarWhite,
    onSurfaceVariant: AppPalette.kDust,
    surfaceContainer: AppPalette.kSpace,
    surfaceContainerHigh: AppPalette.kSpaceLight,
    outline: AppPalette.kSpaceOutline,
  );

  static TextTheme _textTheme(TextTheme base) => base.copyWith(
    headlineMedium: base.headlineMedium?.copyWith(
      fontFamily: _kTitleFont,
      color: AppPalette.kPortalGreen,
    ),
  );
}
