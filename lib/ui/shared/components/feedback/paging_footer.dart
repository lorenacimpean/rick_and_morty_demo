import 'package:material_ui/material_ui.dart';
import 'package:rick_and_morty_demo/core/theme/app_tokens.dart';
import 'package:rick_and_morty_demo/ui/shared/app_keys.dart';

// Shown under a list while the next page loads, or when it failed.
class PagingFooter extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  const PagingFooter.loading({super.key}) : message = null, onRetry = null;

  const PagingFooter.error({
    super.key,
    required String this.message,
    required VoidCallback this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .all(AppTokens.kSpacing400),
      child: Center(
        child: switch ((message, onRetry)) {
          (final text?, final retry?) => _PagingError(
            message: text,
            onRetry: retry,
          ),
          _ => const CircularProgressIndicator(),
        },
      ),
    );
  }
}

class _PagingError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _PagingError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      spacing: AppTokens.kSpacing200,
      children: [
        Text(message, style: Theme.of(context).textTheme.bodyMedium),
        TextButton(
          key: AppKeys.feedback.pagingRetry,
          onPressed: onRetry,
          child: const Text('Try again'),
        ),
      ],
    );
  }
}
