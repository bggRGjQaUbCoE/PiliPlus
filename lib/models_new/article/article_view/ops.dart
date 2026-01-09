class ArticleOps {
  dynamic insert;
  Attributes? attributes;

  ArticleOps({this.insert, this.attributes});

  ArticleOps.fromJson(Map<String, dynamic> json) {
    if (json['insert'] is Map) {
      insert = Insert.fromJson(json['insert']);
    } else {
      insert = json['insert'];
    }
    attributes = json['attributes'] == null
        ? null
        : Attributes.fromJson(json['attributes'] as Map<String, dynamic>);
  }
}

class Attributes {
  String? clazz;

  Attributes({this.clazz});

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
    clazz: json['class'] as String?,
  );
}

class Insert {
  InsertCard? card;

  Insert({
    this.card,
  });

  Insert.fromJson(Map<String, dynamic> json) {
    if (json['article-card'] != null) {
      card = InsertCard.fromJson(json['article-card']);
      return;
    }

    if (json['live-card'] != null) {
      card = InsertCard.fromJson(json['live-card']);
      return;
    }

    if (json['goods-card'] != null) {
      card = InsertCard.fromJson(json['goods-card']);
      return;
    }

    if (json['video-card'] != null) {
      card = InsertCard.fromJson(json['video-card']);
      return;
    }

    if (json['mall-card'] != null) {
      card = InsertCard.fromJson(json['mall-card']);
      return;
    }

    if (json['vote-card'] != null) {
      card = InsertCard.fromJson(json['vote-card']);
      return;
    }
  }
}

class InsertCard {
  dynamic tid;
  String? id;
  dynamic alt;
  String? url;
  double? width;
  double? height;
  num? size;
  String? status;

  InsertCard({
    this.tid,
    this.id,
    this.alt,
    this.url,
    this.width,
    this.height,
    this.size,
    this.status,
  });

  InsertCard.fromJson(Map<String, dynamic> json) {
    tid = json['tid'];
    id = json['id'] == '' ? null : json['id'];
    alt = json['alt'];
    url = json['url'];
    width = (json['width'] as num?)?.toDouble();
    height = (json['height'] as num?)?.toDouble();
    size = json['size'];
    status = json['status'];
  }
}
