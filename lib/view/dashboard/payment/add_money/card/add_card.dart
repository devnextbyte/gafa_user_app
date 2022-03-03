import 'package:flutter/material.dart';
import 'package:gafamoney/model/card_model.dart';
import 'package:gafamoney/state/auth_state.dart';
import 'package:gafamoney/utils/snippets.dart';
import 'package:gafamoney/view/reusable/header_bar.dart';
import 'package:provider/provider.dart';
import 'package:stripe_api/stripe_api.dart';

class AddCard extends StatefulWidget {
  @override
  _AddCardState createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  bool tnc = true;
  bool loading = false;
  final name = TextEditingController();
  final cardNumber = TextEditingController();

  // final expiryDate = TextEditingController();
  final cvv = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final TextEditingController expiryDate = MaskedTextController(mask: '00/00');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final key = "pk_test_Oppw5TTUbtd4n5xCTfNOkEv000GvLxwOLG";
    Stripe.init(key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(children: [
        HeaderBar(title: "Credit / Debit Card", showBackButton: true),
        getForm(context),
      ]),
    ));
  }

  Widget getForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: formKey,
        child: Column(children: [
          TextFormField(
              validator: mandatoryValidator,
              controller: name,
              decoration: InputDecoration(labelText: "Holders Name")),
          SizedBox(height: 8),
          TextFormField(
            maxLength: 16,
              validator: (s) => s.length == 16
                  ? null
                  : "Enter a valid card number (16 digit)",
              controller: cardNumber,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Card Number")),
          SizedBox(height: 8),
          Row(children: [
            Expanded(
                child: TextFormField(
                    validator: (s) {
                      if (s.length == 5 && s.characters.toList()[2] == "/") {
                        final month = int.parse('${expiryDate.text.split('/')[0]}');
                        if(month>0 && month <=12){
                          return null;
                        }else{
                          return "Please enter correct month";
                        }
                      } else {
                        return "Enter valid date (mm/yy)";
                      }
                    },
                    keyboardType: TextInputType.number,
                    controller: expiryDate,
                    decoration:
                        InputDecoration(labelText: "Expiry Date (mm/yy)"))),
            SizedBox(width: 40),
            Expanded(
                child: TextFormField(
                    validator: mandatoryValidator,
                    controller: cvv,
                    decoration: InputDecoration(labelText: "CVV"))),
          ]),
          SizedBox(height: 16),
          Row(children: [
            Checkbox(value: tnc, onChanged: (val) => setState(() => tnc = val)),
            SizedBox(width: 8),
            Text("Accept terms and conditions")
          ]),
          SizedBox(height: 16),
          Row(children: [
            Builder(
              builder: (context) => loading
                  ? CircularProgressIndicator()
                  : Expanded(
                      child: ElevatedButton(
                          onPressed: tnc ? () => addCard(context) : null,
                          child: Text("Continue")),
                    ),
            ),
          ]),
        ]),
      ),
    );
  }

  void addCard(BuildContext context) async {
    if (formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      StripeCard stripeCard = StripeCard(
          number: cardNumber.text,
          expMonth: int.parse('${expiryDate.text.split('/')[0]}'),
          expYear: int.parse('20${expiryDate.text.split('/')[1]}'),
          cvc: cvv.text);
      final token = await Stripe.instance.createCardToken(stripeCard);
      final data = AddCardParam(
          lastDigits: cardNumber.text.substring(cardNumber.text.length - 4),
          name: name.text,
          expiryDate:
              '20${expiryDate.text.split('/')[1]}-${expiryDate.text.split('/')[0]}-09T10:06:30.232Z',
          token: token.id,
          zipCode: "0000");

      final resp = await requestAddCard.send(
          token: await context.read<AuthState>().token, parameters: data);
      setState(() {
        loading = false;
      });
      if (resp.hasError) {
        snack(context, resp.error.errorMessage);
      } else {
        Navigator.of(context).pop();
      }
    }
  }
}

class MaskedTextController extends TextEditingController {
  MaskedTextController({String text, this.mask, Map<String, RegExp> translator})
      : super(text: text) {
    this.translator = translator ?? MaskedTextController.getDefaultTranslator();

    addListener(() {
      final String previous = _lastUpdatedText;
      if (this.beforeChange(previous, this.text)) {
        updateText(this.text);
        this.afterChange(previous, this.text);
      } else {
        updateText(_lastUpdatedText);
      }
    });

    updateText(this.text);
  }

  String mask;

  Map<String, RegExp> translator;

  Function afterChange = (String previous, String next) {};
  Function beforeChange = (String previous, String next) {
    return true;
  };

  String _lastUpdatedText = '';

  void updateText(String text) {
    if (text != null) {
      this.text = _applyMask(mask, text);
    } else {
      this.text = '';
    }

    _lastUpdatedText = this.text;
  }

  void updateMask(String mask, {bool moveCursorToEnd = true}) {
    this.mask = mask;
    updateText(text);

    if (moveCursorToEnd) {
      this.moveCursorToEnd();
    }
  }

  void moveCursorToEnd() {
    final String text = _lastUpdatedText;
    selection =
        TextSelection.fromPosition(TextPosition(offset: (text ?? '').length));
  }

  @override
  set text(String newText) {
    if (super.text != newText) {
      super.text = newText;
      moveCursorToEnd();
    }
  }

  static Map<String, RegExp> getDefaultTranslator() {
    return {
      'A': RegExp(r'[A-Za-z]'),
      '0': RegExp(r'[0-9]'),
      '@': RegExp(r'[A-Za-z0-9]'),
      '*': RegExp(r'.*')
    };
  }

  String _applyMask(String mask, String value) {
    String result = '';

    int maskCharIndex = 0;
    int valueCharIndex = 0;

    while (true) {
      // if mask is ended, break.
      if (maskCharIndex == mask.length) {
        break;
      }

      // if value is ended, break.
      if (valueCharIndex == value.length) {
        break;
      }

      final String maskChar = mask[maskCharIndex];
      final String valueChar = value[valueCharIndex];

      // value equals mask, just set
      if (maskChar == valueChar) {
        result += maskChar;
        valueCharIndex += 1;
        maskCharIndex += 1;
        continue;
      }

      // apply translator if match
      if (translator.containsKey(maskChar)) {
        if (translator[maskChar].hasMatch(valueChar)) {
          result += valueChar;
          maskCharIndex += 1;
        }

        valueCharIndex += 1;
        continue;
      }

      // not masked value, fixed char on mask
      result += maskChar;
      maskCharIndex += 1;
      continue;
    }

    return result;
  }
}
