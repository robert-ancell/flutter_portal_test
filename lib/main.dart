import 'dart:async';

import 'package:flutter/material.dart';
import 'package:xdg_desktop_portal/xdg_desktop_portal.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final portal = XdgDesktopPortalClient();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portal Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DefaultTabController(
        length: 8,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Email'),
                Tab(text: 'FileChooser'),
                Tab(text: 'Location'),
                Tab(text: 'NetworkMonitor'),
                Tab(text: 'Notification'),
                Tab(text: 'OpenURI'),
                Tab(text: 'ProxyResolver'),
                Tab(text: 'Settings'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              EmailPage(portal: portal),
              FileChooserPage(portal: portal),
              LocationPage(portal: portal),
              NetworkMonitorPage(portal: portal),
              NotificationPage(portal: portal),
              OpenUriPage(portal: portal),
              ProxyResolverPage(portal: portal),
              SettingsPage(portal: portal),
            ],
          ),
        ),
      ),
    );
  }
}

class EmailPage extends StatefulWidget {
  final XdgDesktopPortalClient portal;

  const EmailPage({Key? key, required this.portal}) : super(key: key);

  @override
  State<EmailPage> createState() => EmailPageState();
}

class EmailPageState extends State<EmailPage> {
  final _addressController = TextEditingController();
  final _ccController = TextEditingController();
  final _bccController = TextEditingController();
  final _subjectController = TextEditingController();

  EmailPageState();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _addressController,
            decoration: const InputDecoration(
              helperText: 'To',
              border: OutlineInputBorder(),
            ),
          ),
          TextField(
            controller: _ccController,
            decoration: const InputDecoration(
              helperText: 'Cc',
              border: OutlineInputBorder(),
            ),
          ),
          TextField(
            controller: _bccController,
            decoration: const InputDecoration(
              helperText: 'Bcc',
              border: OutlineInputBorder(),
            ),
          ),
          TextField(
            controller: _subjectController,
            decoration: const InputDecoration(
              helperText: 'Subject',
              border: OutlineInputBorder(),
            ),
          ),
          OutlinedButton(
            onPressed: () async {
              Iterable<String> parseAddresses(String text) {
                return text
                    .split(',')
                    .map((a) => a.trim())
                    .where((a) => a != '');
              }

              var addresses = parseAddresses(_addressController.text);
              var cc = parseAddresses(_ccController.text);
              var bcc = parseAddresses(_bccController.text);
              var subject = _subjectController.text;
              await widget.portal.email.composeEmail(
                  addresses: addresses, cc: cc, bcc: bcc, subject: subject);
            },
            child: const Text('Compose Email'),
          ),
        ],
      ),
    );
  }
}

class FileChooserPage extends StatefulWidget {
  final XdgDesktopPortalClient portal;

  const FileChooserPage({Key? key, required this.portal}) : super(key: key);

  @override
  State<FileChooserPage> createState() => FileChooserPageState();
}

class FileChooserPageState extends State<FileChooserPage> {
  final _urisController = TextEditingController();

