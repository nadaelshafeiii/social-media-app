import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/features/posts/domain/entities/comments.dart';
import 'package:social_media_app/features/posts/domain/entities/post.dart';
import 'package:social_media_app/features/posts/domain/repos/post_repo.dart';

class FirebasePostRepo implements PostRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> uploadPost(Post post) async {
    try {
      await _firestore.collection('posts').doc(post.id).set(post.toJson());
    } catch (e) {
      throw Exception('Error uploading post: $e');
    }
  }

  @override
  Future<List<Post>> fetchPosts() async {
    try {
      final snapshot = await _firestore
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .get();
      return snapshot.docs.map((doc) {
        return Post.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Error fetching posts: $e');
    }
  }

  @override
  Future<List<Post>> fetchPostsByUserId(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('posts')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) => Post.fromJson(doc.data())).toList();
    } catch (e) {
      throw Exception('Error fetching posts for user $userId: $e');
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    await _firestore.collection('posts').doc(postId).delete();
  }

  @override
  Future<void> toggleLifePost(String postId, String userId) async {
    try {
      if (postId.isEmpty) {
        throw Exception("Invalid post ID");
      }

      final snapshot = await _firestore.collection('posts').doc(postId).get();

      if (snapshot.exists) {
        final post = Post.fromJson(snapshot.data() as Map<String, dynamic>);
        final hasLiked = post.likes.contains(userId);

        if (hasLiked) {
          post.likes.remove(userId);
        } else {
          post.likes.add(userId);
        }

        await _firestore.collection('posts').doc(postId).update({
          'likes': post.likes,
        });
      } else {
        throw Exception('Post not found');
      }
    } catch (e) {
      throw Exception('Error toggling likes: $e');
    }
  }

@override
Future<void> addComment(String postId, Comment comment) async {
  try {
    if (postId.isEmpty) {
      throw Exception("Invalid post ID");
    }

    final snapshot = await _firestore.collection('posts').doc(postId).get();
    
    if (snapshot.exists) {
      final post = Post.fromJson(snapshot.data() as Map<String, dynamic>);
      post.comments.add(comment);
      
      await _firestore.collection('posts').doc(postId).update({
        'comments': post.comments.map((comment) => comment.toJson()).toList(),
      });
    } else {
      throw Exception('Post not found');
    }
  } catch (e) {
    throw Exception('Error adding comment: $e');
  }
}


  @override
  Future<void> deleteComment(String postId, String commentId) async {
    try {
      final snapshot = await _firestore.collection('posts').doc(postId).get();
      if (snapshot.exists) {
        final post = Post.fromJson(snapshot.data() as Map<String, dynamic>);
        post.comments.removeWhere((comment) => comment.id == commentId,);
        await _firestore.doc(postId).update({
          'comments': post.comments
              .map(
                (comment) => comment.toJson(),
              )
              .toList(),
        });
      } else {
        throw Exception('');
      }
    } catch (e) {
      throw Exception();

    }
  }
}
