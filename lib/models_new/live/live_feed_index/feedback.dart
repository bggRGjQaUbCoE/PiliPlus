class Feedback {
  Feedback({
    this.title,
    this.subtitle,
    this.type,
    this.reasons,
  });

  final String? title;
  final String? subtitle;
  final String? type;
  final List<Reason>? reasons;

  factory Feedback.fromJson(Map<String, dynamic> json) {
    return Feedback(
      title: json['title'],
      subtitle: json['subtitle'],
      type: json['type'],
      reasons: (json['reasons'] as List?)
          ?.map((x) => Reason.fromJson(x))
          .toList(),
    );
  }
}

class Reason {
  Reason({
    this.id,
    this.name,
    this.idType,
    this.reasonId,
  });

  final int? id;
  final String? name;
  final String? idType;
  final int? reasonId;

  factory Reason.fromJson(Map<String, dynamic> json) {
    return Reason(
      id: json['id'],
      name: json['name'],
      idType: json['id_type'],
      reasonId: json['reason_id'],
    );
  }
}
