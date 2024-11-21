import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:social_media_app/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social_media_app/features/posts/domain/entities/comments.dart';
import 'package:social_media_app/features/posts/domain/entities/post.dart';
import 'package:social_media_app/features/posts/presentation/cubit/post_cubit.dart';
import 'package:social_media_app/features/posts/presentation/cubit/post_state.dart';
import 'package:social_media_app/features/profile/domain/cubit/profile_cubit.dart';
import 'package:social_media_app/features/profile/domain/profie_user.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final void Function()? onDeltePressed;

  const PostTile({super.key, required this.post, required this.onDeltePressed});

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfileCubit>();
  final commentTextController = TextEditingController();
  bool isOwnPost = false;
  bool showComments = false; 
  AppUser? currentUser;
  ProfileUser? postUser;

  void getCurrentUser() async {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.post.userId == currentUser!.uid);
  }

  Future<void> fetchPostUser() async {
    final fetchedUser = await profileCubit.getUserProfile(widget.post.userId);
    if (fetchedUser != null) {
      setState(() {
        postUser = fetchedUser;
      });
    }
  }

  void toggleLikePost() {
    final isLiked = widget.post.likes.contains(currentUser!.uid);

    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currentUser!.uid);
      } else {
        widget.post.likes.add(currentUser!.uid);
      }
    });
    postCubit.toggleLikePost(widget.post.id, widget.post.userId);
  }

  void openNewCommentBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add a new comment'),
        content: TextField(
            controller: commentTextController,
            decoration: const InputDecoration(hintText: 'Add a comment'),
            obscureText: false),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                addComment();
                Navigator.of(context).pop();
              },
              child: const Text('Save')),
        ],
      ),
    );
  }

  void addComment() {
    final newComment = Comment(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        postId: widget.post.id,
        userId: currentUser!.uid,
        userName: currentUser!.name, 
        text: commentTextController.text,
        timestamp: DateTime.now());

    if (commentTextController.text.isNotEmpty) {
      postCubit.addComment(widget.post.id, newComment);
      commentTextController.clear();
    }
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd ').format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    fetchPostUser();
  }

  @override
  void dispose() {
    commentTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: const Border(
          top: BorderSide(color: Colors.grey, width: 1.0), 
          bottom: BorderSide(color: Colors.grey, width: 1.0), 
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                postUser?.profileImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: postUser!.profileImageUrl,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.person),
                        imageBuilder: (context, imageProvider) => Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                      )
                    : const Icon(Icons.person),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    widget.post.userName,
                    style: const TextStyle(
                      color: (Colors.black45),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                if (isOwnPost)
                  GestureDetector(
                    onTap: widget.onDeltePressed,
                    child: Icon(Icons.delete,
                        color: Theme.of(context).colorScheme.primary),
                  )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              widget.post.content,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 25),
            ),
          ),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                  onTap: toggleLikePost,
                  child: Icon(
                    widget.post.likes.contains(currentUser!.uid)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: widget.post.likes.contains(currentUser!.uid)
                        ? Colors.red
                        : Theme.of(context).colorScheme.primary,
                  )),
              Text(widget.post.likes.length.toString()),
              const SizedBox(
                width: 15,
              ),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      showComments = !showComments; 
                    });
                  },
                  child: const Icon(Icons.comment)),
              Text(widget.post.comments.length.toString()),
              const Spacer(),
              Text(formatTimestamp(widget.post.timestamp))
            ],
          ),
          if (showComments) ...[
            BlocBuilder<PostCubit, PostState>(
              builder: (context, state) {
                if (state is PostLoaded) {
                  final post = state.posts.firstWhere(
                    (post) => post.id == widget.post.id,
                  );
                  return ListView.builder(
                    itemCount: post.comments.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final comment = post.comments[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Text(
                              comment.userName,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 10),
                            Expanded(child: Text(comment.text)),
                          ],
                        ),
                      );
                    },
                  );
                }
                if (state is PostLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PostError) {
                  return Text(state.message);
                } else {
                  return const Center(child: Text('No comments yet.'));
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentTextController,
                      decoration: const InputDecoration(
                        hintText: 'Write a comment...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: addComment,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
