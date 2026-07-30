import 'package:PiliPlus/plugin/pl_player/exo_player/exo_player_controller.dart';
import 'package:PiliPlus/plugin/pl_player/exo_player/exo_subtitle_cue.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses structured Media3 cue data from the event channel', () {
    final event = ExoPlayerEvent.fromMap({
      'subtitle': 'Hello',
      'subtitleCues': [
        {
          'text': 'Hello',
          'textAlignment': 'center',
          'line': .8,
          'lineType': 0,
          'lineAnchor': 2,
          'position': .25,
          'positionAnchor': 1,
          'size': .5,
          'windowColor': 0x80000000,
          'shearDegrees': 12,
          'zIndex': 3,
          'segments': [
            {
              'text': 'Hel',
              'bold': true,
              'foregroundColor': 0xFFFF0000,
            },
            {
              'text': 'lo',
              'italic': true,
              'underline': true,
              'relativeSize': 1.5,
            },
          ],
        },
      ],
    });

    expect(event.subtitleCues, hasLength(1));
    final cue = event.subtitleCues.single;
    expect(cue.text, 'Hello');
    expect(cue.textAlignment, ExoSubtitleAlignment.center);
    expect(cue.line, .8);
    expect(cue.position, .25);
    expect(cue.size, .5);
    expect(cue.windowColor, 0x80000000);
    expect(cue.shearDegrees, 12);
    expect(cue.zIndex, 3);
    expect(cue.segments, hasLength(2));
    expect(cue.segments.first.bold, isTrue);
    expect(cue.segments.last.italic, isTrue);
  });

  test('applies span styling without discarding the shared base style', () {
    const base = TextStyle(fontSize: 20, color: Colors.white);
    const segment = ExoSubtitleSegment(
      text: 'styled',
      bold: true,
      italic: true,
      underline: true,
      foregroundColor: 0xFF00FF00,
      relativeSize: 1.25,
    );

    final style = segment.applyTo(base);

    expect(style.fontSize, 25);
    expect(style.fontWeight, FontWeight.bold);
    expect(style.fontStyle, FontStyle.italic);
    expect(style.color, const Color(0xFF00FF00));
    expect(style.decoration, TextDecoration.underline);
  });
}
