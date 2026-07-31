import 'dart:typed_data';
import 'dart:ui' as ui;

Future<ui.Image> decodeCapturedFrame(Uint8List bytes) async {
  final codec = await ui.instantiateImageCodec(bytes);
  try {
    return (await codec.getNextFrame()).image;
  } finally {
    codec.dispose();
  }
}
