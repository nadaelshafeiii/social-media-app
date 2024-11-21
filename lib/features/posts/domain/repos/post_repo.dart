import 'package:social_media_app/features/posts/domain/entities/comments.dart';
import 'package:social_media_app/features/posts/domain/entities/post.dart';

abstract class PostRepo {
  Future<void> uploadPost(Post post);
  Future<List<Post>> fetchPosts();
  Future<void> deletePost(String postId);
  Future<List<Post>> fetchPostsByUserId(String userId);
  Future<void> toggleLifePost(String postId, String userId);
  Future<void> addComment(String postId, Comment comment);
  Future<void> deleteComment(String postId, String commentId);


}
