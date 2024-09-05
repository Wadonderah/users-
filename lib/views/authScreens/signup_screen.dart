import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../global/global_instances.dart';
import '../widgets/custom_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  XFile? imageFile;
  ImagePicker picker = ImagePicker();

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  pickImageFromGallery() async {
    imageFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      // Updates the UI when the image is picked
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Text(
            'Signup',
            style: TextStyle(
              letterSpacing: 3,
              fontSize: 30,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () {
              pickImageFromGallery();
            },
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.20,
              backgroundColor: Colors.white,
              backgroundImage:
                  imageFile == null ? null : FileImage(File(imageFile!.path)),
              child: imageFile == null
                  ? Icon(
                      Icons.add_photo_alternate,
                      size: MediaQuery.of(context).size.width * 0.20,
                      color: Colors.grey.shade400,
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 20),
          Form(
            key: formkey,
            child: Column(
              children: [
                CustomTextField(
                  textEditingController: nameController,
                  icon: Icons.person,
                  hintString: 'Name',
                  isObscure: false,
                  isEnabled: true,
                ),
                CustomTextField(
                  textEditingController: emailController,
                  icon: Icons.email,
                  hintString: 'Email',
                  isObscure: false,
                  isEnabled: true,
                ),
                CustomTextField(
                  textEditingController: passwordController,
                  icon: Icons.lock,
                  hintString: 'Password',
                  isObscure: true,
                  isEnabled: true,
                ),
                CustomTextField(
                  textEditingController: confirmPasswordController,
                  icon: Icons.lock,
                  hintString: 'Confirm Password',
                  isObscure: true,
                  isEnabled: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await authViewModel.validateSignUpForm(
                      image: imageFile,
                      name: nameController.text.trim(),
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                      confirmPassword: confirmPasswordController.text.trim(),
                      context: context,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Signup',
                    style: TextStyle(
                      letterSpacing: 0,
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
