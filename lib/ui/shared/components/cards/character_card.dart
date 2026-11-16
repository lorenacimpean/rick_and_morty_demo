import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/core/theme/app_tokens.dart';
import 'package:rick_and_morty_demo/ui/shared/components/labels/status_label.dart';

class CharacterCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String species;
  final StatusLabel status;
  final VoidCallback? onTap;

  const CharacterCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.species,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            AspectRatio(
              aspectRatio: AppTokens.kSquareAspectRatio,
              child: _CharacterImage(url: imageUrl),
            ),
            Padding(
              padding: const .all(AppTokens.kSpacing300),
              child: _CharacterInfo(
                name: name,
                species: species,
                status: status,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CharacterImage extends StatelessWidget {
  final String url;

  const _CharacterImage({required this.url});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return CachedNetworkImage(
      imageUrl: url,
      fit: .cover,
      placeholder: (_, _) => ColoredBox(color: colors.surfaceContainerHigh),
      errorWidget: (_, _, _) => ColoredBox(
        color: colors.surfaceContainerHigh,
        child: Icon(Icons.person_outline, color: colors.onSurfaceVariant),
      ),
    );
  }
}

class _CharacterInfo extends StatelessWidget {
  final String name;
  final String species;
  final StatusLabel status;

  const _CharacterInfo({
    required this.name,
    required this.species,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: .start,
      spacing: AppTokens.kSpacing100,
      children: [
        Text(
          name,
          maxLines: 1,
          overflow: .ellipsis,
          style: textTheme.titleMedium,
        ),
        Row(
          spacing: AppTokens.kSpacing200,
          children: [
            status,
            Expanded(
              child: Text(
                species,
                maxLines: 1,
                overflow: .ellipsis,
                style: textTheme.labelMedium,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
