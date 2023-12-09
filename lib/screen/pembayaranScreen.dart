import 'package:flutter/material.dart';
import 'package:sky_room/screen/buatJadwal.dart';
import 'package:sky_room/screen/listMyjadwalScreen.dart';

class PembayaranScreen extends StatefulWidget {
  final data;
  const PembayaranScreen({super.key, this.data});

  @override
  State<PembayaranScreen> createState() => _PembayaranScreenState();
}

class _PembayaranScreenState extends State<PembayaranScreen> {
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
                  hintText: 'Cari Pin Anda',
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
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Column(
          children: [
            const Row(
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
            Card(
              margin: const EdgeInsets.only(top: 30),
              color: Colors.black,
              elevation: 10,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('${widget.data['gambar']}'),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.data['nama']}',
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              Text(
                                '${widget.data['desc']}',
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey),
                        onPressed: () {},
                        child: Text('Rp ${widget.data['harga']}'))),
                SizedBox(
                    width: 140,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (BuildContext context) {
                                return Container(
                                    constraints: const BoxConstraints(
                                      maxHeight: 180,
                                    ),
                                    child: BuatJadwalScreen(
                                        gambar: widget.data['gambar'],
                                        room_hotel: widget.data['nama']));
                              });
                        },
                        child: const Text('Booking'))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
