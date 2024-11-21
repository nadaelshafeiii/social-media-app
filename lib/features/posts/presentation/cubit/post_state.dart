import 'package:social_media_app/features/posts/domain/entities/post.dart';

abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<Post> posts;
  PostLoaded(this.posts);
}

class PostUploaded extends PostState {}

class PostDeleted extends PostState {}

class PostError extends PostState {
  final String message;
  PostError(this.message);
}
