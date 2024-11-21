import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FollowButton extends StatelessWidget {

  final void Function()? onPressed;
  final bool isFollowing;
  const FollowButton({super.key , 
  required this.isFollowing,
  required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: MaterialButton(
          onPressed: onPressed,
          padding: EdgeInsets.symmetric(horizontal:  80),
          color: isFollowing ? Theme.of(context).colorScheme.primary : Colors.blue,
          child: Text(isFollowing ? 'Unfollow' : 'Follow' ,
          style: TextStyle(color: Theme.of(context).colorScheme.secondary,
          fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }
}