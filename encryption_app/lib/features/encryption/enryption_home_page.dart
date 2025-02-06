import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/services.dart';

class EncryptionHomePage extends StatefulWidget {
  const EncryptionHomePage({super.key});

  @override
  EncryptionHomePageState createState() => EncryptionHomePageState();
}

class EncryptionHomePageState extends State<EncryptionHomePage> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  String _output = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Encryption & Decryption Tool'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _inputController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a text';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Enter text',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _keyController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a secret key';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Enter secret key',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _output = _encrypt(
                              _inputController.text, _keyController.text);
                          _inputController.clear();
                        });
                      },
                      child: Text(
                        'Encrypt',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _output = _decrypt(
                              _inputController.text, _keyController.text);
                        });
                      },
                      child: Text(
                        'Decrypt',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectableText(
                    _output,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Tooltip(
                      message: 'Copied!',
                      onTriggered: () => copyText(),
                      triggerMode: TooltipTriggerMode.tap,
                      child: Icon(Icons.copy))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

//This method encrypts the text entered in the text field
  String _encrypt(String text, String key) {
    List<int> encrypted = [];
    if (_formKey.currentState!.validate()) {
      for (int i = 0; i < text.length; i++) {
        encrypted.add(text.codeUnitAt(i) ^ key.codeUnitAt(i % key.length));
      }
    }
    return base64Encode(encrypted);
  }

//This method decrypts the encrypted text
  String _decrypt(String encryptedText, String key) {
    List<int> encrypted = base64Decode(encryptedText);
    StringBuffer decrypted = StringBuffer();
    for (int i = 0; i < encrypted.length; i++) {
      decrypted.writeCharCode(encrypted[i] ^ key.codeUnitAt(i % key.length));
    }
    return decrypted.toString();
  }

//This method copies encrypted text
  Future<void> copyText() async {
    await Clipboard.setData(ClipboardData(text: _output));
  }
}
