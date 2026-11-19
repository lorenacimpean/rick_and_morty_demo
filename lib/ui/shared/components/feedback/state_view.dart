import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/core/theme/app_tokens.dart';
import 'package:rick_and_morty_demo/ui/shared/app_keys.dart';

enum _StateViewKind { loading, error, empty }

class StateView extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;
  final _StateViewKind _kind;

  const StateView.loading({super.key})
    : message = null,
      onRetry = null,
      _kind = .loading;

  const StateView.error({
    super.key,
    required String this.message,
    required VoidCallback this.onRetry,
  }) : _kind = .error;

  const StateView.empty({super.key, required String this.message})
    : onRetry = null,
      _kind = .empty;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const .all(AppTokens.kSpacing600),
        child: Column(
          mainAxisSize: .min,
          spacing: AppTokens.kSpacing400,
          children: [
            _StateIcon(kind: _kind),
            if (message case final text?) _StateMessage(text: text),
            if (onRetry case final retry?) _RetryButton(onTap: retry),
          ],
        ),
      ),
    );
  }
}

class _StateIcon extends StatelessWidget {
  final _StateViewKind kind;

  const _StateIcon({required this.kind});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return switch (kind) {
      .loading => const CircularProgressIndicator(),
      .error => Icon(
        Icons.error_outline,
        size: AppTokens.kIconSize1200,
        color: colors.error,
      ),
      .empty => Icon(
        Icons.search_off,
        size: AppTokens.kIconSize1200,
        color: colors.onSurfaceVariant,
      ),
    };
  }
}

class _StateMessage extends StatelessWidget {
  final String text;

  const _StateMessage({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: .center,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}

class _RetryButton extends StatelessWidget {
  final VoidCallback onTap;

  const _RetryButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      key: AppKeys.feedback.retry,
      onPressed: onTap,
      child: const Text('Try again'),
    );
  }
}
