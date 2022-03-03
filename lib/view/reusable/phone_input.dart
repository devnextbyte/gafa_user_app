import 'package:flutter/material.dart';
import 'package:gafamoney/utils/snippets.dart';
import 'package:gafamoney/view/reusable/flag_widget.dart';

class PhoneField extends StatefulWidget {
  final TextEditingController _phoneNumberController;

  PhoneField({Key key, @required TextEditingController controller})
      : _phoneNumberController = controller,
        super(key: key);

  @override
  _PhoneFieldState createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  final _countryCode = TextEditingController();
  String _enteredPhone;

  @override
  Widget build(BuildContext context) {
    return FormField(
      key: Key("phone_input_field"),
      validator: (s) => validatePhone(_enteredPhone),
      builder: (state) => Column(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Phone Number",
                style: TextStyle(color: Theme.of(context).primaryColor),
              )),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FlagWidget(key: Key("flag_widget"), controller: _countryCode),
              Expanded(
                child: TextFormField(
                  key: Key("phone_input"),
                  onChanged: (phone) {
                    widget._phoneNumberController.text =
                        "${_countryCode.text}$phone";
                    _enteredPhone = phone;
                  },
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 0)),
                ),
              ),
            ],
          ),
          Divider(
            thickness: state.hasError ? 0.9 : 0.6,
            height: 0,
            color: state.hasError
                ? Theme.of(context).errorColor
                : Theme.of(context).hintColor,
          ),
          state.hasError
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      state.errorText,
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(color: Theme.of(context).errorColor),
                    ),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
