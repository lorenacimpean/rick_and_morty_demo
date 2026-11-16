import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/core/theme/app_tokens.dart';

typedef AppChoice<T> = ({String label, T value});

// A single-choice row of chips. Exactly one is selected.
class AppChoiceChips<T> extends StatelessWidget {
  final List<AppChoice<T>> choices;
  final T selected;
  final ValueChanged<T> onChanged;

  const AppChoiceChips({
    super.key,
    required this.choices,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppTokens.kSpacing200,
      runSpacing: AppTokens.kSpacing200,
      children: [
        for (final choice in choices)
          ChoiceChip(
            label: Text(choice.label),
            selected: choice.value == selected,
            onSelected: (_) => onChanged(choice.value),
          ),
      ],
    );
  }
}
