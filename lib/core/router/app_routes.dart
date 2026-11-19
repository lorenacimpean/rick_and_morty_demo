abstract final class AppRoutes {
  static const characters = '/characters';
  static const episodes = '/episodes';
  static const favorites = '/favorites';

  static String character(String id) => '$characters/$id';

  static String favoriteCharacter(String id) => '$favorites/$id';
}
