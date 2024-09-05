// ignore_for_file: avoid_print

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:shared_preferences/shared_preferences.dart';
import '../global/global_instances.dart';
import '../views/mainScreens/home_screen.dart';

class AuthViewModel {
  Future<void> validateSignUpForm(
      {XFile? image,
      required String name,
      required String email,
      required String password,
      required String confirmPassword,
      required BuildContext context}) async {
    // Check if image is null
    if (image == null) {
      commonViewModel.showSnackBar("Please pick an image", context);
      return;
    }

    // Check if passwords match
    if (password != confirmPassword) {
      commonViewModel.showSnackBar("Passwords don't match", context);
      return;
    }

    // Check if all fields are filled
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      commonViewModel.showSnackBar("Please fill all the fields", context);
      return;
    }

    // Create user
    User? currentFirebaseUser =
        await createUserInFirebaseAuth(email, password, context);

    if (currentFirebaseUser != null) {
      String downloadurl = await uploadImageToFirebase(image);

      await saveDataToFirestore(
          currentFirebaseUser,
          name,
          email,
          password,
          downloadurl,
          // ignore: use_build_context_synchronously
          context);

      Navigator.pushAndRemoveUntil(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false,
      );
    }

    // ignore: use_build_context_synchronously
    commonViewModel.showSnackBar("Account created successfully", context);
  }

  Future<void> loginUser(
      String email, String password, BuildContext context) async {
    try {
      // ignore: unused_local_variable
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Show success message
      // ignore: use_build_context_synchronously
      commonViewModel.showSnackBar("Sign in successful", context);

      Navigator.pushAndRemoveUntil(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false,
      );
    } catch (error) {
      // ignore: use_build_context_synchronously
      commonViewModel.showSnackBar(error.toString(), context);
    }
  }

  Future<User?> createUserInFirebaseAuth(
      String email, String password, BuildContext context) async {
    User? currentFirebaseUser;

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      currentFirebaseUser = userCredential.user;
    } catch (error) {
      // ignore: use_build_context_synchronously
      commonViewModel.showSnackBar(error.toString(), context);
    }

    return currentFirebaseUser;
  }

  Future<String> uploadImageToFirebase(XFile? imageXFile) async {
    String downloadurl = "";
    String fileName = DateTime.now().microsecondsSinceEpoch.toString();
    firebase_storage.Reference storageRef = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child("UsersImages")
        .child(fileName);

    try {
      firebase_storage.UploadTask uploadTask =
          storageRef.putFile(File(imageXFile!.path));

      firebase_storage.TaskSnapshot taskSnapshot =
          await uploadTask.whenComplete(() => {});

      downloadurl = await taskSnapshot.ref.getDownloadURL();
    } catch (error) {
      print('Error uploading image: $error');
    }

    return downloadurl;
  }

  Future<void> saveDataToFirestore(
      User? currentFirebaseUser,
      String name,
      String email,
      String password,
      String downloadurl,
      BuildContext context) async {
    if (currentFirebaseUser != null) {
      try {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(currentFirebaseUser.uid)
            .set({
          "sellerUID": currentFirebaseUser.uid,
          "sellerEmail": email,
          "sellerName": name,
          "image": downloadurl,
          "status": "approved",
          "userCart": ["garbageValue"],
        });

        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        await sharedPreferences.setString("uid", currentFirebaseUser.uid);
        await sharedPreferences.setString("email", email);
        await sharedPreferences.setString("name", name);
        await sharedPreferences.setStringList("userCart", ["garbageValue"]);
      } catch (error) {
        // ignore: use_build_context_synchronously
        commonViewModel.showSnackBar("Error saving data: $error", context);
      }
    }
  }

  Future<void> validateSignInForm(
      String email, String password, BuildContext context) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      commonViewModel.showSnackBar("Checking credentials....", context);

      try {
        // Authenticate the user with Firebase
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        // Get the user ID
        String uid = userCredential.user?.uid ?? '';

        // Retrieve user data from Firestore
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance.collection('Users').doc(uid).get();

        // Check if the user is approved
        if (userDoc.exists && userDoc['status'] == 'approved') {
          // Show success message
          // ignore: use_build_context_synchronously
          commonViewModel.showSnackBar("Sign in successful", context);

          // Ask the user if they want to stay logged in
          // ignore: use_build_context_synchronously
          bool stayLoggedIn = await showStayLoggedInDialog(context);

          if (stayLoggedIn) {
            // Save the user's session using SharedPreferences or a similar method
            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
            await sharedPreferences.setBool('stayLoggedIn', true);
          } else {
            // Remove any stored session
            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
            await sharedPreferences.setBool('stayLoggedIn', false);
          }

          // Navigate to the home screen
          Navigator.pushAndRemoveUntil(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false,
          );
        } else {
          // Show error if user is not approved
          // ignore: use_build_context_synchronously
          commonViewModel.showSnackBar(
              // ignore: use_build_context_synchronously
              "Your account is not approved.",
              // ignore: use_build_context_synchronously
              context);
          FirebaseAuth.instance.signOut(); // Sign out the user
        }
      } catch (error) {
        // Handle any errors
        // ignore: use_build_context_synchronously
        commonViewModel.showSnackBar(error.toString(), context);
      }
    } else {
      commonViewModel.showSnackBar("Password and Email required", context);
      return;
    }
  }

  Future<bool> showStayLoggedInDialog(BuildContext context) async {
    bool stayLoggedIn = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Stay Logged In"),
          content: const Text("Do you want to stay logged in?"),
          actions: [
            TextButton(
              onPressed: () {
                stayLoggedIn = false;
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                stayLoggedIn = true;
                Navigator.of(context).pop();
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
    return stayLoggedIn;
  }
}
