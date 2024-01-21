import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sky_room/model/modelBookingRoom.dart';
import 'package:sky_room/providers/providerLogin.dart';
import 'package:sky_room/screen/bookingdetailScreen.dart';

class FavoriteHotelScreen extends StatefulWidget {
  const FavoriteHotelScreen({Key? key}) : super(key: key);

  @override
  _FavoriteHotelScreenState createState() => _FavoriteHotelScreenState();
}

class _FavoriteHotelScreenState extends State<FavoriteHotelScreen> {
  List<EventModel> favoriteHotels = []; // List hotel favorit
  List<EventModel> details = [];

  @override
  void initState() {
    super.initState();
    readHotelDetails();
    readUserFavorites();
  }

  Future<void> readHotelDetails() async {
    try {
      // Fetch hotel details from Firestore
      var data =
          await FirebaseFirestore.instance.collection('hotel_list').get();
      setState(() {
        details =
            data.docs.map((doc) => EventModel.fromDocSnapshot(doc)).toList();
      });
    } catch (error) {
      print('Error fetching hotel details: $error');
    }
  }

  Future<void> readUserFavorites() async {
    final userId = context.read<UserProvider>().uid;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Hotels"),
      ),
      body: favoriteHotels.isEmpty
          ? const Center(
              child: Text("Belum ada hotel favorite"),
            )
          : ListView.builder(
              itemCount: favoriteHotels.length,
              itemBuilder: (context, index) {
                var hotel = favoriteHotels[index];
                return Card(
                  margin: const EdgeInsets.all(10),
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
                            topLeft: Radius.circular(20),
                          ),
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
                                      color: Colors.white,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Rp ${hotel.hargahotel} ',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Text(
                                        ' /Night',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}
