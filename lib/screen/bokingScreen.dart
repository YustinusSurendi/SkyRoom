import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sky_room/model/modelBookingRoom.dart';
import 'package:sky_room/providers/providerLogin.dart';
import 'package:sky_room/screen/bookingdetailScreen.dart';
import 'package:sky_room/screen/favorite_hotel.dart';
import 'package:sky_room/screen/listMyjadwalScreen.dart';

class BokingScreen extends StatefulWidget {
  const BokingScreen({super.key});

  @override
  State<BokingScreen> createState() => _BokingScreenState();
}

class _BokingScreenState extends State<BokingScreen> {
  TextEditingController searchcontroller = TextEditingController();
  List<EventModel> details = [];
  late List<EventModel> filteredDetails = [];
  List<EventModel> favoriteHotels = [];
  Map<String, bool> favoriteStatus = {}; // Track favorite status locally
  @override
  void initState() {
    super.initState();
    readData();
    readUserFavorites();
  }

  Future<void> addToFavorites(String hotelId) async {
    final userId = context.read<UserProvider>().uid ?? "";
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'favoriteHotels': FieldValue.arrayUnion([hotelId]),
      });
    } catch (error) {
      print('Error adding to favorites: $error');
    }
  }

  Future<void> removeFromFavorites(String hotelId) async {
    final userId = context.read<UserProvider>().uid ?? "";
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'favoriteHotels': FieldValue.arrayRemove([hotelId]),
      });
    } catch (error) {
      print('Error removing from favorites: $error');
    }
  }

  Future<void> readUserFavorites() async {
    final userId = context.read<UserProvider>().uid ?? "";
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        List<String> favorites =
            (userSnapshot['favoriteHotels'] as List<dynamic>?)
                    ?.map((dynamic e) => e.toString())
                    .toList() ??
                [];

        setState(() {
          favoriteHotels =
              details.where((hotel) => favorites.contains(hotel.id)).toList();
        });
      }
    } catch (error) {
      print('Error fetching user favorites: $error');
    }
  }

  Future<void> readData() async {
    await Firebase.initializeApp();
    FirebaseFirestore db = FirebaseFirestore.instance;
    var data = await db.collection('hotel_list').get();
    setState(() {
      details =
          data.docs.map((doc) => EventModel.fromDocSnapshot(doc)).toList();
      filteredDetails = details;
    });
  }

  void filterSearchResults(String query) {
    List<EventModel> searchList = [];
    searchList.addAll(details);
    if (query.isNotEmpty) {
      List<EventModel> filteredList = [];
      for (var item in searchList) {
        if (item.namahotel.toLowerCase().contains(query.toLowerCase())) {
          filteredList.add(item);
        }
      }
      setState(() {
        filteredDetails = filteredList;
      });
    } else {
      setState(() {
        filteredDetails = details;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: searchcontroller,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                  fillColor: Colors.grey,
                  hintText: 'search',
                  hintStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: IconButton(
                icon: const Icon(
                  Icons.star,
                  color: Colors.yellow,
                  size: 35,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const FavoriteHotelScreen()));
                },
              ),
            ),
            InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ScreenListJadwal())),
              child: Container(
                margin: const EdgeInsets.only(left: 20),
                child: const Icon(
                  Icons.calendar_month_sharp,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: Row(
                  children: [
                    Icon(
                      Icons.collections_bookmark,
                      color: Colors.white,
                      size: 35,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Booking',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              for (var hotel in filteredDetails)
                Column(children: [
                  Card(
                    margin: const EdgeInsets.only(top: 30),
                    color: const Color(0x0ffffff1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 10,
                    child: Column(
                      children: [
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20)),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(hotel.gambarhotel),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      hotel.namahotel,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Rp ${hotel.hargahotel} ',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        const Text(
                                          ' /Night',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  setState(() {
                                    if (favoriteHotels.contains(hotel)) {
                                      favoriteHotels.remove(hotel);
                                      removeFromFavorites(hotel.id);
                                    } else {
                                      favoriteHotels.add(hotel);
                                      addToFavorites(hotel.id);
                                    }
                                  });
                                },
                                icon: Icon(
                                  favoriteHotels.contains(hotel)
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.yellow,
                                  size: 30,
                                ),
                              ),
                              SizedBox(
                                  height: 40,
                                  width: 100,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => DetailRoom(
                                            hotel: hotel,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Details',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ]),
            ],
          ),
        ),
      ),
    );
  }
}
