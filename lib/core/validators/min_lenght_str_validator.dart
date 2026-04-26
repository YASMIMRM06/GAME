import '../failure/failure.dart';
import '../messages/app_messages.dart';

import 'base_validator.dart';

final class MinLengthStrValidator extends BaseValidator<String?> {
  final int minLength;

  MinLengthStrValidator({this.minLength = 3});

  @override
  bool validate(String? validation) {
    return switch (validation) {
      null => throw InputFailure(AppMessages.error.nullStringError),
      String _ when validation.length >= minLength =>
        nextValidator?.validate(validation) ?? true,
      _ => throw InputFailure(
        '${AppMessages.error.shorterStringError} - ($minLength Caracteres)',
      ),
    };
  }
}
