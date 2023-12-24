import 'package:flutter/material.dart';

enum InputFormFieldType {
  text,
  password,
}

class InputFormField extends StatefulWidget {
  final InputFormFieldType type;
  final IconData? icon;
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const InputFormField({super.key, required this.type, this.label, this.hint, this.controller, this.validator, this.icon});

  @override
  State<InputFormField> createState() => _InputFormFieldState();
}

class _InputFormFieldState extends State<InputFormField> {
  Widget? _suffixIcon = const SizedBox.shrink();
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.type == InputFormFieldType.password;

    if (widget.controller!.text.isNotEmpty) {
      if (widget.type == InputFormFieldType.password) {
        _suffixIcon = IconButton(
          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: _setObscureText,
        );
      } else {
        _suffixIcon = IconButton(
          icon: const Icon(Icons.clear),
          onPressed: _clearText,
        );
      }
    }
  }

  void _setObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _clearText() {
    widget.controller!.clear();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
        suffixIcon: _suffixIcon,
        labelText: widget.label,
        hintText: widget.hint,
        border: const OutlineInputBorder(),
      ),
      obscureText: _obscureText,
      validator: widget.validator,
    );
  }
}
