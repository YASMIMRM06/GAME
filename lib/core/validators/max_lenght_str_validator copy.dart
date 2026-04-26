import '../failure/failure.dart';
import '../messages/app_messages.dart';

import 'base_validator.dart';

final class MaxLengthStrValidator extends BaseValidator<String?> {
  final int maxLength;
  MaxLengthStrValidator({this.maxLength = 10});
  
  @override
  bool validate(String? validation) {
    return switch (validation) {
      null => throw InputFailure(AppMessages.error.nullStringError),
      String _ when validation.length <= maxLength =>
        nextValidator?.validate(validation) ?? true,
      _ => throw InputFailure(
          '${AppMessages.error.longerStringError} - ($maxLength Caracteres)'),
    };
  }

}
