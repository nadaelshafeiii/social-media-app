import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart'; // Import image picker
import 'package:social_media_app/features/auth/presentation/components/my_text_field.dart';
import 'package:social_media_app/features/profile/domain/cubit/profile_cubit.dart';
import 'package:social_media_app/features/profile/domain/cubit/profile_states.dart';
import 'package:social_media_app/features/profile/domain/profie_user.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileUser user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final bioTextController = TextEditingController();
  String? selectedImagePath; // Store selected image path

  void updateProfile() async {
    final profileCubit = context.read<ProfileCubit>();
    profileCubit.updateProfile(
      uid: widget.user.uid,
      newBio: bioTextController.text.isNotEmpty ? bioTextController.text : null,
      newProfileImagePath: selectedImagePath,
    );
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is Profileloading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return buildEditPage();
        }
      },
      listener: (context, state) {
        if (state is ProfileLoaded) {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget buildEditPage() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            onPressed: updateProfile,
            icon: const Icon(Icons.upload),
          )
        ],
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: pickImage, // Open image picker on tap
            child: CircleAvatar(
              radius: 50,
              backgroundImage: selectedImagePath != null
                  ? FileImage(File(selectedImagePath!))
                  : NetworkImage(widget.user.profileImageUrl) as ImageProvider,
              child: selectedImagePath == null
                  ? const Icon(Icons.add_a_photo)
                  : null,
            ),
          ),
          const SizedBox(height: 20),
          const Text('Bio'),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: MyTextField(
              controller: bioTextController,
              hintText: widget.user.bio,
              obsecureText: false,
            ),
          ),
        ],
      ),
    );
  }
}
