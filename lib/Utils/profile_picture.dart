import 'package:attendance_ms/Components/custom_snakbar.dart';
import 'package:attendance_ms/Components/image_picker.dart';
import 'package:attendance_ms/Providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({super.key});

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  bool isLoading = false;
  Future<void> getProfilePic(BuildContext context) async {
    try {
      setState(() {
        isLoading = true;
      });
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final picker = ImagePickerComponent();
      final image = await picker.pickImageFromGallery(context);
      if (image != null) {
        authProvider.uploadPictoFirebaseStorage(image.path);
      }
    } catch (e) {
      CustomSnakbar(
        alignment: Alignment.bottomCenter,
        type: SnackBarType.error,
        message: e.toString(),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    final profilePic =
        user?.profilePicUrl != null && user!.profilePicUrl!.isNotEmpty;
    return Stack(
      children: [
        CircleAvatar(
          radius: 80,
          backgroundColor: Colors.blue,
          backgroundImage:
              profilePic ? NetworkImage(user.profilePicUrl.toString()) : null,
          child: !profilePic
              ? const Icon(
                  Icons.person_2_outlined,
                  size: 80,
                  color: Colors.white,
                )
              : null,
        ),
        if (isLoading)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
        Positioned(
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: () {
              getProfilePic(context);
              const CustomSnakbar(
                alignment: Alignment.bottomCenter,
                type: SnackBarType.success,
                message: "Image Uploaded Successfully",
              );
            },
            child: const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 20,
              child: Icon(
                Icons.edit,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      ],
    );
  }
}