import '../failure/failure.dart';
import '../messages/app_messages.dart';

import 'base_validator.dart';

final class MaxDoubleFromStrValidator extends BaseValidator<String?> {
  final double maxValue;

  MaxDoubleFromStrValidator({this.maxValue = 100.0});

  @override
  bool validate(String? validation) {
    switch (validation) {
      case null:
        return throw DefaultFailure(AppMessages.error.nullStringError);
      case String _:
        {
          var value = double.tryParse(validation);
          if (value == null) {
            return throw InputFailure(AppMessages.error.nullStringError);
          }
          if (value > maxValue) {
            return throw InputFailure(
                '${AppMessages.error.maxDoubleError} - (${maxValue.toStringAsFixed(2)})');
          }

          return nextValidator?.validate(validation) ?? true;
        }
    }
  }
}
