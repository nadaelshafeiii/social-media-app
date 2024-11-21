import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/profile/presentation/components/user_tile.dart';
import 'package:social_media_app/features/profile/presentation/pages/profile_page.dart';
import 'package:social_media_app/features/search/presentation/cubits/search_cubit.dart';
import 'package:social_media_app/features/search/presentation/cubits/search_states.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  late final searchCubit = context.read<SearchCubit>();

  void onSearchChanged() {
    final query = searchController.text;
    searchCubit.searchUsers(query);
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
              hintText: 'Search users..',
              hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary)),
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchStates>(builder: (context, state) {
        if (state is SearchLoaded) {
          if (state.users.isEmpty) {
            return const Center(
              child: Text('No users found'),
            );
          }
          return ListView.builder(
            itemCount: state.users.length,
            itemBuilder: (context, index) {
              final user = state.users[index];
              return Column(
                children: [
                  UserTile(user: user!),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to ProfilePage when "View" button is pressed
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(uid: user.uid), // Pass user to ProfilePage
                        ),
                      );
                    },
                    child: Text('View'),
                  ),
                ],
              );
            },
          );
        } else if (state is SearchLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is SearchError) {
          return Center(
            child: Text(state.message),
          );
        }
        return const Center(
          child: Text('Start searching for users...'),
        );
      }),
    );
  }
}
