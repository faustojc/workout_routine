import 'package:flutter/material.dart';

enum FieldType {
  text,
  int,
  double,
  password,
}

enum FieldDecoration {
  filled,
  outlined,
  borderless,
}

class InputFormField extends StatefulWidget {
  final FieldType type;
  final FieldDecoration decoration;
  final IconData? icon;
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const InputFormField({super.key, required this.type, this.decoration = FieldDecoration.outlined, this.label, this.hint, this.controller, this.validator, this.icon});

  @override
  State<InputFormField> createState() => _InputFormFieldState();
}

class _InputFormFieldState extends State<InputFormField> {
  Widget? _suffixIcon = const SizedBox.shrink();
  InputBorder? _border;
  Color? _fillColor;
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.type == FieldType.password;

    if (widget.decoration == FieldDecoration.outlined) {
      _border = const OutlineInputBorder();
    } else if (widget.decoration == FieldDecoration.borderless) {
      _border = const OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      );

      _fillColor = Colors.grey.shade200;
    }

    if (widget.controller!.text.isNotEmpty) {
      if (widget.type == FieldType.password) {
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
      keyboardType: widget.type == FieldType.int ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
        suffixIcon: _suffixIcon,
        labelText: widget.label,
        hintText: widget.hint,
        filled: widget.decoration == FieldDecoration.filled || widget.decoration == FieldDecoration.borderless,
        border: _border,
        fillColor: _fillColor,
      ),
      obscureText: _obscureText,
      validator: widget.validator,
      onChanged: (String value) {
        if (widget.type == FieldType.int && value.isNotEmpty) {
          if (int.tryParse(value) == null) {
            widget.controller!.text = value.substring(0, value.length - 1);
            widget.controller!.selection = TextSelection.fromPosition(TextPosition(offset: widget.controller!.text.length));
          }
        }

        if (widget.type == FieldType.double && value.isNotEmpty) {
          if (double.tryParse(value) == null) {
            widget.controller!.text = value.substring(0, value.length - 1);
            widget.controller!.selection = TextSelection.fromPosition(TextPosition(offset: widget.controller!.text.length));
          }
        }
      },
    );
  }
}
