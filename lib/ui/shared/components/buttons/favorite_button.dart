import 'package:material_ui/material_ui.dart';

// A heart that is filled while the item is a favorite.
class FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback? onTap;

  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
      color: Theme.of(context).colorScheme.error,
      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
    );
  }
}
