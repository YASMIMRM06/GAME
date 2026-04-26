import 'dart:math';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class MetricUnitInputFormatter extends TextInputFormatter {
  final String? unitMask;
  final int decimals;
  late final NumberFormat _formatter;

  MetricUnitInputFormatter({
    this.unitMask,
    int? decimals,
  }) : decimals = (decimals == null || decimals < 0) ? 2 : decimals {
    
    // Cria a máscara com o número de casas decimais especificado
    String pattern;
    if (this.decimals > 0) {
      String decimalPattern = '0' * this.decimals;
      pattern = '#,##0.$decimalPattern';
    } else {
      pattern = '#,##0';
    }

    // Cria um formatter com o padrão especificado e a localidade pt_BR
    _formatter = NumberFormat(pattern, 'pt_BR');
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var unitMask = this.unitMask ?? '';
    int intOffSet = (unitMask.isEmpty) ? 0 : unitMask.length;

    if (newValue.text.isEmpty) {
      return newValue.copyWith(
          selection: TextSelection.collapsed(offset: intOffSet + 1));
    }

    String newText = newValue.text
        .replaceAll(unitMask, '')
        .replaceAll(',', '')
        .replaceAll('.', '');

    double value;
    if (newText.isNotEmpty) {
      value = double.tryParse(newText) ?? 0.0;
      value = decimals == 0 ? value : value / pow(10, decimals);
    } else {
      value = 0.0;
    }

    // Formata o número com duas casas decimais
    newText = '${_formatter.format(value)}$unitMask';

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length - intOffSet),
    );
  }
}
