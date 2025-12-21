class PaginationReply {
  String? nextOffset;

  PaginationReply({this.nextOffset});

  factory PaginationReply.fromJson(Map<String, dynamic> json) {
    return PaginationReply(nextOffset: json['next_offset'] as String?);
  }
}
