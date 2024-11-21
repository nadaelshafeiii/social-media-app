import 'package:flutter/material.dart';
import 'package:social_media_app/features/profile/domain/profie_user.dart';

class UserTile extends StatelessWidget {
  final ProfileUser user;
  const UserTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
    );

  }
}
