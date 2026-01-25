import 'package:PiliPlus/models/common/enum_with_label.dart';

enum AudioOutput implements EnumWithLabel {
  aaudio('AAudio'),
  opensles('OpenSL ES'),
  audiotrack('AudioTrack')
  ;

  @override
  final String label;
  const AudioOutput(this.label);
}
