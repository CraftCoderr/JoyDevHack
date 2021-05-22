import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:smart_select/smart_select.dart';

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

  void _register() async {
    FocusScope.of(context).unfocus();

    // setState(() {
    //   _registering = true;
    // });

    // try {
    //   final credential =
    //       await FirebaseAuth.instance.createUserWithEmailAndPassword(
    //     email: _usernameController!.text,
    //     password: _passwordController!.text,
    //   );
    //   await FirebaseChatCore.instance.createUserInFirestore(
    //     types.User(
    //       avatarUrl: 'https://i.pravatar.cc/300?u=$_email',
    //       firstName: _firstName,
    //       id: credential.user!.uid,
    //       lastName: _lastName,
    //     ),
    //   );
    //   Navigator.of(context)..pop()..pop();
    // } catch (e) {
    //   setState(() {
    //     _registering = false;
    //   });

    //   await showDialog(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //       actions: [
    //         TextButton(
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //           child: const Text('OK'),
    //         ),
    //       ],
    //       content: Text(
    //         e.toString(),
    //       ),
    //       title: const Text('Error'),
    //     ),
    //   );
    // }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _focusNode = FocusScope.of(context);

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: const Text('Register'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 8),
              Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 1.0))),
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
                        child: TextFormField(
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
                                final code = text.substring(0, codeSize);
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
                              _phoneNumberCtrl?.text = text.substring(codeSize);
                            }
                          },
                        )),
                  ),
                  Flexible(
                      flex: 11,
                      child: TextFormField(
                        controller: _phoneNumberCtrl,
                        style: const TextStyle(height: 1.5),
                        decoration: const InputDecoration(
                            isDense: true, hintText: '- - -   - - -   - - - -'),
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
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final phoneNumber =
              (_countryCodeCtrl?.text ?? '') + (_phoneNumberCtrl?.text ?? '');

          if (phoneNumber.length == 11) {
            // If the form is valid, display a snackbar. In the real world,te
            // you'd often call a server or save the information in a database.
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Processing Data')));
          }
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
