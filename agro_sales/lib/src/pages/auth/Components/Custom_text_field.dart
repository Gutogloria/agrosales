import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CustomTextFieldConfig extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isSecret;
  final String? initialValue;
  final bool readOnly;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<MaskTextInputFormatter>? inputFormatters;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final Function(String)? onChanged;

  const CustomTextFieldConfig({
    super.key,
    required this.icon,
    required this.label,
    this.isSecret = false,
    this.controller,
    this.initialValue,
    this.readOnly = false,
    this.keyboardType,
    this.validator,
    this.inputFormatters,
    this.backgroundColor,
    this.textStyle,
    this.labelStyle,
    this.onChanged,
  });

  @override
  State<CustomTextFieldConfig> createState() => _CustomTextFieldConfigState();
}

class _CustomTextFieldConfigState extends State<CustomTextFieldConfig> {
  bool isObscure = false;

  @override
  void initState() {
    super.initState();
    isObscure = widget.isSecret;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        inputFormatters: widget.inputFormatters,
        obscureText: isObscure,
        initialValue: widget.initialValue,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        style: widget.textStyle,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          prefixIcon: Icon(widget.icon),
          suffixIcon: widget.isSecret
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                  icon: Icon(
                    isObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                )
              : null,
          labelText: widget.label,
          labelStyle: widget.labelStyle,
          isDense: true,
          filled: widget.backgroundColor != null,
          fillColor: widget.backgroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        controller: widget.controller,
        readOnly: widget.readOnly,
      ),
    );
  }
}
