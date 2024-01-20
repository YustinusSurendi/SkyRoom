import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FasilitasScreen extends StatefulWidget {
  const FasilitasScreen({Key? key}) : super(key: key);

  @override
  State<FasilitasScreen> createState() => _FasilitasScreenState();
}

class _FasilitasScreenState extends State<FasilitasScreen> {
  late List<Map<String, dynamic>> fasilitasList = [];

  @override
  void initState() {
    super.initState();
    _readData();
  }

  Future<void> _readData() async {
    try {
      QuerySnapshot fasilitasSnapshot =
          await FirebaseFirestore.instance.collection('fasilitas').get();

      setState(() {
        fasilitasList = fasilitasSnapshot.docs
            .map((DocumentSnapshot documentSnapshot) =>
                documentSnapshot.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (error) {
      print('Error fetching fasilitas data: $error');
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
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: const Icon(
                Icons.calendar_month_sharp,
                color: Colors.white,
                size: 30,
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
                      Icons.home_work_outlined,
                      color: Colors.white,
                      size: 35,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Fasilitas',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Container(
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  children: fasilitasList.map((data) {
                    String namaFasilitas = data['nama'] ?? '';
                    String gambarFasilitas = data['gambarfasilitas'] ?? '';

                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            namaFasilitas,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 15),
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: NetworkImage(gambarFasilitas),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
