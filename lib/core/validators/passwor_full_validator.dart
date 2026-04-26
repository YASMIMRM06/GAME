import '../failure/failure.dart';
import '../messages/app_messages.dart';

import '../regular_expressions/regular_expressions.dart';
import 'base_validator.dart';

final class PassworFullValidator extends BaseValidator<String?> {
  PassworFullValidator();

  @override
  bool validate(String? validation) {
    return switch (validation) {
      null => throw InputFailure(AppMessages.error.nullStringError),
      String v when v.trim().isEmpty => throw InputFailure(
        AppMessages.error.nullStringError,
      ),
      String v when !RegexApp.password.hasMatch(v.trim()) =>
        throw InvalidPassword(AppMessages.error.invalidPasswordError),
      _ => nextValidator?.validate(validation) ?? true,
    };
  }
}
