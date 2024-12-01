import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/Home/presentation/components/post_tile.dart';
import 'package:social_media_app/features/Home/presentation/components/profile_stats.dart';
import 'package:social_media_app/features/auth/domain/entities/app_user.dart';
import 'package:social_media_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:social_media_app/features/posts/presentation/cubit/post_cubit.dart';
import 'package:social_media_app/features/posts/presentation/cubit/post_state.dart';
import 'package:social_media_app/features/profile/domain/cubit/profile_cubit.dart';
import 'package:social_media_app/features/profile/domain/cubit/profile_states.dart';
import 'package:social_media_app/features/profile/presentation/components/bio_box.dart';
import 'package:social_media_app/features/profile/presentation/components/follow_button.dart';
import 'package:social_media_app/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Cubits
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  // Current user
  late AppUser? currentUser = authCubit.currentUser;

  //posts
  int postCount = 0;

  @override
  void initState() {
    super.initState();
    profileCubit.fetchUserProfile(widget.uid);
  }

  void followButtonPressed() {
    final profileState = profileCubit.state;
    if (profileState is! ProfileLoaded) {
      return;
    }
    final profileUser = profileState.profileUser;
    final isFollowing = profileUser.followers.contains(currentUser!.uid);

    setState(() {
      if (isFollowing) {
        profileUser.followers.remove(currentUser!.uid);
      } else {
        profileUser.followers.add(currentUser!.uid);
      }
    });

    profileCubit.toggleFollow(currentUser!.uid, widget.uid).catchError((error) {
      setState(() {
        if (isFollowing) {
          profileUser.followers.remove(currentUser!.uid);
        } else {
          profileUser.followers.add(currentUser!.uid);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isOwnPost = widget.uid == currentUser!.uid;
    return BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
      if (state is ProfileLoaded) {
        final user = state.profileUser;
        return Scaffold(
          appBar: AppBar(
            title: Center(child: Text(user.name)),
            foregroundColor: Theme.of(context).colorScheme.primary,
            actions: [
              if (isOwnPost)
                IconButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfilePage(
                                  user: user,
                                ))),
                    icon: const Icon(Icons.settings))
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  user.email,
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                const SizedBox(
                  height: 25,
                ),
                // Profile image from Firebase (using CachedNetworkImage)
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12)),
                  height: 120,
                  width: 120,
                  padding: const EdgeInsets.all(25),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl:
                          user.profileImageUrl, // Profile image URL from Firebase
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.person),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                ProfileStats(
                    followerCount: user.followers.length,
                    followingCount: user.following.length,
                    postCount: 0),
                if (!isOwnPost)
                  FollowButton(
                    isFollowing: user.followers.contains(currentUser!.uid),
                    onPressed: followButtonPressed,
                  ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Row(
                    children: [
                      Text(
                        'Bio',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                BioBox(text: user.bio),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, top: 25.0),
                  child: Row(
                    children: [
                      Text(
                        'Posts',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                ),
            
                BlocBuilder<PostCubit, PostState>(
                  builder: (context, state) {
                    if (state is PostLoaded) {
                      final userPosts = state.posts
                          .where(
                            (post) => post.userId == widget.uid,
                          )
                          .toList();
            
                      postCount = userPosts.length;
            
                      return ListView.builder(
                        itemCount: postCount,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final post = userPosts[index];
            
                          return PostTile(
                            post: post,
                            onDeltePressed: () =>
                                context.read<PostCubit>().deletePost(post.id),
                          );
                        },
                      );
                    } else if (state is PostLoading) {
                      return const CircularProgressIndicator();
                    } else {
                      return Text('No posts');
                    }
                  },
                )
              ],
            ),
          ),
        );
      } else if (state is Profileloading) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else {
        return const Center(
          child: Text('Error'),
        );
      }
    });
  }
}
