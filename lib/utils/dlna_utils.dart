import 'package:dlna_dart/dlna.dart';

/// Treat legacy Lebo control URLs as relative paths, not URI schemes.
void normalizeLegacyDlnaControlUrls(DLNADevice device) {
  for (final service in device.info.serviceList) {
    final path = service['controlURL'];
    if (path is String && path.startsWith('_urn:schemas-upnp-org:service:')) {
      service['controlURL'] = './$path';
    }
  }
}
