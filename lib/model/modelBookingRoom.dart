import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String? id;
  String namahotel;
  int hargahotel;
  String gambarhotel;

  EventModel({
    this.id,
    required this.namahotel,
    required this.hargahotel,
    required this.gambarhotel,
  });

  Map<String, dynamic> toMap() {
    return {
      'namahotel': namahotel,
      'hargahotel': hargahotel,
      'gambarhotel': gambarhotel
    };
  }

  EventModel.fromDocSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        namahotel = doc.data()?['namahotel'],
        hargahotel = doc.data()?['hargahotel'],
        gambarhotel = doc.data()?['gambarhotel'];
}
