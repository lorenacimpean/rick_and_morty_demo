// Steps count 4-pt grid units: 100 = 4, 400 = 16.
abstract final class AppTokens {
  static const kSpacing100 = 4.0;
  static const kSpacing200 = 8.0;
  static const kSpacing300 = 12.0;
  static const kSpacing400 = 16.0;
  static const kSpacing600 = 24.0;
  static const kSpacing800 = 32.0;

  static const kRadius200 = 8.0;
  static const kRadius400 = 16.0;
  static const kRadiusFull = 999.0;

  static const kIconSize1200 = 48.0;

  static const kDotSize200 = 8.0;
  static const kSquareAspectRatio = 1.0;

  // Character grid: cells up to this wide, square image plus two text lines.
  static const kGridCellMaxWidth = 200.0;
  static const kCharacterCardAspectRatio = 0.72;
  // Start loading the next page when this close to the end of a list.
  static const kLoadMoreDistance = 400.0;

  static const kDetailsImageMaxWidth = 320.0;
}
