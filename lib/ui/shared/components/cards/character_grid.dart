import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/core/theme/app_tokens.dart';
import 'package:rick_and_morty_demo/data/models/character.dart';
import 'package:rick_and_morty_demo/ui/shared/components/cards/character_card.dart';
import 'package:rick_and_morty_demo/ui/shared/components/labels/status_label.dart';

// Character cards in as many columns as fit. A sliver: use it in a CustomScrollView.
class CharacterGrid extends StatelessWidget {
  final List<Character> characters;
  final ValueChanged<Character> onTap;

  const CharacterGrid({
    super.key,
    required this.characters,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const .symmetric(horizontal: AppTokens.kSpacing400),
      sliver: SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: AppTokens.kGridCellMaxWidth,
          childAspectRatio: AppTokens.kCharacterCardAspectRatio,
          mainAxisSpacing: AppTokens.kSpacing300,
          crossAxisSpacing: AppTokens.kSpacing300,
        ),
        itemCount: characters.length,
        itemBuilder: (_, index) =>
            _CharacterItem(character: characters[index], onTap: onTap),
      ),
    );
  }
}

class _CharacterItem extends StatelessWidget {
  final Character character;
  final ValueChanged<Character> onTap;

  const _CharacterItem({required this.character, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CharacterCard(
      imageUrl: character.imageUrl,
      name: character.name,
      species: character.species,
      status: StatusLabel.of(character.status),
      onTap: () => onTap(character),
    );
  }
}
