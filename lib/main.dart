import 'dart:async';
import 'dart:io';

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
        length: 12,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Account'),
                Tab(text: 'Camera'),
                Tab(text: 'Documents'),
                Tab(text: 'Email'),
                Tab(text: 'FileChooser'),
                Tab(text: 'Location'),
                Tab(text: 'NetworkMonitor'),
                Tab(text: 'Notification'),
                Tab(text: 'OpenURI'),
                Tab(text: 'ProxyResolver'),
                Tab(text: 'Secret'),
                Tab(text: 'Settings'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              AccountPage(portal: portal),
              CameraPage(portal: portal),
              DocumentsPage(portal: portal),
              EmailPage(portal: portal),
              FileChooserPage(portal: portal),
              LocationPage(portal: portal),
              NetworkMonitorPage(portal: portal),
              NotificationPage(portal: portal),
              OpenUriPage(portal: portal),
              ProxyResolverPage(portal: portal),
              SecretPage(portal: portal),
              SettingsPage(portal: portal),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountPage extends StatefulWidget {
  final XdgDesktopPortalClient portal;

  const AccountPage({Key? key, required this.portal}) : super(key: key);

  @override
  State<AccountPage> createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _imageController = TextEditingController();

  AccountPageState();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          OutlinedButton(
            onPressed: () async {
              _idController.text = '';
              _nameController.text = '';
              _imageController.text = '';
              var result =
                  await widget.portal.account.getUserInformation().first;
              _idController.text = result.id;
              _nameController.text = result.name;
              _imageController.text = result.image;
            },
            child: const Text('Get User Information'),
          ),
          TextField(
            readOnly: true,
            controller: _idController,
            decoration: const InputDecoration(
              helperText: 'Id',
              border: OutlineInputBorder(),
            ),
          ),
          TextField(
            readOnly: true,
            controller: _nameController,
            decoration: const InputDecoration(
              helperText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          TextField(
            readOnly: true,
            controller: _imageController,
            decoration: const InputDecoration(
              helperText: 'Icon',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}

class CameraPage extends StatefulWidget {
  final XdgDesktopPortalClient portal;

  const CameraPage({Key? key, required this.portal}) : super(key: key);

  @override
  State<CameraPage> createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  CameraPageState();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          OutlinedButton(
            onPressed: () async {
              await widget.portal.camera.accessCamera();
            },
            child: const Text('Access Camera'),
          ),
        ],
      ),
    );
  }
}

class DocumentsPage extends StatefulWidget {
  final XdgDesktopPortalClient portal;

  const DocumentsPage({Key? key, required this.portal}) : super(key: key);

  @override
  State<DocumentsPage> createState() => DocumentsPageState();
}

class DocumentsPageState extends State<DocumentsPage> {
  final _addFileController = TextEditingController();
  final _permissionsDocIdController = TextEditingController();
  final _permissionsAppIdController = TextEditingController();
  var _permissionRead = false;
  var _permissionWrite = false;
  var _permissionGrantPermissions = false;
  var _permissionDelete = false;
  final _deleteDocIdController = TextEditingController();

  Set<XdgDocumentPermission> get _permissions {
    var permissions = <XdgDocumentPermission>{};
    if (_permissionRead) {
      permissions.add(XdgDocumentPermission.read);
    }
    if (_permissionWrite) {
      permissions.add(XdgDocumentPermission.write);
    }
    if (_permissionGrantPermissions) {
      permissions.add(XdgDocumentPermission.grantPermissions);
    }
    if (_permissionDelete) {
      permissions.add(XdgDocumentPermission.delete);
    }
    return permissions;
  }

  DocumentsPageState();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _addFileController,
            decoration: const InputDecoration(
              helperText: 'File',
              border: OutlineInputBorder(),
            ),
          ),
          OutlinedButton(
            onPressed: () async {
              var path = _addFileController.text;
              var docIds = await widget.portal.documents.add([File(path)]);
              _permissionsDocIdController.text = docIds[0];
              _deleteDocIdController.text = docIds[0];
            },
            child: const Text('Add'),
          ),
          TextField(
            controller: _permissionsDocIdController,
            decoration: const InputDecoration(
              helperText: 'Document ID',
              border: OutlineInputBorder(),
            ),
          ),
          TextField(
            controller: _permissionsAppIdController,
            decoration: const InputDecoration(
              helperText: 'Application ID',
              border: OutlineInputBorder(),
            ),
          ),
          Row(children: <Widget>[
            Switch(
                value: _permissionRead,
                onChanged: (enabled) async {
                  setState(() {
                    _permissionRead = enabled;
                  });
                }),
            const Text('Read'),
          ]),
          Row(children: <Widget>[
            Switch(
                value: _permissionWrite,
                onChanged: (enabled) async {
                  setState(() {
                    _permissionWrite = enabled;
                  });
                }),
            const Text('Write'),
          ]),
          Row(children: <Widget>[
            Switch(
                value: _permissionGrantPermissions,
                onChanged: (enabled) async {
                  setState(() {
                    _permissionGrantPermissions = enabled;
                  });
                }),
            const Text('Grant Permissions'),
          ]),
          Row(children: <Widget>[
            Switch(
                value: _permissionDelete,
                onChanged: (enabled) async {
                  setState(() {
                    _permissionDelete = enabled;
                  });
                }),
            const Text('Delete'),
          ]),
          OutlinedButton(
            onPressed: () async {
              var docId = _permissionsDocIdController.text;
              var appId = _permissionsAppIdController.text;
              await widget.portal.documents
                  .grantPermissions(docId, appId, _permissions);
            },
            child: const Text('Grant Permissions'),
          ),
          OutlinedButton(
            onPressed: () async {
              var docId = _permissionsDocIdController.text;
              var appId = _permissionsAppIdController.text;
              await widget.portal.documents
                  .revokePermissions(docId, appId, _permissions);
            },
            child: const Text('Revoke Permissions'),
          ),
          TextField(
            controller: _deleteDocIdController,
            decoration: const InputDecoration(
              helperText: 'Document ID',
              border: OutlineInputBorder(),
            ),
          ),
          OutlinedButton(
            onPressed: () async {
              var docId = _deleteDocIdController.text;
              await widget.portal.documents.delete(docId);
              if (_permissionsDocIdController.text == docId) {
                _permissionsDocIdController.text = '';
              }
              if (_deleteDocIdController.text == docId) {
                _deleteDocIdController.text = '';
              }
            },
            child: const Text('Delete'),
          ),
        ],
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

class SecretPage extends StatefulWidget {
  final XdgDesktopPortalClient portal;

  const SecretPage({Key? key, required this.portal}) : super(key: key);

  @override
  State<SecretPage> createState() => SecretPageState();
}

class SecretPageState extends State<SecretPage> {
  final _secretController = TextEditingController();

  SecretPageState();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          OutlinedButton(
            onPressed: () async {
              _secretController.text = '';
              var secret = await widget.portal.secret.retrieveSecret();
              _secretController.text =
                  secret.map((v) => v.toRadixString(16).padLeft(2, '0')).join();
            },
            child: const Text('Retrieve Secret'),
          ),
          TextField(
            readOnly: true,
            controller: _secretController,
            decoration: const InputDecoration(
              helperText: 'Secret',
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
