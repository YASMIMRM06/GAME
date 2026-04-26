import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart'; // ✅ caminho correto para essa pasta

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.action,
  });

  /// Presets

  const EmptyState.noCharacters({super.key})
      : icon = Icons.people_outline,
        title = 'Nenhum personagem encontrado',
        description = 'Adicione seu primeiro personagem usando o botão +',
        action = null;

  factory EmptyState.error({VoidCallback? onRetry}) {
    return EmptyState(
      icon: Icons.error_outline,
      title: 'Algo deu errado',
      description: 'Tente novamente mais tarde',
      action: onRetry != null
          ? ElevatedButton(
              onPressed: onRetry,
              child: const Text('Tentar novamente'),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxl,
          vertical: AppSpacing.xxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 72, color: colorScheme.outline),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: context.textStyles.titleMedium?.semiBold,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              description,
              textAlign: TextAlign.center,
              style: context.textStyles.bodyMedium?.withColor(
                colorScheme.onSurfaceVariant,
              ),
            ),
            if (action != null) ...[
              const SizedBox(height: AppSpacing.lg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}