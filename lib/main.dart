import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code Contact',
      home: QrCodeContactPage(),
      theme: ThemeData(
        brightness: Brightness.light,
        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: ThemeMode.system,
      /* ThemeMode.system to follow system theme, 
				 ThemeMode.light for light theme, 
				 ThemeMode.dark for dark theme
			*/
    );
  }
}

class QrCodeContactPage extends StatefulWidget {
  @override
  _QrCodeContactPageState createState() => _QrCodeContactPageState();
}

class _QrCodeContactPageState extends State<QrCodeContactPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
  String _phone = "";
  Uint8List _bytes = Uint8List(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Contact QR Code'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Align(
                  widthFactor: 1,
                  heightFactor: 1,
                child: QrImage(
                  data: "MECARD:N:$_name;TEL:$_phone;;",
                  version: QrVersions.auto,
                  backgroundColor: Colors.white,
                ),
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onChanged: (value) => {
                  _name = value,
                  setState(() {
                    _bytes = utf8.encode("MECARD:N:$_name;TEL:$_phone;;")
                        as Uint8List;
                  }),
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
                onChanged: (value) => {
                  _phone = value,
                  setState(() {
                    _bytes = utf8.encode("MECARD:N:$_name;TEL:$_phone;;")
                        as Uint8List;
                  }),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
