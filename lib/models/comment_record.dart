import 'package:hive/hive.dart';

@HiveType(typeId: 20)
class CommentRecord extends HiveObject {
  @HiveField(0)
  final int type;
  @HiveField(1)
  final int oid;
  @HiveField(2)
  final String message;
  @HiveField(3)
  final int? root;
  @HiveField(4)
  final int? parent;
  @HiveField(5)
  final List<dynamic>? pictures;
  @HiveField(6)
  final bool syncToDynamic;
  @HiveField(7)
  final Map<String, int>? atNameToMid;
  @HiveField(8)
  final int? rpid;
  @HiveField(9)
  final DateTime timestamp;
  @HiveField(10)
  final int? senderMid;
  @HiveField(11)
  final String? senderFace;

  CommentRecord({
    required this.type,
    required this.oid,
    required this.message,
    this.root,
    this.parent,
    this.pictures,
    this.syncToDynamic = false,
    this.atNameToMid,
    this.rpid,
    required this.timestamp,
    this.senderMid,
    this.senderFace,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'oid': oid,
        'message': message,
        'root': root,
        'parent': parent,
        'pictures': pictures,
        'syncToDynamic': syncToDynamic,
        'atNameToMid': atNameToMid,
        'rpid': rpid,
        'timestamp': timestamp.toIso8601String(),
        'senderMid': senderMid,
        'senderFace': senderFace,
      };
}
