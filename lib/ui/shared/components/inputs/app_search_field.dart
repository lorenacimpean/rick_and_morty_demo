import 'package:material_ui/material_ui.dart';

class AppSearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;

  const AppSearchField({
    super.key,
    required this.hint,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      hintText: hint,
      leading: const Icon(Icons.search),
      onChanged: onChanged,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
    );
  }
}
