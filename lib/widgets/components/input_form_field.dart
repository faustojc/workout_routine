import 'package:flutter/material.dart';
import 'package:workout_routine/themes/colors.dart';

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
  final IconData? suffixIcon;
  final Color suffixIconColor;
  final String? label;
  final TextStyle? labelStyle;
  final String? hint;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool readOnly;
  final void Function()? onTap;

  const InputFormField({
    required this.type,
    super.key,
    this.readOnly = false,
    this.decoration = FieldDecoration.outlined,
    this.label,
    this.labelStyle,
    this.hint,
    this.hintStyle,
    this.controller,
    this.validator,
    this.onTap,
    this.icon,
    this.suffixIcon,
    this.suffixIconColor = ThemeColor.primary,
    this.fillColor,
  });

  @override
  State<InputFormField> createState() => _InputFormFieldState();
}

class _InputFormFieldState extends State<InputFormField> {
  late TextEditingController _controller;
  Widget? _suffixIcon;
  InputBorder? _border;
  Color? _fillColor;
  late bool _obscureText;

  @override
  void initState() {
    super.initState();

    _fillColor = widget.fillColor ?? ThemeColor.secondary.withOpacity(0.2);
    _obscureText = widget.type == FieldType.password;
    _controller = widget.controller ?? TextEditingController();

    if (widget.suffixIcon != null) {
      _suffixIcon = Icon(widget.suffixIcon);
    } else {
      _suffixIcon = null;
    }

    // Add a listener to _controller
    _controller.addListener(() {
      if (_suffixIcon == null) {
        setState(() {
          if (widget.type == FieldType.password) {
            _suffixIcon = IconButton(
              icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
              onPressed: _setObscureText,
            );
          } else if (widget.type == FieldType.text && _controller.text.isNotEmpty) {
            _suffixIcon = IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearText,
            );
          }
        });
      }
    });

    if (widget.decoration == FieldDecoration.outlined) {
      _border = const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(28)),
      );
    } else if (widget.decoration == FieldDecoration.borderless) {
      _border = const OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.all(Radius.circular(28)),
      );
    }
  }

  void _setObscureText() {
    setState(() {
      _obscureText = !_obscureText;
      _suffixIcon = IconButton(
        icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
        onPressed: _setObscureText,
      );
    });
  }

  void _clearText() {
    widget.controller!.clear();
    setState(() => _suffixIcon = null);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      controller: widget.controller,
      keyboardType: (widget.type == FieldType.int || widget.type == FieldType.double) ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: widget.icon != null ? Icon(widget.icon, color: ThemeColor.white) : null,
        suffixIcon: _suffixIcon,
        suffixIconColor: widget.suffixIconColor,
        labelText: widget.label,
        hintText: widget.hint,
        filled: widget.decoration == FieldDecoration.filled || widget.decoration == FieldDecoration.borderless,
        border: _border,
        fillColor: _fillColor,
        labelStyle: widget.labelStyle,
        hintStyle: widget.hintStyle,
        enabledBorder: (_fillColor != null) ? const UnderlineInputBorder(borderSide: BorderSide(color: ThemeColor.white)) : null,
      ),
      style: const TextStyle(color: ThemeColor.white),
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
