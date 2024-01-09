import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String id;
  String namahotel;
  int hargahotel;
  String gambarhotel;
  String deskripsihotel; // Tambahkan atribut deskripsi

  EventModel({
    required this.id,
    required this.namahotel,
    required this.hargahotel,
    required this.gambarhotel,
    required this.deskripsihotel, // Inisialisasi deskripsi
  });

  Map<String, dynamic> toMap() {
    return {
      'namahotel': namahotel,
      'hargahotel': hargahotel,
      'gambarhotel': gambarhotel,
      'deskripsihotel': deskripsihotel, // Simpan deskripsi
    };
  }

  EventModel.fromDocSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        namahotel = doc.data()?['namahotel'],
        hargahotel = doc.data()?['hargahotel'],
        gambarhotel = doc.data()?['gambarhotel'],
        deskripsihotel =
            doc.data()?['deskripsihotel']; // Ambil deskripsi dari Firestore
}
