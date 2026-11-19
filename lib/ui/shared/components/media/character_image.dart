import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/core/theme/app_tokens.dart';

// A square character picture, cached on disk, with a placeholder while loading.
class CharacterImage extends StatelessWidget {
  final String url;
  final BorderRadius _borderRadius;

  // Square corners, for inside a card that clips them.
  const CharacterImage.standard({super.key, required this.url})
    : _borderRadius = BorderRadius.zero;

  const CharacterImage.rounded({super.key, required this.url})
    : _borderRadius = const .all(.circular(AppTokens.kRadius400));

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return AspectRatio(
      aspectRatio: AppTokens.kSquareAspectRatio,
      child: ClipRRect(
        borderRadius: _borderRadius,
        child: CachedNetworkImage(
          imageUrl: url,
          fit: .cover,
          placeholder: (_, _) => ColoredBox(color: colors.surfaceContainerHigh),
          errorWidget: (_, _, _) => ColoredBox(
            color: colors.surfaceContainerHigh,
            child: Icon(Icons.person_outline, color: colors.onSurfaceVariant),
          ),
        ),
      ),
    );
  }
}
