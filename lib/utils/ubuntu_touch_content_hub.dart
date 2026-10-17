import 'dart:io';

import 'package:dbus/dbus.dart';

const _fallbackAppId = 'piliplus.alphaliu01_piliplus_2.1.6';

/// Charges a local file to the system player. State 3 means Charged.
Future<int> chargeUbuntuTouchVideo(String path) async {
  final client = DBusClient.session();
  try {
    final hub = DBusRemoteObject(
      client,
      name: 'com.lomiri.content.dbus.Service',
      path: DBusObjectPath('/'),
    );
    final peer = await _playerPeer(hub);
    if (peer == null) return -1;
    final created = await hub.callMethod(
      'com.lomiri.content.dbus.Service',
      'CreateExportToPeer',
      [
        DBusString(peer),
        DBusString(_appId()),
        const DBusString('videos'),
      ],
      replySignature: DBusSignature('o'),
    );
    final transfer = DBusRemoteObject(
      client,
      name: 'com.lomiri.content.dbus.Service',
      path: created.returnValues.first.asObjectPath(),
    );
    await transfer.callMethod(
      'com.lomiri.content.dbus.Transfer',
      'Charge',
      [
        DBusArray(DBusSignature('v'), [
          DBusVariant(
            DBusStruct([
              const DBusString(''),
              DBusArray.byte(const <int>[]),
              DBusString(path.split('/').last),
              DBusString(Uri.file(path).toString()),
            ]),
          ),
        ]),
      ],
    );
    final state = await transfer.callMethod(
      'com.lomiri.content.dbus.Transfer',
      'State',
      const [],
      replySignature: DBusSignature('i'),
    );
    return state.returnValues.first.asInt32();
  } finally {
    await client.close();
  }
}

String _appId() {
  final appId = Platform.environment['APP_ID'];
  if (appId != null && appId.isNotEmpty) return appId;
  return _fallbackAppId;
}

Future<String?> _playerPeer(DBusRemoteObject hub) async {
  const preferred = ['mediaplayer-app', 'lomiri-mediaplayer-app'];
  final reply = await hub.callMethod(
    'com.lomiri.content.dbus.Service',
    'KnownDestinationsForType',
    [const DBusString('videos')],
    replySignature: DBusSignature('av'),
  );
  final value = reply.returnValues.first;
  if (value is! DBusArray) return null;
  final ids = <String>[];
  for (final child in value.children) {
    final item = child is DBusVariant ? child.value : child;
    if (item is! DBusStruct || item.children.isEmpty) continue;
    final id = item.children.first;
    if (id is DBusString) ids.add(id.value);
  }
  for (final name in preferred) {
    if (ids.contains(name)) return name;
  }
  print('piliplus: system player peer missing');
  return null;
}
