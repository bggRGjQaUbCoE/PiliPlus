class Eva3Comment {
  String? resourceUrl;
  Eva3CommentInfo? info;

  Eva3Comment({
    this.resourceUrl,
    this.info,
  });

  factory Eva3Comment.fromJson(Map<String, dynamic> json) => Eva3Comment(
    resourceUrl: json['resource_url'],
    info: json['info'] == null
        ? null
        : Eva3CommentInfo.fromJson(json['info'] as Map<String, dynamic>),
  );
}

class Eva3CommentInfo {
  String? id;
  String? linkShowText;
  Eva3CommentSource? source;

  Eva3CommentInfo({
    this.id,
    this.linkShowText,
    this.source,
  });

  factory Eva3CommentInfo.fromJson(Map<String, dynamic> json) =>
      Eva3CommentInfo(
        id: json['id'] as String?,
        linkShowText: json['link_show_text'] as String?,
        source: json['source'] == null ? null : .fromJson(json['source']),
      );
}

class Eva3CommentSource {
  String? desc;

  Eva3CommentSource({
    this.desc,
  });

  factory Eva3CommentSource.fromJson(Map<String, dynamic> json) =>
      Eva3CommentSource(
        desc: json['desc'] as String?,
      );
}
