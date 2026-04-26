
import '../failure/failure.dart';
import '../messages/app_messages.dart';

import 'base_validator.dart';

/// Validador de data no formato DD/MM/AAAA
final class DateValidator extends BaseValidator<String?> {
  @override
  bool validate(String? validation) {
    switch (validation?.split('/')) {
      case null || ['']:
        return throw InputFailure(AppMessages.error.nullStringError);
      case [var dayString, var monthString, var yearString]:
        {
          final day = int.tryParse(dayString);
          final month = int.tryParse(monthString);
          final year = int.tryParse(yearString);

          if (day == null || month == null || year == null) {
            throw InvalidDate(AppMessages.error.invalidDateError);
          }

          final date = DateTime(year, month, day);
          if (date.year == year && date.month == month && date.day == day) {
            return nextValidator?.validate(validation) ?? true;
          } else {
            throw InvalidDate(AppMessages.error.invalidDateError);
          }
        }
      default:
        return throw InvalidDate(AppMessages.error.invalidDateError);
    }
  }
}
