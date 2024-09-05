import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../global/global_vars.dart';
import '../mainScreens/home_screen.dart';
import '../splashScreen/splash_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          // Drawer Header.
          Container(
            padding: const EdgeInsets.only(top: 25, bottom: 10),
            child: Column(
              children: [
                // image.
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(81)),
                  elevation: 8,
                  child: SizedBox(
                    height: 158,
                    width: 158,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        sharedPreferences!.getString('imageUrl').toString(),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  sharedPreferences!.getString('name').toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontFamily: 'Billabong',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Drawer Body.

          Column(
            children: [
              const Divider(
                height: 10,
                color: Colors.grey,
                thickness: 2,
              ),
              ListTile(
                leading: const Icon(Icons.home, color: Colors.white),
                title: const Text(
                  'Home',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => const HomeScreen()));
                },
              ),
              const Divider(
                height: 10,
                color: Colors.grey,
                thickness: 2,
              ),
              ListTile(
                leading: const Icon(Icons.reorder, color: Colors.white),
                title: const Text(
                  'My Orders',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => const HomeScreen()));
                },
              ),
              const Divider(
                height: 10,
                color: Colors.grey,
                thickness: 2,
              ),
              ListTile(
                leading: const Icon(Icons.access_time, color: Colors.white),
                title: const Text(
                  'My History',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => const HomeScreen()));
                },
              ),
              const Divider(
                height: 10,
                color: Colors.grey,
                thickness: 2,
              ),
              ListTile(
                leading: const Icon(Icons.search, color: Colors.white),
                title: const Text(
                  'Search Specific Cafe/Restaurant',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => const HomeScreen()));
                },
              ),
              const Divider(
                height: 10,
                color: Colors.grey,
                thickness: 2,
              ),
              ListTile(
                leading: const Icon(Icons.add_location, color: Colors.white),
                title: const Text(
                  'Add New Address',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {},
              ),
              const Divider(
                height: 10,
                color: Colors.grey,
                thickness: 2,
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.white),
                title: const Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => const SplashScreen()));
                },
              ),
              const Divider(
                height: 10,
                color: Colors.grey,
                thickness: 2,
              )
            ],
          ),
        ],
      ),
    );
  }
}
