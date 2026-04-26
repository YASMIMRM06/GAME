import '../failure/failure.dart';
import '../messages/app_messages.dart';

import '../regular_expressions/regular_expressions.dart';
import 'base_validator.dart';

final class PasswordCascadeValidator extends BaseValidator<String?> {
  PasswordCascadeValidator();

  @override
  bool validate(String? validation) {
    return switch (validation) {
      null => throw InputFailure(AppMessages.error.nullStringError),
      String v when v.trim().isEmpty => throw InputFailure(
        AppMessages.error.nullStringError,
      ),
      String v when !RegexApp.hasLowerCase.hasMatch(v.trim()) =>
        throw InvalidPassword(AppMessages.error.lowerCharMissedError),
      String v when !RegexApp.hasUpperCase.hasMatch(v.trim()) =>
        throw InvalidPassword(AppMessages.error.upperCharMissedError),
      String v when !RegexApp.hasSpecialChar.hasMatch(v.trim()) =>
        throw InvalidPassword(AppMessages.error.specialCharMissedError),
      String v when !RegexApp.hasDigit.hasMatch(v.trim()) =>
        throw InvalidPassword(AppMessages.error.digitMissedError),
      _ => nextValidator?.validate(validation) ?? true,
    };
  }
}
