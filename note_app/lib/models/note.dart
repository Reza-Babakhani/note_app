import 'package:flutter_quill/flutter_quill.dart';
import 'package:intl/intl.dart';

class Note {
  String id;
  String title;
  Delta content;
  DateTime createdAt;
  DateTime? updatedAt;

  Note(this.id, this.title, this.content, this.createdAt, {this.updatedAt});

  factory Note.fromJson(dynamic json) {
    return Note(
      json['id'] as String,
      json['title'] as String,
      Delta.fromJson(json["content"]),
      DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
    );
  }

  @override
  String toString() {
    return toJson().toString();
  }

  String get modifiedAt {
    if (updatedAt == null) {
      return DateFormat("y MMM d - HH:mm").format(createdAt);
    } else {
      return DateFormat("y MMM d - HH:mm").format(updatedAt!);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String()
    };
  }
}
