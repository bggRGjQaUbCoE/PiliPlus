import 'package:material_new_shapes/material_new_shapes.dart';

abstract final class Morphs {
  static List<Morph> buildMorph(
    List<RoundedPolygon> shapes, {
    bool loop = true,
  }) {
    assert(shapes.length >= 2);
    return [
      for (var i = 0; i < shapes.length - 1; i++)
        Morph(shapes[i], shapes[i + 1]),
      if (loop) Morph(shapes[shapes.length - 1], shapes[0]),
    ];
  }

  static final loadingMorphs = buildMorph([
    MaterialShapes.softBurst,
    MaterialShapes.cookie9Sided,
    MaterialShapes.pentagon,
    MaterialShapes.pill,
    MaterialShapes.sunny,
    MaterialShapes.cookie4Sided,
    MaterialShapes.oval,
  ]);

  // static final refreshMorphs = buildMorph([
  //   MaterialShapes.softBurst,
  //   MaterialShapes.cookie9Sided,
  //   MaterialShapes.gem,
  //   MaterialShapes.flower,
  //   MaterialShapes.sunny,
  //   MaterialShapes.cookie4Sided,
  //   MaterialShapes.oval,
  //   MaterialShapes.cookie12Sided,
  // ]);

  // static final manualMorph = Morph(
  //   MaterialShapes.circle,
  //   MaterialShapes.softBurst,
  // );
}
