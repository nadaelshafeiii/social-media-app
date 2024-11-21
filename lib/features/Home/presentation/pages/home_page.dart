import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/Home/presentation/components/my_drawer.dart';
import 'package:social_media_app/features/Home/presentation/components/post_tile.dart';
import 'package:social_media_app/features/posts/presentation/cubit/post_cubit.dart';
import 'package:social_media_app/features/posts/presentation/cubit/post_state.dart';
import 'package:social_media_app/features/posts/presentation/pages/upload_post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final postCubit = context.read<PostCubit>();

  @override
  void initState() {
    super.initState();
    postCubit.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
            foregroundColor: Theme.of(context).colorScheme.primary,
            actions: [
              IconButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UploadPostPage(),
                  ),
                ),
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          drawer: const MyDrawer(),
          body: BlocConsumer<PostCubit, PostState>(
            listener: (context, state) {
              if (state is PostError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              } else if (state is PostDeleted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Post deleted successfully")),
                );
              }
            },
            builder: (context, state) {
              if (state is PostLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is PostLoaded) {
                return ListView.builder(
                  itemCount: state.posts.length,
                  itemBuilder: (context, index) {
                    final post = state.posts[index];
                    Text(post.userName);
                    return PostTile(
                      post: post,
                      onDeltePressed: () {
                        postCubit.deletePost(post.id);
                      },
                    );
                  },
                );
              } else if (state is PostError) {
                return Center(child: Text(state.message));
              }
              return const Center(child: Text('No posts available.'));
            },
          )),
    );
  }
}
