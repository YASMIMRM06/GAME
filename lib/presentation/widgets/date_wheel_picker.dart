import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Widget para seleção de data usando um wheel picker (rolagem)
///
/// Abre um modal (BottomSheet) com um seletor de data estilo iOS
/// com formato brasileiro: dia, mês por extenso em português e ano
class DateWheelPicker extends StatelessWidget {
  final DateTime? selectedDate;
  final String? label;
  final ValueChanged<DateTime> onDateSelected;
  final DateTime? minimumDate;
  final DateTime? maximumDate;

  const DateWheelPicker({
    super.key,
    this.selectedDate,
    this.label,
    required this.onDateSelected,
    this.minimumDate,
    this.maximumDate,
  });

  static const List<String> _monthNames = [
    'janeiro',
    'fevereiro',
    'março',
    'abril',
    'maio',
    'junho',
    'julho',
    'agosto',
    'setembro',
    'outubro',
    'novembro',
    'dezembro',
  ];

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime now = DateTime.now();
    DateTime tempDate = selectedDate ?? now;

    int selectedDay = tempDate.day;
    int selectedMonth = tempDate.month;
    int selectedYear = tempDate.year;

    // Define limites padrão se não fornecidos
    final DateTime minDate = minimumDate ?? DateTime(1900);
    final DateTime maxDate = maximumDate ?? DateTime(2100);

    // Controllers para os pickers
    final FixedExtentScrollController dayController =
        FixedExtentScrollController(initialItem: selectedDay - 1);
    final FixedExtentScrollController monthController =
        FixedExtentScrollController(initialItem: selectedMonth - 1);
    final FixedExtentScrollController yearController =
        FixedExtentScrollController(initialItem: selectedYear - minDate.year);

    await showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Calcula o número de dias no mês selecionado
            int daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;

            // Ajusta o dia se estiver fora do range
            if (selectedDay > daysInMonth) {
              selectedDay = daysInMonth;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                dayController.animateToItem(
                  selectedDay - 1,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                );
              });
            }

            return Container(
              height: 300,
              padding: AppSpacing.paddingMd,
              child: Column(
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancelar',
                          style:
                              (context.textStyles.titleMedium ??
                                      const TextStyle())
                                  .withColor(
                                    Theme.of(context).colorScheme.secondary,
                                  ),
                        ),
                      ),
                      Text(
                        label ?? 'Selecionar Data',
                        style:
                            context.textStyles.titleMedium?.bold ??
                            const TextStyle(),
                      ),
                      TextButton(
                        onPressed: () {
                          onDateSelected(
                            DateTime(selectedYear, selectedMonth, selectedDay),
                          );
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Confirmar',
                          style:
                              (context.textStyles.titleMedium ??
                                      const TextStyle())
                                  .bold
                                  .withColor(Colors.amber.shade700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Date Picker
                  Expanded(
                    child: Row(
                      children: [
                        // Dia
                        Expanded(
                          flex: 2,
                          child: CupertinoPicker(
                            scrollController: dayController,
                            itemExtent: 40,
                            onSelectedItemChanged: (index) {
                              setState(() {
                                selectedDay = index + 1;
                              });
                            },
                            children: List.generate(
                              daysInMonth,
                              (index) => Center(
                                child: Text(
                                  '${index + 1}',
                                  style: context.textStyles.bodyLarge,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Mês
                        Expanded(
                          flex: 3,
                          child: CupertinoPicker(
                            scrollController: monthController,
                            itemExtent: 40,
                            onSelectedItemChanged: (index) {
                              setState(() {
                                selectedMonth = index + 1;
                              });
                            },
                            children: _monthNames
                                .map(
                                  (month) => Center(
                                    child: Text(
                                      month,
                                      style: context.textStyles.bodyLarge,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),

                        // Ano
                        Expanded(
                          flex: 2,
                          child: CupertinoPicker(
                            scrollController: yearController,
                            itemExtent: 40,
                            onSelectedItemChanged: (index) {
                              setState(() {
                                selectedYear = minDate.year + index;
                              });
                            },
                            children: List.generate(
                              maxDate.year - minDate.year + 1,
                              (index) => Center(
                                child: Text(
                                  '${minDate.year + index}',
                                  style: context.textStyles.bodyLarge,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    // Dispose dos controllers
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Selecionar data';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: context.textStyles.labelLarge?.withColor(
              Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        InkWell(
          onTap: () => _showDatePicker(context),
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSecondary,
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.outline.withValues(alpha: 0.5),
              ),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(selectedDate),
                  style: context.textStyles.bodyLarge?.copyWith(
                    color: selectedDate != null
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.6),
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
