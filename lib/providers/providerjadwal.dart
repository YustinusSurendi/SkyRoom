import 'package:flutter/material.dart';
import 'package:project_heimdall/model/modelJadwal.dart';
import 'package:project_heimdall/model/modelLogin.dart';

class JadwalProvider with ChangeNotifier {
  List<ModelJadwal> _listJadwal = [];

  List<ModelJadwal> get allJadwal => _listJadwal;

  void buatJadwal(ModelJadwal newJadwal) {
    _listJadwal.add(newJadwal);
    notifyListeners();
  }
}
