import 'package:flutter/material.dart';
import 'package:sky_room/model/modelJadwal.dart';

class JadwalProvider with ChangeNotifier {
  final List<ModelJadwal> _listJadwal = [];

  List<ModelJadwal> get allJadwal => _listJadwal;

  void buatJadwal(ModelJadwal newJadwal) {
    _listJadwal.add(newJadwal);
    notifyListeners();
  }
}
