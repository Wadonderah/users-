import 'package:flutter/material.dart';

import '../mainScreens/home_screen.dart';

// ignore: must_be_immutable
class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  String? titleMsg;
  bool showBackButton;
  PreferredSizeWidget? bottom;

  MyAppbar(
      {super.key,
      required,
      this.titleMsg,
      this.showBackButton = true,
      this.bottom});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: showBackButton,
      backgroundColor: Colors.black,
      leading: showBackButton == true
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
              },
            )
          : showBackButton == false
              ? IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                )
              : Container(),
      title: Text(
        titleMsg!,
        style: const TextStyle(
          fontSize: 20.0,
          letterSpacing: 3.0,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => bottom == null
      ? const Size.fromHeight(kToolbarHeight)
      : Size.fromHeight(bottom!.preferredSize.height);
}
