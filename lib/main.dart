import 'package:flutter/material.dart';
import 'package:xdg_desktop_portal/xdg_desktop_portal.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portal Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Portal Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _portal = XdgDesktopPortalClient();
  final _uriController = TextEditingController(text: 'https://example.com');
  final _settingsNamespaceController =
      TextEditingController(text: 'org.gnome.desktop.interface');
  final _settingsKeyController = TextEditingController(text: 'font-name');

  String _settingsValue = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                TextField(
                  controller: _uriController,
                ),
                OutlinedButton(
                  onPressed: () async {
                    await _portal.openUri.openUri(_uriController.text);
                  },
                  child: const Text('Open URI'),
                ),
              ],
            ),
            Column(children: <Widget>[
              TextField(
                controller: _settingsNamespaceController,
              ),
              TextField(
                controller: _settingsKeyController,
              ),
              OutlinedButton(
                onPressed: () async {
                  var value = await _portal.settings.read(
                      _settingsNamespaceController.text,
                      _settingsKeyController.text);
                  setState(() => _settingsValue = '${value.toNative()}');
                },
                child: const Text('Read Setting'),
              ),
              Text(_settingsValue),
            ]),
          ],
        ),
      ),
    );
  }
}
