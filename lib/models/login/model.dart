class CaptchaDataModel {
  CaptchaDataModel({
    this.type,
    this.token,
    this.geetest,
    this.tencent,
    this.validate,
    this.seccode,
  });

  String? type;
  String? token;
  GeetestData? geetest;
  Tencent? tencent;
  String? validate;
  String? seccode;

  CaptchaDataModel.fromJson(Map<String, dynamic> json) {
    type = json["type"];
    token = json["token"];
    geetest = json["geetest"] != null
        ? GeetestData.fromJson(json["geetest"])
        : null;
    tencent = json["tencent"] != null
        ? Tencent.fromJson(json["tencent"])
        : null;
  }
}

class GeetestData {
  const GeetestData({
    required this.challenge,
    required this.gt,
  });

  final String challenge;
  final String gt;

  factory GeetestData.fromJson(Map<String, dynamic> json) =>
      GeetestData(challenge: json["challenge"], gt: json["gt"]);
}

class Tencent {
  Tencent({this.appid});
  String? appid;
  Tencent.fromJson(Map<String, dynamic> json) {
    appid = json["appid"];
  }
}
