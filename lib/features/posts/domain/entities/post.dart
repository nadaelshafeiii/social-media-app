import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/features/posts/domain/entities/comments.dart';

class Post {
  final String id;
  late final String userName;
  final String userId;
  final String content;
  final String imageUrl;
  final Timestamp timestamp;
  final List<String> likes;
  final List<Comment> comments;

  Post(
      {required this.userName,
      required this.id,
      required this.userId,
      required this.content,
      required this.imageUrl,
      required this.timestamp,
      required this.likes,
      required this.comments});

  Post copyWith({String? imageUrl}) {
    return Post(
        userName: userName,
        id: id,
        userId: userId,
        content: content,
        imageUrl: imageUrl ?? this.imageUrl,
        timestamp: timestamp,
        likes: likes,
        comments: comments);
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'imageUrl': imageUrl,
      'timestamp': timestamp,
      'name': userName,
      'likes': likes,
      'comments': comments.map(
        (comment) => comment.toJson()).toList()
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    final List<Comment> comments = (json['comments']as List<dynamic>?)?.map((commentJson)=>Comment.fromJson(commentJson)).toList()??[];

    return Post(
      userName: json['name'] ?? 'Unknown User',
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      timestamp: json['timestamp'],
      likes: List<String>.from(json['likes'] ?? []),
      comments: comments 
    );
  }
}
