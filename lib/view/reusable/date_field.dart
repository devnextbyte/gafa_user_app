import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class DateInputFormField extends StatefulWidget {
  final TextEditingController controller;
  final bool isRequired;
  final String label;

  const DateInputFormField(
      {@required this.controller,
      @required this.isRequired,
      @required this.label});

  @override
  State<StatefulWidget> createState() => _DateInputFormFieldState();
}

class _DateInputFormFieldState extends State<DateInputFormField> {
  String date = "";

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: widget.isRequired
          ? (val) => date.isEmpty ? "Select Date" : null
          : (val) => null,
      builder: (state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Text(
            widget.label,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Row(
            children: [
              Expanded(
                child: Text(date, style: Theme.of(context).textTheme.bodyText2),
              ),
              IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.calendarAlt,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () => showDatePicker(
                        context: context,
                        initialDate:
                            DateTime.now().subtract(Duration(days: 8030)),
                        firstDate:
                            DateTime.now().subtract(Duration(days: 36500)),
                        lastDate: DateTime.now().subtract(Duration(days: 6570)))
                    .then((pickedDate) {
                  setState(() {
                    date = DateFormat.yMMMd().format(pickedDate);
                  });
                  widget.controller.text = pickedDate.toIso8601String();
                }),
              ),
            ],
          ),
          Divider(
              height: 8,
              thickness: 1,
              color: state.hasError ? Colors.red.shade700 : Colors.grey),
          state.hasError
              ? Text(state.errorText,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(color: Colors.red.shade700))
              : SizedBox(),
        ],
      ),
    );
  }
}
