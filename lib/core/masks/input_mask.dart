import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../regular_expressions/regular_expressions.dart';
import 'unit_metric_mask.dart';

abstract class InputMask {
  static final dateMask = MaskTextInputFormatter(
    mask: "##/##/####",
    filter: {"#": RegexApp.onlyNumbers},
  );
  static final  weightBrMask = MetricUnitInputFormatter();
}
