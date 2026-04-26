import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'numeric_spinner.dart';

class AccountAttributeCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String hint;
  final int minValue;
  final int maxValue;
  final int value;
  final ValueChanged<int> onChanged;

  const AccountAttributeCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.hint,
    required this.minValue,
    required this.maxValue,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondary,
      child: Padding(
        padding: AppSpacing.paddingMd,
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 7),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: context.textStyles.labelMedium),
                  Text(hint, style: context.textStyles.bodySmall),
                ],
              ),
            ),
            NumericSpinner(
              value: value,
              minValue: minValue,
              maxValue: maxValue,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}