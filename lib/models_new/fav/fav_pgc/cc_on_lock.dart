class CcOnLock {
  String? typeUrl;

  CcOnLock({this.typeUrl});

  factory CcOnLock.fromJson(Map<String, dynamic> json) =>
      CcOnLock(typeUrl: json['type_url'] as String?);
}
