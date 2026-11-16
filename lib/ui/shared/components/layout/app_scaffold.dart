import 'package:material_ui/material_ui.dart';

enum _AppScaffoldKind { tab, details }

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  // Turns on pull to refresh. The body must be scrollable.
  final RefreshCallback? onRefresh;
  final _AppScaffoldKind _kind;

  const AppScaffold.tab({
    super.key,
    required this.title,
    required this.body,
    this.onRefresh,
  }) : _kind = .tab;

  const AppScaffold.details({
    super.key,
    required this.title,
    required this.body,
    this.onRefresh,
  }) : _kind = .details;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: switch (_kind) {
          .tab => null,
          .details => const BackButton(),
        },
        title: Text(
          title,
          maxLines: 1,
          overflow: .ellipsis,
          style: switch (_kind) {
            .tab => textTheme.headlineMedium,
            .details => textTheme.titleLarge,
          },
        ),
      ),
      body: switch (onRefresh) {
        final refresh? => RefreshIndicator(onRefresh: refresh, child: body),
        null => body,
      },
    );
  }
}
