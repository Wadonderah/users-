import 'package:cloud_firestore/cloud_firestore.dart';

class HomeViewModel {
  readBannerFromFirestore() async {
    List bannerList = [];
    await FirebaseFirestore.instance
        .collection('banner')
        .get()
        .then((QuerySnapshot querySnapshot) {
      // ignore: avoid_function_literals_in_foreach_calls
      querySnapshot.docs.forEach((document) {
        bannerList.add(document['image']);
      });
    });
    return bannerList;
  }

  readCategoriesFromFirestore() async {
    List categoriesList = [];
    await FirebaseFirestore.instance
        .collection('categories')
        .get()
        .then((QuerySnapshot querySnapshot) {
      // ignore: avoid_function_literals_in_foreach_calls
      querySnapshot.docs.forEach((document) {
        categoriesList.add(document['name']);
      });
    });
    return categoriesList;
  }
}
