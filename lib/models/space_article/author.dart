import '../model_owner.dart';
import 'nameplate.dart';
import 'official_verify.dart';
import 'pendant.dart';
import 'vip.dart';

class Author extends Owner {
  Pendant? pendant;
  OfficialVerify? officialVerify;
  Nameplate? nameplate;
  Vip? vip;

  Author.fromJson(Map<String, dynamic> json) {
    mid = json['mid'];
    name = json['name'] as String?;
    face = json['face'] as String?;
    pendant =
        json['pendant'] == null ? null : Pendant.fromJson(json['pendant']);
    officialVerify = json['official_verify'] == null
        ? null
        : OfficialVerify.fromJson(json['official_verify']);
    nameplate = json['nameplate'] == null
        ? null
        : Nameplate.fromJson(json['nameplate']);
    vip = json['vip'] == null ? null : Vip.fromJson(json['vip']);
  }
}
