import 'dart:convert';
import 'package:socialfeedplus_parvathi/models/comments.dart';

class PostModel {
  final int postId;
  final String? profileImage;
  final String name;
  final String username;
  final String date;
  final String time;
  final double likes;
  final String caption;
  final int commentCount;
  final String? imagePath;
  final bool isLiked;
  final List<CommentModel> comments;

  PostModel({
    this.profileImage,
    required this.name,
    required this.username,
    required this.date,
    required this.time,
    required this.likes,
    required this.caption,
    required this.commentCount,
    required this.postId,
    required this.imagePath,
    this.isLiked = false,
    this.comments = const [],
  });

  /// ✅ Convert PostModel → Map
  Map<String, dynamic> toMap() {
    return {
      'profileImage': profileImage,
      'name': name,
      'username': username,
      'date': date,
      'time': time,
      'likes': likes,
      'caption': caption,
      'imagePath': imagePath,
      'commentCount': commentCount,
      'postId': postId,
      'isLiked': isLiked,
      'comments': comments.map((c) => c.toMap()).toList(), // ✅ include comments
    };
  }

  /// ✅ Convert Map → PostModel
  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      profileImage: map['profileImage'],
      name: map['name'] ?? '',
      username: map['username'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      likes: (map['likes'] ?? 0).toDouble(),
      caption: map['caption'] ?? '',
      imagePath: map['imagePath'] ?? '',
      commentCount: (map['commentCount'] ?? 0).toInt(),
      postId: (map['postId'] ?? 0).toInt(),
      isLiked: map['isLiked'] ?? false,
      comments: (map['comments'] != null)
          ? List<CommentModel>.from(
              (map['comments'] as List)
                  .map((x) => CommentModel.fromMap(x)))
          : [], // ✅ safely decode comments
    );
  }

  /// ✅ Encode / Decode to JSON
  String toJson() => json.encode(toMap());
  factory PostModel.fromJson(String source) =>
      PostModel.fromMap(json.decode(source));

  /// ✅ Copy with updates
  PostModel copyWith({
    int? postId,
    String? profileImage,
    String? name,
    String? username,
    String? date,
    String? time,
    double? likes,
    String? caption,
    int? commentCount,
    String? imagePath,
    bool? isLiked,
    List<CommentModel>? comments,
  }) {
    return PostModel(
      postId: postId ?? this.postId,
      profileImage: profileImage ?? this.profileImage,
      name: name ?? this.name,
      username: username ?? this.username,
      date: date ?? this.date,
      time: time ?? this.time,
      likes: likes ?? this.likes,
      caption: caption ?? this.caption,
      commentCount: commentCount ?? this.commentCount,
      imagePath: imagePath ?? this.imagePath,
      isLiked: isLiked ?? this.isLiked,
      comments: comments ?? this.comments,
    );
  }

  @override
  String toString() {
    return 'PostModel(name: $name, username: $username, likes: $likes, comments: ${comments.length})';
  }
}
