import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/core/theme/app_tokens.dart';
import 'package:rick_and_morty_demo/data/models/character_status.dart';
import 'package:rick_and_morty_demo/ui/shared/character_status_style.dart';

class StatusLabel extends StatelessWidget {
  final CharacterStatus _status;

  const StatusLabel.alive({super.key}) : _status = .alive;

  const StatusLabel.dead({super.key}) : _status = .dead;

  const StatusLabel.unknown({super.key}) : _status = .unknown;

  const StatusLabel.of(this._status, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: .min,
      spacing: AppTokens.kSpacing100,
      children: [
        _Dot(color: _status.color(theme.colorScheme)),
        Text(_status.label, style: theme.textTheme.labelMedium),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;

  const _Dot({required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppTokens.kDotSize200,
      child: DecoratedBox(
        decoration: BoxDecoration(color: color, shape: .circle),
      ),
    );
  }
}
