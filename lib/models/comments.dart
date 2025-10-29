import 'dart:convert';

class CommentModel {
  final int commentId;
  final String name;
  final String username;
  final String text;
  final String date;
  final String time;

  CommentModel({
    required this.commentId,
    required this.name,
    required this.username,
    required this.text,
    required this.date,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'authorName': name,
      'authorUsername': username,
      'text': text,
      'date': date,
      'time': time,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      commentId: map['commentId'] ?? 0,
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      text: map['text'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());
  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source));
}
