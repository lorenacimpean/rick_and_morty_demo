import 'package:material_ui/material_ui.dart';

class AppListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const AppListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
      onTap: onTap,
      title: Text(title, style: textTheme.titleMedium),
      subtitle: switch (subtitle) {
        final text? => Text(text, style: textTheme.bodyMedium),
        null => null,
      },
      trailing: trailing,
    );
  }
}
