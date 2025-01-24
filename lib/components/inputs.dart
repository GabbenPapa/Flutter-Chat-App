import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  final String labelText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final bool autocorrection;
  final TextCapitalization textCapitalization;
  final bool enableSuggestions;
  final void Function(String?)? onSaved;

  const TextInput({
    required this.labelText,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.onSaved,
    this.autocorrection = true,
    this.textCapitalization = TextCapitalization.none,
    this.enableSuggestions = false,
    super.key,
  });

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  bool _obscureText = true;
  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: widget.autocorrection,
      textCapitalization: widget.textCapitalization,
      validator: widget.validator,
      onSaved: widget.onSaved,
      keyboardType: widget.keyboardType,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.purple,
            width: 1.0,
          ),
        ),
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
    );
  }
}
