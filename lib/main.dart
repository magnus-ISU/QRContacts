import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
	const MyApp({super.key});

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'QR Code Contact',
			home: const QrCodeContactPage(),
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
	const QrCodeContactPage({super.key});

	@override
	_QrCodeContactPageState createState() => _QrCodeContactPageState();
}

class _QrCodeContactPageState extends State<QrCodeContactPage> {
	final _formKey = GlobalKey<FormState>();
	String _name = "";
	String _phone = "";
	String _location = "";
	String _description = "";
	String _email = "";
	String _url = "";
	final TextEditingController _nameControl = TextEditingController();
	final TextEditingController _phoneControl = TextEditingController();
	final TextEditingController _emailControl = TextEditingController();
	final TextEditingController _locationControl = TextEditingController();
	final TextEditingController _descriptionControl = TextEditingController();
	final TextEditingController _urlControl = TextEditingController();
	final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

	saveState() {
		setState(() {});
	}

	String mecardName() {
		if (_name.contains(",")) {
			return _name;
		}
		if (!_name.contains(" ")) {
			return _name;
		}
		int nameParts = _name.indexOf(" ");
		return "${_name.substring(nameParts + 1)},${_name.substring(0, nameParts)}";
	}

	@override
	void initState() {
		super.initState();

		setStartingState();
	}

	setStartingState() async {
		final SharedPreferences prefs = await _prefs;
		_name = prefs.getString("name") ?? "";
		_nameControl.text = _name;
		_phone = prefs.getString("phone") ?? "";
		_phoneControl.text = _phone;
		_email = prefs.getString("email") ?? "";
		_emailControl.text = _email;
		_location = prefs.getString("location") ?? "";
		_locationControl.text = _location;
		_description = prefs.getString("description") ?? "";
		_descriptionControl.text = _description;
		_url = prefs.getString("url") ?? "";
		_urlControl.text = _url;
		print("read from disk");
		saveState();
	}

	Future<void> saveName() async {
		_prefs.then((prefs) => prefs.setString("name", _name));
		print("saved name to disk");
	}

	Future<void> savePhone() async {
		_prefs.then((prefs) => prefs.setString("phone", _phone));
	}

	Future<void> saveEmail() async {
		_prefs.then((prefs) => prefs.setString("email", _email));
	}

	Future<void> saveLocation() async {
		_prefs.then((prefs) => prefs.setString("location", _location));
	}

	Future<void> saveDescription() async {
		_prefs.then((prefs) => prefs.setString("description", _description));
	}

	Future<void> saveUrl() async {
		_prefs.then((prefs) => prefs.setString("url", _url));
	}

	saveVarFocus(bool isFocusedNow, Function f) {
		if (!isFocusedNow) {
			f();
		}
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('Create Contact QR Code'),
			),
			body: Form(
				key: _formKey,
				child: Padding(
					padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 0.0),
					child: Column(
						mainAxisSize: MainAxisSize.min,
						children: [
							Expanded(
								child: Align(
									widthFactor: 1,
									heightFactor: 1,
									child: QrImage(
										padding: const EdgeInsets.all(4.0),
										data:
												"MECARD:N:${mecardName()};TEL:${_phone.replaceAll("-", "")};EMAIL:$_email;ADR:$_location;URL:$_url;NOTE:$_description;;",
										version: QrVersions.auto,
										backgroundColor: Colors.white,
									),
								),
							),
							Padding(
								padding: const EdgeInsets.all(12.0),
								child: Card(
									shape: const RoundedRectangleBorder(
											borderRadius: BorderRadius.all(Radius.circular(10.0))),
									child: Padding(
										padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
										child: Column(
											children: [
												Focus(
													onFocusChange: (focus) =>
															saveVarFocus(focus, saveName),
													child: TextFormField(
														onChanged: (value) => {_name = value, saveState()},
														controller: _nameControl,
														decoration: const InputDecoration(
															labelText: 'Name',
															suffixIcon: Icon(Icons.person),
															labelStyle: TextStyle(fontSize: 20),
														),
													),
												),
												Focus(
													onFocusChange: (focus) =>
															saveVarFocus(focus, savePhone),
													child: TextFormField(
														decoration: const InputDecoration(
																labelText: 'Phone',
																isDense: true,
																suffixIcon: Icon(Icons.phone)),
														controller: _phoneControl,
														onChanged: (value) => {_phone = value, saveState()},
													),
												),
												Focus(
													onFocusChange: (focus) =>
															saveVarFocus(focus, saveEmail),
													child: TextFormField(
														decoration: const InputDecoration(
																labelText: 'Email',
																isDense: true,
																suffixIcon: Icon(Icons.email)),
														controller: _emailControl,
														onChanged: (value) => {_email = value, saveState()},
													),
												),
												Focus(
													onFocusChange: (focus) =>
															saveVarFocus(focus, saveLocation),
													child: TextFormField(
														decoration: const InputDecoration(
																labelText: 'Location',
																isDense: true,
																suffixIcon: Icon(Icons.location_pin)),
														controller: _locationControl,
														onChanged: (value) =>
																{_location = value, saveState()},
													),
												),
												Focus(
													onFocusChange: (focus) =>
															saveVarFocus(focus, saveDescription),
													child: TextFormField(
														decoration: const InputDecoration(
																labelText: 'Description',
																isDense: true,
																suffixIcon: Icon(Icons.note)),
														controller: _descriptionControl,
														onChanged: (value) =>
																{_description = value, saveState()},
													),
												),
												Focus(
													onFocusChange: (focus) =>
															saveVarFocus(focus, saveUrl),
													child: TextFormField(
														decoration: const InputDecoration(
																labelText: 'Website',
																isDense: true,
																suffixIcon: Icon(Icons.web)),
														controller: _urlControl,
														onChanged: (value) => {_url = value, saveState()},
													),
												),
											],
										),
									),
								),
							),
						],
					),
				),
			),
		);
	}
}
