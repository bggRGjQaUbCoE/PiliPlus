import 'package:PiliPlus/utils/dlna_utils.dart';
import 'package:dlna_dart/dlna.dart';
import 'package:dlna_dart/xmlParser.dart';
import 'package:flutter_test/flutter_test.dart';

DLNADevice deviceWithControlUrl(String path) => DLNADevice(
  DeviceInfo(
    'http://192.0.2.1:49152',
    'urn:schemas-upnp-org:device:MediaRenderer:1',
    'Test TV',
    [
      {
        'serviceType': 'urn:schemas-upnp-org:service:AVTransport:1',
        'serviceId': 'urn:upnp-org:serviceId:AVTransport',
        'controlURL': path,
      },
    ],
  ),
);

void main() {
  test('legacy Lebo control URL resolves before sending a cast request', () {
    final device = deviceWithControlUrl(
      '_urn:schemas-upnp-org:service:AVTransport_control',
    );
    expect(() => device.controlURL('AVTransport'), throwsFormatException);

    normalizeLegacyDlnaControlUrls(device);

    expect(
      device.controlURL('AVTransport'),
      'http://192.0.2.1:49152/_urn:schemas-upnp-org:service:AVTransport_control',
    );
    normalizeLegacyDlnaControlUrls(device);
    expect(
      device.info.serviceList.single['controlURL'],
      './_urn:schemas-upnp-org:service:AVTransport_control',
    );
  });

  test('standard control URLs retain their original resolution', () {
    for (final path in [
      '/upnp/control/AVTransport',
      'upnp/control/AVTransport',
      'http://192.0.2.2:1234/control',
      'https://example.com/control',
    ]) {
      final device = deviceWithControlUrl(path);
      final original = device.controlURL('AVTransport');
      normalizeLegacyDlnaControlUrls(device);
      expect(device.info.serviceList.single['controlURL'], path);
      expect(device.controlURL('AVTransport'), original);
    }
  });

  test('all legacy services use the port advertised by the receiver', () {
    final device = DLNADevice(
      DeviceInfo(
        'http://192.0.2.1:54321',
        'urn:schemas-upnp-org:device:MediaRenderer:1',
        'Test TV',
        [
          for (final service in ['AVTransport', 'RenderingControl'])
            {
              'serviceType': 'urn:schemas-upnp-org:service:$service:1',
              'serviceId': 'urn:upnp-org:serviceId:$service',
              'controlURL': '_urn:schemas-upnp-org:service:${service}_control',
            },
        ],
      ),
    );
    normalizeLegacyDlnaControlUrls(device);
    for (final service in ['AVTransport', 'RenderingControl']) {
      expect(
        device.controlURL(service),
        'http://192.0.2.1:54321/_urn:schemas-upnp-org:service:${service}_control',
      );
    }
  });

  test('DIDL metadata stays escaped inside the SOAP text argument', () {
    final soap = XmlText.setPlayURLXml(
      'https://example.com/video.mp4?a=1&b=2',
      title: 'Test & TV',
      type: VideoMime.mp4,
    );
    expect(soap, contains('<CurrentURIMetaData>&lt;DIDL-Lite'));
    expect(soap, isNot(contains('<CurrentURIMetaData><DIDL-Lite')));
    expect(soap, contains('Test &amp;amp; TV'));
  });
}
