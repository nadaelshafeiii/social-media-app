import 'package:bloc/bloc.dart';
import 'package:social_media_app/features/posts/domain/entities/comments.dart';
import 'package:social_media_app/features/posts/domain/entities/post.dart';
import 'package:social_media_app/features/posts/domain/repos/post_repo.dart';
import 'package:social_media_app/features/posts/presentation/cubit/post_state.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepo postRepo;

  PostCubit({
    required this.postRepo,
  }) : super(PostInitial());

  Future<void> uploadPost(Post post) async {
    try {
      emit(PostLoading());
      await postRepo.uploadPost(post);
      emit(PostUploaded());
    } catch (e) {
      emit(PostError('Failed to upload post: $e'));
    }
  }

  Future<void> fetchPosts() async {
    try {
      emit(PostLoading());
      final posts = await postRepo.fetchPosts();
      emit(PostLoaded(posts));
    } catch (e) {
      emit(PostError('Failed to fetch posts: $e'));
    }
  }

  Future<void> fetchPostsByUserId(String userId) async {
    try {
      emit(PostLoading());
      final posts = await postRepo.fetchPostsByUserId(userId);
      emit(PostLoaded(posts));
    } catch (e) {
      emit(PostError('Failed to fetch posts for user $userId: $e'));
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await postRepo.deletePost(postId);
      fetchPosts();
    } catch (e) {}
  }

  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      if (postId.isEmpty) {
        throw Exception("Invalid post ID");
      }

      await postRepo.toggleLifePost(postId, userId);
    } catch (e) {
      emit(PostError('Failed to toggle likes: $e'));
    }
  }

  Future<void> addComment(String postId, Comment comment) async {
    try {
      await postRepo.addComment(postId, comment);
      await fetchPosts();
    } catch (e) {
      emit(PostError('$e'));
    }
  }

    Future<void> deleteComment(String postId, String commentId) async {
    try {
      await postRepo.deleteComment(postId, commentId);
      await fetchPosts();
    } catch (e) {
      emit(PostError('$e'));
    }
  }
}
