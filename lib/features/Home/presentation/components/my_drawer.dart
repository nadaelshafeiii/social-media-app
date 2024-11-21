import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/Home/presentation/components/my_drawer_tile.dart';
import 'package:social_media_app/features/profile/presentation/pages/profile_page.dart';
import 'package:social_media_app/features/search/presentation/pages/search_page.dart';
import '../../../auth/presentation/cubits/auth_cubit.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              Divider(
                color: Theme.of(context).colorScheme.secondary,
              ),
              //home
              MyDrawerTile(
                  icon: Icons.home,
                  onTap: () => Navigator.of(context).pop(),
                  title: 'H O M E'),
              //profile
              MyDrawerTile(
                  icon: Icons.person,
                  onTap: () {
                    Navigator.of(context).pop();

                    final user = context.read<AuthCubit>().currentUser;
                    String? uid =user!.uid;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(uid: uid,),
                        ));
                  },
                  title: 'P R O F I L E'),

              //search
              MyDrawerTile(
                  icon: Icons.search, onTap: () => Navigator.push(context,MaterialPageRoute(builder: (context) => SearchPage(),)), title: 'S E A R C H '),

              //logout
              MyDrawerTile(
                  icon: Icons.logout,
                  onTap: () {
                    context.read<AuthCubit>().logout();
                  },
                  title: 'L O G O U T'),
            ],
          ),
        ),
      ),
    );
  }
}
