import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/core/theme/app_tokens.dart';
import 'package:rick_and_morty_demo/ui/shared/components/lists/app_list_tile.dart';

// One episode in a card: code badge, name, air date.
class EpisodeTile extends StatelessWidget {
  final String code;
  final String name;
  final String airDate;
  final VoidCallback? onTap;

  const EpisodeTile({
    super.key,
    required this.code,
    required this.name,
    required this.airDate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: AppListTile(
        leading: _CodeBadge(code: code),
        title: name,
        subtitle: airDate,
        onTap: onTap,
      ),
    );
  }
}

class _CodeBadge extends StatelessWidget {
  final String code;

  const _CodeBadge({required this.code});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox.square(
      dimension: AppTokens.kBadgeSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: const .all(.circular(AppTokens.kRadius200)),
        ),
        child: Center(
          child: Text(
            code,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: .bold,
            ),
          ),
        ),
      ),
    );
  }
}
