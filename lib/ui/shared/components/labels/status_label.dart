import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/core/theme/app_tokens.dart';
import 'package:rick_and_morty_demo/data/models/character_status.dart';

enum _Status { alive, dead, unknown }

class StatusLabel extends StatelessWidget {
  final _Status _status;

  const StatusLabel.alive({super.key}) : _status = .alive;

  const StatusLabel.dead({super.key}) : _status = .dead;

  const StatusLabel.unknown({super.key}) : _status = .unknown;

  factory StatusLabel.of(CharacterStatus status) => switch (status) {
    .alive => const StatusLabel.alive(),
    .dead => const StatusLabel.dead(),
    .unknown => const StatusLabel.unknown(),
  };

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final color = switch (_status) {
      .alive => colors.primary,
      .dead => colors.error,
      .unknown => colors.onSurfaceVariant,
    };
    return Row(
      mainAxisSize: .min,
      spacing: AppTokens.kSpacing100,
      children: [
        _Dot(color: color),
        Text(switch (_status) {
          .alive => 'Alive',
          .dead => 'Dead',
          .unknown => 'Unknown',
        }, style: Theme.of(context).textTheme.labelMedium),
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
