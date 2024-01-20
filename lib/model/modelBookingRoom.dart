import 'package:cloud_firestore/cloud_firestore.dart';

class HotelReview {
  String userId;
  int rating;
  String comment;
  String userName; // New field to store user's name
  String hotelId; // New field to store hotel's id

  HotelReview({
    required this.userId,
    required this.rating,
    required this.comment,
    required this.userName,
    required this.hotelId,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'rating': rating,
      'comment': comment,
      'userName': userName,
      'hotelId': hotelId,
    };
  }

  HotelReview.fromMap(Map<String, dynamic> map)
      : userId = map['userId'],
        rating = map['rating'],
        comment = map['comment'],
        userName = map['userName'],
        hotelId = map['hotelId'];
}

class EventModel {
  String id;
  String namahotel;
  int hargahotel;
  String gambarhotel;
  String deskripsihotel;
  List<HotelReview> reviews;

  EventModel({
    required this.id,
    required this.namahotel,
    required this.hargahotel,
    required this.gambarhotel,
    required this.deskripsihotel,
    required this.reviews,
  });

  Map<String, dynamic> toMap() {
    return {
      'namahotel': namahotel,
      'hargahotel': hargahotel,
      'gambarhotel': gambarhotel,
      'deskripsihotel': deskripsihotel,
      'reviews': reviews.map((review) => review.toMap()).toList(),
    };
  }

  EventModel.fromDocSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        namahotel = doc.data()?['namahotel'],
        hargahotel = doc.data()?['hargahotel'],
        gambarhotel = doc.data()?['gambarhotel'],
        deskripsihotel = doc.data()?['deskripsihotel'],
        reviews = List<HotelReview>.from(
            (doc.data()?['reviews'] ?? []).map((review) => HotelReview(
                  userId: review['userId'],
                  rating: review['rating'],
                  comment: review['comment'],
                  userName: review['userName'],
                  hotelId: '',
                )));
}