  FileChooserPageState();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          OutlinedButton(
            onPressed: () async {
              var result = await widget.portal.fileChooser
                  .openFile(title: 'Open File')
                  .first;
              _urisController.text = result.uris.join(', ');
            },
            child: const Text('Open File'),
          ),
          OutlinedButton(
            onPressed: () async {
              var result = await widget.portal.fileChooser
                  .saveFile(title: 'Save File')
                  .first;
              _urisController.text = result.uris.join(', ');
            },
            child: const Text('Save File'),
          ),
          OutlinedButton(
            onPressed: () async {
              var result = await widget.portal.fileChooser
                  .saveFiles(title: 'Save Files')
                  .first;
              _urisController.text = result.uris.join(', ');
            },
            child: const Text('Save Files'),
          ),
          TextField(
            readOnly: true,
            controller: _urisController,
            decoration: const InputDecoration(
              helperText: 'URIs',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}

class LocationPage extends StatefulWidget {
  final XdgDesktopPortalClient portal;
  const LocationPage({Key? key, required this.portal}) : super(key: key);

  @override
  State<LocationPage> createState() => LocationPageState();
}

class LocationPageState extends State<LocationPage> {
  Stream<XdgLocation>? locations;

  LocationPageState();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Row(children: <Widget>[
            Switch(
              value: locations != null,
              onChanged: (enabled) async {
                if (enabled) {
                  var locations = widget.portal.location.createSession();
                  setState(() {
                    this.locations = locations;
                  });
                } else {
                  setState(() => locations = null);
                }
              },
            ),
            const Text('Enabled'),
          ]),
          StreamBuilder<XdgLocation>(
            stream: locations,
            builder:
                (BuildContext context, AsyncSnapshot<XdgLocation> snapshot) {
              var latitudeController = TextEditingController();
              var longitudeController = TextEditingController();
              if (snapshot.hasData) {
                var location = snapshot.data!;
                latitudeController.text = '${location.latitude}';
                longitudeController.text = '${location.longitude}';
              }
              return Column(
                children: <Widget>[
                  TextField(
                    readOnly: true,
                    controller: latitudeController,
                    decoration: const InputDecoration(
                      helperText: 'Latitude',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextField(
                    readOnly: true,
                    controller: longitudeController,
                    decoration: const InputDecoration(
                      helperText: 'Longitude',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class NetworkMonitorPage extends StatefulWidget {
  final XdgDesktopPortalClient portal;
  const NetworkMonitorPage({Key? key, required this.portal}) : super(key: key);

  @override
  State<NetworkMonitorPage> createState() => NetworkMonitorPageState();
}

class NetworkMonitorPageState extends State<NetworkMonitorPage> {
  NetworkMonitorPageState();

  Stream<XdgNetworkStatus>? status;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Row(children: <Widget>[
            Switch(
              value: status != null,
              onChanged: (enabled) async {
                if (enabled) {
                  var status = widget.portal.networkMonitor.status;
                  setState(() {
                    this.status = status;
                  });
                } else {
                  setState(() => status = null);
                }
              },
            ),
            const Text('Enabled'),
          ]),
          StreamBuilder<XdgNetworkStatus>(
            stream: status,
            builder: (BuildContext context,
                AsyncSnapshot<XdgNetworkStatus> snapshot) {
              var availableController = TextEditingController();
              var meteredController = TextEditingController();
              if (snapshot.hasData) {
                var s = snapshot.data!;
                availableController.text = s.available ? 'Yes' : 'No';
                meteredController.text = s.metered ? 'Yes' : 'No';
              }
              return Column(
                children: <Widget>[
                  TextField(
                    readOnly: true,
                    controller: availableController,
                    decoration: const InputDecoration(
                      helperText: 'Available',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextField(
                    readOnly: true,
                    controller: meteredController,
                    decoration: const InputDecoration(
                      helperText: 'Metered',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class NotificationPage extends StatefulWidget {
  final XdgDesktopPortalClient portal;
  const NotificationPage({Key? key, required this.portal}) : super(key: key);

  @override
  State<NotificationPage> createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage> {
  final _titleController = TextEditingController(text: 'Warning');
  final _bodyController =
      TextEditingController(text: 'Flutter may be addictive');

  NotificationPageState();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              helperText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
          TextField(
            controller: _bodyController,
            decoration: const InputDecoration(
              helperText: 'Body',
              border: OutlineInputBorder(),
            ),
          ),
          OutlinedButton(
            onPressed: () async {
              await widget.portal.notification.addNotification(
                  'notification_id_1',
                  title: _titleController.text,
                  body: _bodyController.text);
            },
            child: const Text('Add Notification'),
          ),
        ],
      ),
    );
  }
}

class OpenUriPage extends StatefulWidget {
  final XdgDesktopPortalClient portal;

  const OpenUriPage({Key? key, required this.portal}) : super(key: key);

  @override
  State<OpenUriPage> createState() => OpenUriPageState();
}

class OpenUriPageState extends State<OpenUriPage> {
  final _uriController = TextEditingController(text: 'https://example.com');

  OpenUriPageState();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _uriController,
            decoration: const InputDecoration(
              helperText: 'URI',
              border: OutlineInputBorder(),
            ),
          ),
          OutlinedButton(
            onPressed: () async {
              await widget.portal.openUri.openUri(_uriController.text);
            },
            child: const Text('Open URI'),
          ),
        ],
      ),
    );
  }
}

class ProxyResolverPage extends StatefulWidget {
  final XdgDesktopPortalClient portal;

  const ProxyResolverPage({Key? key, required this.portal}) : super(key: key);

  @override
  State<ProxyResolverPage> createState() => ProxyResolverPageState();
}

class ProxyResolverPageState extends State<ProxyResolverPage> {
  final _uriController = TextEditingController(text: 'https://example.com');
  final _resultController = TextEditingController();

  ProxyResolverPageState();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _uriController,
            decoration: const InputDecoration(
              helperText: 'URI',
              border: OutlineInputBorder(),
            ),
          ),
          OutlinedButton(
            onPressed: () async {
              _resultController.text = '';
              var proxies =
                  await widget.portal.proxyResolver.lookup(_uriController.text);
              _resultController.text = proxies.join(', ');
            },
            child: const Text('Lookup URI'),
          ),
          TextField(
            readOnly: true,
            controller: _resultController,
            decoration: const InputDecoration(
              helperText: 'Proxies',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  final XdgDesktopPortalClient portal;

  const SettingsPage({Key? key, required this.portal}) : super(key: key);

  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final _namespaceController =
      TextEditingController(text: 'org.gnome.desktop.interface');
  final _keyController = TextEditingController(text: 'font-name');
  final _valueController = TextEditingController();

  SettingsPageState();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _namespaceController,
            decoration: const InputDecoration(
              helperText: 'Namespace',
              border: OutlineInputBorder(),
            ),
          ),
          TextField(
            controller: _keyController,
            decoration: const InputDecoration(
              helperText: 'Key',
              border: OutlineInputBorder(),
            ),
          ),
          OutlinedButton(
            onPressed: () async {
              _valueController.text = '';
              var value = await widget.portal.settings
                  .read(_namespaceController.text, _keyController.text);
              _valueController.text = '${value.toNative()}';
            },
            child: const Text('Read Setting'),
          ),
          TextField(
            readOnly: true,
            controller: _valueController,
            decoration: const InputDecoration(
              helperText: 'Value',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
