class Rights {
  int? isCooperation;

  Rights({
    this.isCooperation,
  });

  factory Rights.fromJson(Map<String, dynamic> json) => Rights(
    isCooperation: json['is_cooperation'] as int?,
  );
}
