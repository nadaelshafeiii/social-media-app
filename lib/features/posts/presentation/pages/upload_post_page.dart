
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/features/Home/presentation/pages/home_page.dart';
import 'package:social_media_app/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social_media_app/features/posts/domain/entities/post.dart';
import 'package:social_media_app/features/posts/presentation/cubit/post_cubit.dart';
import 'package:social_media_app/features/posts/presentation/cubit/post_state.dart';

class UploadPostPage extends StatefulWidget {
  const UploadPostPage({super.key});

  @override
  State<UploadPostPage> createState() => _UploadPostPageState();
}

class _UploadPostPageState extends State<UploadPostPage> {
  final TextEditingController _contentController = TextEditingController();
  late final PostCubit _postCubit;
  String _imageUrl = '';
  AppUser? currentUser;

@override
void initState() {
  super.initState();
  _postCubit = context.read<PostCubit>(); 
  getCurrentUser();
}

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void getCurrentUser() async {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  void _submitPost() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to post')),
      );
      return;
    }

    final post = Post(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      userId: user.uid,
      content: _contentController.text,
      imageUrl: _imageUrl,
      timestamp: Timestamp.now(),
      userName: currentUser!.name,
      likes: [],
      comments: []
    );

    _postCubit.uploadPost(post);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Post Content',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitPost,
              child: const Text('Post'),
            ),
            BlocListener<PostCubit, PostState>(
              listener: (context, state) {
                if (state is PostUploaded) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: const Text('Post uploaded successfully!')),
                  );
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ));
                } else if (state is PostError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
