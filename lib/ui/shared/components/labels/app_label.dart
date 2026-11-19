import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/core/theme/app_tokens.dart';
import 'package:rick_and_morty_demo/data/models/character_status.dart';
import 'package:rick_and_morty_demo/ui/shared/components/labels/status_label.dart';

// A pill that can't be tapped: for facts like species or gender.
class AppLabel extends StatelessWidget {
  final String? _text;
  final CharacterStatus? _status;

  const AppLabel.text(String text, {super.key}) : _text = text, _status = null;

  const AppLabel.status(CharacterStatus status, {super.key})
    : _status = status,
      _text = null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: const .all(.circular(AppTokens.kRadiusFull)),
      ),
      child: Padding(
        padding: const .symmetric(
          horizontal: AppTokens.kSpacing300,
          vertical: AppTokens.kSpacing100,
        ),
        child: switch ((_status, _text)) {
          (final status?, _) => StatusLabel.of(status),
          (_, final text?) => Text(text, style: theme.textTheme.labelMedium),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }
}
