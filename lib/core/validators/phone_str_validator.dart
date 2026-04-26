import '../failure/failure.dart';
import '../messages/app_messages.dart';
import '../regular_expressions/regular_expressions.dart';
import 'base_validator.dart';

final class PhoneStrValidator extends BaseValidator<String?> {
  PhoneStrValidator();

  @override
  bool validate(String? validation) {
    return switch (validation) {
      null => throw InputFailure(AppMessages.error.nullStringError),
      String v when v.trim().isEmpty => throw InputFailure(
        AppMessages.error.nullStringError,
      ),
      String v when !RegexApp.phone.hasMatch(v.trim()) => throw InvalidPhone(
        AppMessages.error.invalidPhoneError,
      ),
      _ => nextValidator?.validate(validation) ?? true,
    };
  }
}
