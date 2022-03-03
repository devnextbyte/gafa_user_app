import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gafamoney/utils/snippets.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final void Function(String) onFieldSubmitted;
  final String Function(String) validator;
  final String label;

  const PasswordField(
      {Key key,
      @required this.controller,
      this.label,
      this.textInputAction,
      this.validator,
      this.onFieldSubmitted})
      : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      textInputAction: widget.textInputAction ?? TextInputAction.next,
      onFieldSubmitted:
          widget.onFieldSubmitted ?? (_) => Focus.of(context).nextFocus(),
      validator: widget.validator ?? validatePin,
      obscureText: !_showPassword,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: widget.label ?? "Pin",
        prefixIconConstraints: BoxConstraints.tight(Size(32, 16)),
        suffix: GestureDetector(
          onTap: () => setState(() => _showPassword = !_showPassword),
          child: FaIcon(
            !_showPassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
            color: Theme.of(context).textSelectionTheme.cursorColor,
            size: 16,
          ),
        ),
      ),
    );
  }
}
