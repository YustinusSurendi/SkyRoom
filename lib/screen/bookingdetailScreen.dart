import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:sky_room/model/modelBookingRoom.dart';
import 'package:sky_room/component/notification.dart';
import 'package:sky_room/providers/providerLogin.dart';

class DetailRoom extends StatefulWidget {
  final EventModel hotel;
  final NotificationHeimdall notip = NotificationHeimdall();

  DetailRoom({Key? key, required this.hotel}) : super(key: key);

  @override
  _DetailRoomState createState() => _DetailRoomState();
}

class _DetailRoomState extends State<DetailRoom> {
  final CollectionReference reviewsCollection =
      FirebaseFirestore.instance.collection('reviews');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hotel.namahotel),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 250,
              child: Card(
                elevation: 5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    widget.hotel.gambarhotel,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Deskripsi:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.hotel.deskripsihotel,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Harga per Hari:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Rp ${widget.hotel.hargahotel.toString()}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      widget.notip
                          .showPesanNotif('SkyRoom', 'Pemesanan Berhasil');
                    },
                    child: const Text('Booking Now'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Penilaian dan Komentar:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            StreamBuilder(
              stream: reviewsCollection
                  .where('hotelId', isEqualTo: widget.hotel.id)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Belum ada komentar.'),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var review = HotelReview.fromMap(snapshot.data!.docs[index]
                        .data() as Map<String, dynamic>);
                    return ListTile(
                      title: Text(
                        '${review.userName} - Rating: ${review.rating}/5',
                        style: const TextStyle(fontSize: 16),
                      ),
                      subtitle: Text(review.comment),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showRatingForm(context);
              },
              child: const Text('Beri Penilaian'),
            ),
          ],
        ),
      ),
    );
  }

  void _showRatingForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RatingDialog(
          title: const Text('Beri Penilaian'),
          submitButtonText: 'Submit Review',
          onSubmitted: (response) async {
            User? currentUser = FirebaseAuth.instance.currentUser;

            if (currentUser != null) {
              HotelReview newReview = HotelReview(
                userId: currentUser.uid,
                userName: context.read<UserProvider>().username ?? 'Anonymous',
                rating: response.rating.toInt(),
                comment: response.comment,
                hotelId: widget.hotel.id,
              );

              await reviewsCollection.add(newReview.toMap());
              setState(() {});
              widget.notip.showPesanNotif('SkyRoom', 'Review Submitted');
            } else {
              widget.notip.showPesanNotif('SkyRoom', 'User not authenticated');
            }
          },
        );
      },
    );
  }
}
