import 'package:flutter/material.dart';
import '../../domain/failures/failure.dart';

class ErrorView extends StatelessWidget {
  final Failure failure;
  final VoidCallback? onRetry;

  const ErrorView({super.key, required this.failure, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              failure.message,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _subtitle,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              FilledButton.tonal(onPressed: onRetry, child: const Text('重试')),
            ],
          ],
        ),
      ),
    );
  }

  String get _subtitle => failure.when(
    network: (message, statusCode) => '请检查网络连接后重试',
    auth: (message) => '请重新登录',
    storage: (message) => '数据读写异常',
    business: (message, code) => message,
    unknown: (message, error) => '未知错误，请稍后重试',
  );
}
