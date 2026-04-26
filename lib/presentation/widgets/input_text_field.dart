import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';

class InputTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;
  final IconData? prefixIcon;

  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;

  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Key? fieldKey;

  final bool enabled;

  const InputTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.prefixIcon,
    this.validator,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
    this.enabled = true,
    this.fieldKey,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderRadius = BorderRadius.circular(AppRadius.md);

    return TextFormField(
      key: fieldKey,
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      onFieldSubmitted: onFieldSubmitted,

      style: TextStyle(color: colorScheme.primary),

      decoration: InputDecoration(
        labelText: label,
        hintText: hint ?? label,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        labelStyle: TextStyle(color: colorScheme.primary),

        floatingLabelStyle: TextStyle(
          color: colorScheme.primary,
          // color: colorScheme.secondary,
          fontWeight: FontWeight.bold,
          backgroundColor: colorScheme.onSecondary,
          // backgroundColor: colorScheme.onSecondary,
        ),

        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: colorScheme.primary)
            : null,

        filled: true,
        fillColor: colorScheme.onSecondary,

        border: OutlineInputBorder(borderRadius: borderRadius),

        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: colorScheme.primary),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: colorScheme.error),
        ),
        errorStyle: TextStyle(
          color: colorScheme.tertiary, 
          // color: Colors.white, 
          fontWeight: FontWeight.bold,
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
      ),

      validator: validator,
    );
  }
}
