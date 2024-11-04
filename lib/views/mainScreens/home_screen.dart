import 'package:flutter/material.dart';
import 'package:users/global/global_instances.dart';
import 'package:users/views/widgets/my_appbar.dart';
import '../widgets/my_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> bannerImagesList = [];
  List<Map<String, dynamic>> categoriesList = [];
  List<Map<String, dynamic>> recommendedItems = [];
  List<Map<String, dynamic>> popularItems = [];
  List<Map<String, dynamic>> cafeRestaurants = [];
  int _currentPage = 0;
  final PageController _pageController = PageController(viewportFraction: 0.8);
  String currency = 'KES';

  Future<void> updateUI() async {
    try {
      bannerImagesList = await homeViewModel.readBannerFromFirestore();
      categoriesList = await homeViewModel.readCategoriesFromFirestore();

      recommendedItems = List.generate(
          5,
          (index) => {
                'name': 'Recommended Item ${index + 1}',
                'image': 'https://via.placeholder.com/150',
                'price': (index + 1) * 599.0,
              });
      popularItems = List.generate(
          5,
          (index) => {
                'name': 'Popular Item ${index + 1}',
                'image': 'https://via.placeholder.com/150',
                'price': (index + 1) * 499.0,
              });
      cafeRestaurants = List.generate(
          5,
          (index) => {
                'name': 'Cafe/Restaurant ${index + 1}',
                'image': 'https://via.placeholder.com/150',
                'rating': (3 + index % 3).toDouble(),
              });
      setState(() {});
    } catch (e) {
      // ignore: avoid_print
      print('Error updating UI: $e');
    }
  }

  String formatPrice(double price) {
    return '$currency ${price.toStringAsFixed(2)}';
  }

  @override
  void initState() {
    super.initState();
    updateUI();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: MyAppbar(
        titleMsg: "Dishi Hub",
        showBackButton: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Banners
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 10, right: 10),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemCount: bannerImagesList.length,
                  itemBuilder: (context, index) {
                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        double value = 1.0;
                        if (_pageController.position.haveDimensions) {
                          value = _pageController.page! - index;
                          value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                        }
                        return Center(
                          child: SizedBox(
                            height: Curves.easeOut.transform(value) *
                                MediaQuery.of(context).size.height *
                                0.3,
                            child: child,
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            bannerImagesList[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Page Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                bannerImagesList.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? Colors.blue : Colors.grey,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Categories
            _buildSectionTitle("Categories"),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoriesList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              categoriesList[index]['image'] ?? ''),
                        ),
                        const SizedBox(height: 4),
                        Text(categoriesList[index]['name'] ?? ''),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Recommended items
            _buildSectionTitle("Recommended Items"),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recommendedItems.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            recommendedItems[index]['image'] ?? '',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          recommendedItems[index]['name'] ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          formatPrice(recommendedItems[index]['price'] ?? 0.0),
                          style: const TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Popular items
            _buildSectionTitle("Popular Items"),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: popularItems.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            popularItems[index]['image'] ?? '',
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          popularItems[index]['name'] ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          formatPrice(popularItems[index]['price'] ?? 0.0),
                          style: const TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Cafe/Restaurants
            _buildSectionTitle("Cafe/Restaurants"),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cafeRestaurants.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      cafeRestaurants[index]['image'] ?? '',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(cafeRestaurants[index]['name'] ?? ''),
                  subtitle: Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      Text(' ${cafeRestaurants[index]['rating'] ?? 0.0}'),
                    ],
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      // Add your navigation logic here
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.blue),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ),
    );
  }
}
