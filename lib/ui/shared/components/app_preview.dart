import 'package:flutter/widget_previews.dart';
import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/core/theme/app_theme.dart';

// Previews with the app theme applied.
final class AppPreview extends Preview {
  const AppPreview({required super.group, super.name, super.size})
    : super(wrapper: appPreviewWrapper);
}

// Must be public and top-level: preview annotations only take static callbacks.
Widget appPreviewWrapper(Widget child) => MaterialApp(
  theme: AppTheme.dark(),
  debugShowCheckedModeBanner: false,
  home: Material(child: child),
);
