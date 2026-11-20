import 'package:flutter/foundation.dart';

// Keys the integration tests find widgets by, grouped by screen.
abstract final class AppKeys {
  static const shell = ShellKeys();
  static const feedback = FeedbackKeys();
  static const cards = CardsKeys();
  static const characters = CharactersKeys();
  static const details = CharacterDetailsKeys();
  static const episodes = EpisodesKeys();
  static const favorites = FavoritesKeys();
}

final class ShellKeys {
  const ShellKeys();

  Key get navigationBar => const ValueKey('shell_navigation_bar');
  Key get charactersTab => const ValueKey('shell_characters_tab');
  Key get episodesTab => const ValueKey('shell_episodes_tab');
  Key get favoritesTab => const ValueKey('shell_favorites_tab');
  Key get back => const ValueKey('shell_back');
}

final class FeedbackKeys {
  const FeedbackKeys();

  Key get retry => const ValueKey('feedback_retry');
  Key get pagingRetry => const ValueKey('feedback_paging_retry');
}

final class CardsKeys {
  const CardsKeys();

  Key character(String id) => ValueKey('cards_character_$id');
}

final class CharactersKeys {
  const CharactersKeys();

  Key get screen => const ValueKey('characters_screen');
  Key get searchField => const ValueKey('characters_search_field');
  Key get allChip => const ValueKey('characters_all_chip');
  Key get aliveChip => const ValueKey('characters_alive_chip');
  Key get deadChip => const ValueKey('characters_dead_chip');
  Key get unknownChip => const ValueKey('characters_unknown_chip');
  Key get grid => const ValueKey('characters_grid');
  Key get error => const ValueKey('characters_error');
  Key get empty => const ValueKey('characters_empty');
  Key get pagingLoading => const ValueKey('characters_paging_loading');
  Key get pagingError => const ValueKey('characters_paging_error');
}

final class CharacterDetailsKeys {
  const CharacterDetailsKeys();

  Key get screen => const ValueKey('details_screen');
  Key get name => const ValueKey('details_name');
  Key get favoriteButton => const ValueKey('details_favorite_button');
  Key get error => const ValueKey('details_error');
}

final class EpisodesKeys {
  const EpisodesKeys();

  Key get screen => const ValueKey('episodes_screen');
  Key get list => const ValueKey('episodes_list');
  Key get error => const ValueKey('episodes_error');
  Key get empty => const ValueKey('episodes_empty');

  Key season(int number) => ValueKey('episodes_season_$number');

  Key episode(String code) => ValueKey('episodes_episode_$code');
}

final class FavoritesKeys {
  const FavoritesKeys();

  Key get screen => const ValueKey('favorites_screen');
  Key get grid => const ValueKey('favorites_grid');
  Key get error => const ValueKey('favorites_error');
  Key get empty => const ValueKey('favorites_empty');
}
