import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:smart_select/smart_select.dart';
import 'package:vibration/vibration.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class Country {
  Country(this.code, this.title);

  String code;
  String title;
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController? _countryCodeCtrl;
  TextEditingController? _phoneNumberCtrl;
  bool _verificationSent = false;
  bool _processing = false;
  bool _invalidCode = false;
  String _phoneNumber = '';
  String _verificationCode = '';

  var countryIndex = 0;

  final countries = [
    S2Choice<String>(value: '7', title: '+7 Russian Federation'),
    S2Choice<String>(value: '90', title: '+90 Turkey'),
  ];

  var mapping = {'7': 0, '90': 1};

  @override
  void initState() {
    super.initState();
    _countryCodeCtrl = TextEditingController();
    _phoneNumberCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _countryCodeCtrl?.dispose();
    _phoneNumberCtrl?.dispose();
    super.dispose();
  }

  void _requestSMS() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _processing = true;
    });

    var params = {'phone': _phoneNumber};

    var uri = Uri.http('city4live.ru:5000', '/login/sms', params);
    var response = await http.get(uri);

    var success = jsonDecode(response.body)['code'] == null;

    setState(() {
      _verificationSent = success;
      _processing = false;
    });
  }

  void _sendVerification() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _processing = true;
    });

    var params = {'phone': _phoneNumber, 'sms_code': _verificationCode};
    var uri = Uri.http('city4live.ru:5000', '/login', params);
    var response = await http.get(uri);

    var json = jsonDecode(response.body);
    var success = json['code'] == null;

    if (success) {
      FirebaseChatCore.instance.updateUser(json['body']['id'].toString());
    }

    setState(() {
      if (!success) {
        _invalidCode = true;
      }
      _processing = false;
    });

    if (success) {
      // await Navigator.pushNamed(context, '/navigation_page');
      Navigator.of(context)
        .pushNamedAndRemoveUntil('/navigation_page', (Route<dynamic> route) => false);
    }
  }

  Widget _buildError() {
    return _invalidCode
        ? const Center(
            child: Text('Invalid code!', style: TextStyle(color: Colors.red)))
        : const Text('');
  }

  @override
  Widget build(BuildContext context) {
    final _focusNode = FocusScope.of(context);

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: const Text('Your phone number'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: _processing
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _verificationSent
                ? Column(
                    children: [
                      const SizedBox(height: 160),
                      const Center(
                        child: Text('Input verification code'),
                      ),
                      const SizedBox(height: 16),
                      _buildError(),
                      const SizedBox(height: 16),
                      PinFieldAutoFill(
                        decoration: UnderlineDecoration(
                          textStyle: const TextStyle(
                              fontSize: 20, color: Colors.black),
                          colorBuilder: FixedColorBuilder(_invalidCode
                              ? Colors.red.withOpacity(0.5)
                              : Colors.black.withOpacity(0.3)),
                        ), // UnderlineDecoration, BoxLooseDecoration or BoxTightDecoration see https://github.com/TinoGuo/pin_input_text_field for more info,
                        currentCode: _verificationCode, // prefill with a code
                        onCodeSubmitted: (code) {}, //code submitted callback
                        onCodeChanged: (code) {
                          if (code!.length == 6) {
                            _verificationCode = code;
                            FocusScope.of(context).requestFocus(FocusNode());
                          }
                        }, //code changed callbac
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 8),
                      Container(
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.grey, width: 1.0))),
                        child: SmartSelect.single(
                          choiceItems: countries,
                          title: 'Country',
                          placeholder: '',
                          onChange: (state) {
                            _countryCodeCtrl?.text = state.value.toString();
                            _focusNode.nextFocus();
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: TextField(
                                  controller: _countryCodeCtrl,
                                  style: const TextStyle(height: 1.5),
                                  decoration: const InputDecoration(
                                      prefixText: '+',
                                      isDense: true,
                                      counterText: '',
                                      hintText: 'code'),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ], // Only num
                                  maxLength: 5,
                                  onChanged: (text) {
                                    if (text.length > 4) {
                                      var codeSize = 0;
                                      var found = false;
                                      var foundIndex = 0;
                                      for (codeSize = 1;
                                          codeSize <= text.length;
                                          codeSize++) {
                                        final code =
                                            text.substring(0, codeSize);
                                        if (mapping.containsKey(code)) {
                                          found = true;
                                          foundIndex = mapping[code] ?? 0;
                                          break;
                                        }
                                      }
                                      if (found) {
                                        setState(() {
                                          countryIndex = foundIndex;
                                        });
                                      } else {
                                        codeSize = 1;
                                      }
                                      _countryCodeCtrl?.text =
                                          text.substring(0, codeSize);
                                      _focusNode.nextFocus();
                                      _phoneNumberCtrl?.text =
                                          text.substring(codeSize);
                                    }
                                  },
                                )),
                          ),
                          Flexible(
                              flex: 11,
                              child: TextField(
                                controller: _phoneNumberCtrl,
                                style: const TextStyle(height: 1.5),
                                decoration: const InputDecoration(
                                    isDense: true,
                                    hintText: '- - -   - - -   - - - -'),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ], // Only num
                                onChanged: (text) {
                                  if (text.isEmpty) {
                                    _focusNode.previousFocus();
                                  }
                                },
                              )),
                        ],
                      )
                    ],
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final phoneNumber =
              (_countryCodeCtrl?.text ?? '') + (_phoneNumberCtrl?.text ?? '');

          if (_verificationSent) {
            _sendVerification();
          } else {
            if (phoneNumber.length == 11) {
              setState(() {
                _phoneNumber = phoneNumber;
              });

              _requestSMS();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid phone number!')));
              Vibration.vibrate();
            }
          }
        },
        child: _processing
            ? const CircularProgressIndicator(
                // valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
            : const Icon(Icons.arrow_forward),
      ),
    );
  }
}
