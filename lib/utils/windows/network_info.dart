import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

final class WindowsNetworkInfo {
  const WindowsNetworkInfo({this.rssi, this.wifi, this.wired});

  final int? rssi;
  final WindowsLinkInfo? wifi;
  final WindowsLinkInfo? wired;

  int? get wifiMbps => wifi?.minimumSpeedMbps;
  int? get wiredMbps => wired?.minimumSpeedMbps;
}

final class WindowsLinkInfo {
  const WindowsLinkInfo({
    required this.name,
    required this.description,
    required this.receiveSpeedMbps,
    required this.transmitSpeedMbps,
    required this.metric,
    required this.mtu,
  });

  final String? name;
  final String? description;
  final int? receiveSpeedMbps;
  final int? transmitSpeedMbps;
  final int metric;
  final int mtu;

  int? get minimumSpeedMbps => switch ((
    receiveSpeedMbps,
    transmitSpeedMbps,
  )) {
    (final int receive, final int transmit) =>
      receive < transmit ? receive : transmit,
    (final int receive, null) => receive,
    (null, final int transmit) => transmit,
    _ => null,
  };
}

abstract final class WindowsNetworkInfoReader {
  static WindowsNetworkInfo read() => WindowsNetworkInfo(
    rssi: _readRssi(),
    wifi: _readLinkInfo(71),
    wired: _readLinkInfo(6),
  );

  static int? _readRssi() {
    return using((arena) {
      final negotiatedVersion = arena<Uint32>();
      final clientHandle = arena<Pointer>();
      if (WlanOpenHandle(2, negotiatedVersion, clientHandle) != 0 ||
          clientHandle.value == nullptr) {
        return null;
      }

      final handle = HANDLE(clientHandle.value);
      Pointer<WLAN_INTERFACE_INFO_LIST>? interfaces;
      try {
        final interfaceList = arena<Pointer<WLAN_INTERFACE_INFO_LIST>>();
        if (WlanEnumInterfaces(handle, interfaceList) != 0 ||
            interfaceList.value == nullptr) {
          return null;
        }
        interfaces = interfaceList.value;
        final list = interfaces.ref;
        for (var index = 0; index < list.dwNumberOfItems; index++) {
          final info = list.InterfaceInfo[index];
          if (info.isState != wlan_interface_state_connected) continue;

          final dataSize = arena<Uint32>();
          final data = arena<Pointer>();
          final guid = info.InterfaceGuid.toNative(allocator: arena);
          if (WlanQueryInterface(
                handle,
                guid,
                wlan_intf_opcode_rssi,
                dataSize,
                data,
                null,
              ) ==
              0) {
            if (data.value == nullptr) continue;
            try {
              return data.value.cast<Int32>().value;
            } finally {
              WlanFreeMemory(data.value);
            }
          }
        }
        return null;
      } finally {
        if (interfaces != null) WlanFreeMemory(interfaces);
        WlanCloseHandle(handle);
      }
    });
  }

  static WindowsLinkInfo? _readLinkInfo(int interfaceType) {
    final size = calloc<Uint32>();
    Pointer<IP_ADAPTER_ADDRESSES_LH> buffer = nullptr;
    try {
      var result = GetAdaptersAddresses(
        AF_UNSPEC,
        GAA_FLAG_INCLUDE_GATEWAYS,
        null,
        size,
      );
      if (result != ERROR_BUFFER_OVERFLOW || size.value == 0) return null;

      buffer = malloc<Uint8>(size.value).cast<IP_ADAPTER_ADDRESSES_LH>();
      result = GetAdaptersAddresses(
        AF_UNSPEC,
        GAA_FLAG_INCLUDE_GATEWAYS,
        buffer,
        size,
      );
      if (result != NO_ERROR) return null;

      WindowsLinkInfo? resultInfo;
      int? metric;
      var adapter = buffer;
      while (adapter != nullptr) {
        final item = adapter.ref;
        if (item.IfType == interfaceType &&
            item.OperStatus == IfOperStatusUp &&
            item.FirstGatewayAddress != nullptr) {
          final itemMetric = item.Ipv4Metric == 0
              ? item.Ipv6Metric
              : item.Ipv6Metric == 0
              ? item.Ipv4Metric
              : item.Ipv4Metric < item.Ipv6Metric
              ? item.Ipv4Metric
              : item.Ipv6Metric;
          if (metric == null || itemMetric < metric) {
            final receive = item.ReceiveLinkSpeed <= 0
                ? null
                : (item.ReceiveLinkSpeed / 1000000).round();
            final transmit = item.TransmitLinkSpeed <= 0
                ? null
                : (item.TransmitLinkSpeed / 1000000).round();
            resultInfo = WindowsLinkInfo(
              name: item.FriendlyName == nullptr
                  ? null
                  : item.FriendlyName.toDartString(),
              description: item.Description == nullptr
                  ? null
                  : item.Description.toDartString(),
              receiveSpeedMbps: receive,
              transmitSpeedMbps: transmit,
              metric: itemMetric,
              mtu: item.Mtu,
            );
            metric = itemMetric;
          }
        }
        adapter = item.Next;
      }
      return resultInfo;
    } finally {
      if (buffer != nullptr) malloc.free(buffer);
      calloc.free(size);
    }
  }
}
