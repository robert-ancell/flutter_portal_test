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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _portal = XdgDesktopPortalClient();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Portal Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            EmailPage(portal: _portal),
            LocationPage(portal: _portal),
            NetworkMonitorPage(portal: _portal),
            NotificationPage(portal: _portal),
            OpenUriPage(portal: _portal),
            ProxyResolverPage(portal: _portal),
            SettingsPage(portal: _portal),
          ],
        ),
      ),
    );
  }
}

class EmailPage extends StatefulWidget {
  final XdgDesktopPortalClient portal;

  const EmailPage({Key? key, required XdgDesktopPortalClient this.portal})
      : super(key: key);

  @override
  State<EmailPage> createState() => EmailPageState();
}

class EmailPageState extends State<EmailPage> {
  EmailPageState();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            OutlinedButton(
              onPressed: () async {
                await widget.portal.email.composeEmail();
              },
              child: const Text('Compose Email'),
            ),
          ],
        )
      ],
    );
  }
}

class LocationPage extends StatefulWidget {
  final XdgDesktopPortalClient portal;
  const LocationPage({Key? key, required XdgDesktopPortalClient this.portal})
      : super(key: key);

  @override
  State<LocationPage> createState() => LocationPageState();
}

class LocationPageState extends State<LocationPage> {
  LocationPageState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        OutlinedButton(
          onPressed: () async {
            print('FIXME');
          },
          child: const Text('Location'),
        ),
      ],
    );
  }
}

class NetworkMonitorPage extends StatefulWidget {
  final XdgDesktopPortalClient portal;
  const NetworkMonitorPage(
      {Key? key, required XdgDesktopPortalClient this.portal})
      : super(key: key);

  @override
  State<NetworkMonitorPage> createState() => NetworkMonitorPageState();
}

class NetworkMonitorPageState extends State<NetworkMonitorPage> {
  NetworkMonitorPageState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        OutlinedButton(
          onPressed: () async {
            print('FIXME');
          },
          child: const Text('Network Monitor'),
        ),
      ],
    );
  }
}

class NotificationPage extends StatefulWidget {
  final XdgDesktopPortalClient portal;
  const NotificationPage(
      {Key? key, required XdgDesktopPortalClient this.portal})
      : super(key: key);

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
    return Column(
      children: <Widget>[
        TextField(
          controller: _titleController,
          decoration: InputDecoration(
            helperText: 'Title',
            border: OutlineInputBorder(),
          ),
        ),
        TextField(
          controller: _bodyController,
          decoration: InputDecoration(
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
    );
  }
}

class OpenUriPage extends StatefulWidget {
  final XdgDesktopPortalClient portal;

  const OpenUriPage({Key? key, required XdgDesktopPortalClient this.portal})
      : super(key: key);

  @override
  State<OpenUriPage> createState() => OpenUriPageState();
}

class OpenUriPageState extends State<OpenUriPage> {
  final _uriController = TextEditingController(text: 'https://example.com');

  OpenUriPageState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: _uriController,
          decoration: InputDecoration(
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
    );
  }
}

class ProxyResolverPage extends StatefulWidget {
  final XdgDesktopPortalClient portal;

  const ProxyResolverPage(
      {Key? key, required XdgDesktopPortalClient this.portal})
      : super(key: key);

  @override
  State<ProxyResolverPage> createState() => ProxyResolverPageState();
}

class ProxyResolverPageState extends State<ProxyResolverPage> {
  final _uriController = TextEditingController(text: 'https://example.com');

  String _lookupResult = '';

  ProxyResolverPageState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: _uriController,
          decoration: InputDecoration(
            helperText: 'URI',
            border: OutlineInputBorder(),
          ),
        ),
        OutlinedButton(
          onPressed: () async {
            var uris =
                await widget.portal.proxyResolver.lookup(_uriController.text);
            setState(() => _lookupResult = uris.join(', '));
          },
          child: const Text('Lookup URI'),
        ),
        Text(_lookupResult),
      ],
    );
  }
}

class SettingsPage extends StatefulWidget {
  final XdgDesktopPortalClient portal;

  const SettingsPage({Key? key, required XdgDesktopPortalClient this.portal})
      : super(key: key);

  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  final _namespaceController =
      TextEditingController(text: 'org.gnome.desktop.interface');
  final _keyController = TextEditingController(text: 'font-name');

  String _settingsValue = '';

  SettingsPageState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: _namespaceController,
          decoration: InputDecoration(
            helperText: 'Namespace',
            border: OutlineInputBorder(),
          ),
        ),
        TextField(
          controller: _keyController,
          decoration: InputDecoration(
            helperText: 'Key',
            border: OutlineInputBorder(),
          ),
        ),
        OutlinedButton(
          onPressed: () async {
            var value = await widget.portal.settings
                .read(_namespaceController.text, _keyController.text);
            setState(() => _settingsValue = '${value.toNative()}');
          },
          child: const Text('Read Setting'),
        ),
        Text(_settingsValue),
      ],
    );
  }
}
