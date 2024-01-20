import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sky_room/model/modelBookingRoom.dart';
import 'package:sky_room/screen/bookingdetailScreen.dart';
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
  @override
  void initState() {
    super.initState();
    readData();
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
              child: const Icon(
                Icons.notifications,
                color: Colors.white,
                size: 30,
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
                                          ' / Day',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
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
