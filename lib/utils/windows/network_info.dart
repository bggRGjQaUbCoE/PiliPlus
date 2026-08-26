import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

final class WindowsNetworkInfo {
  const WindowsNetworkInfo({this.rssi, this.wifiMbps, this.wiredMbps});

  final int? rssi;
  final int? wifiMbps;
  final int? wiredMbps;
}

abstract final class WindowsNetworkInfoReader {
  static WindowsNetworkInfo read() => WindowsNetworkInfo(
    rssi: _readRssi(),
    wifiMbps: _readLinkSpeed(71),
    wiredMbps: _readLinkSpeed(6),
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

  static int? _readLinkSpeed(int interfaceType) {
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

      int? speed;
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
            final bitsPerSecond = item.ReceiveLinkSpeed < item.TransmitLinkSpeed
                ? item.ReceiveLinkSpeed
                : item.TransmitLinkSpeed;
            speed = bitsPerSecond <= 0
                ? null
                : (bitsPerSecond / 1000000).round();
            metric = itemMetric;
          }
        }
        adapter = item.Next;
      }
      return speed;
    } finally {
      if (buffer != nullptr) malloc.free(buffer);
      calloc.free(size);
    }
  }
}
