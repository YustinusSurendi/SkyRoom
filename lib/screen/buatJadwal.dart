import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:project_heimdall/model/modelJadwal.dart';
import 'package:project_heimdall/providers/providerLogin.dart';
import 'package:project_heimdall/providers/providerjadwal.dart';
import 'package:provider/provider.dart';

SnackBar createSnackBar(String text, Color color, String label) {
  return SnackBar(
    backgroundColor: color,
    content: Text(
      text,
      style: const TextStyle(color: Colors.black),
    ),
    action: SnackBarAction(
      label: label,
      onPressed: () {},
    ),
  );
}

class BuatJadwalScreen extends StatefulWidget {
  final gambar;
  final room_hotel;
  const BuatJadwalScreen({super.key, this.room_hotel, this.gambar});

  @override
  State<BuatJadwalScreen> createState() => _BuatJadwalScreenState();
}

class _BuatJadwalScreenState extends State<BuatJadwalScreen> {
  String dateJadwal = '';

  @override
  Widget build(BuildContext context) {
    final jadwalProv = Provider.of<JadwalProvider>(context);
    final userProv = Provider.of<UserProvider>(context);

    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const Text(
              'Buat Jadwal',
              style: TextStyle(fontSize: 18),
            ),
            DateTimePicker(
              type: DateTimePickerType.dateTimeSeparate,
              dateMask: 'd MMM, yyyy',
              initialValue: '',
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              icon: const Icon(Icons.event),
              dateLabelText: 'Date',
              timeLabelText: "Hour",
              selectableDayPredicate: (date) {
                return true;
              },
              onChanged: (val) => dateJadwal = val.toString(),
              validator: (val) {
                dateJadwal = val.toString();
                return null;
              },
              onSaved: (val) => dateJadwal = val.toString(),
            )
          ],
        ),
      ),
      Spacer(),
      Row(
        children: [
          Container(
              width: 140,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Batal'))),
          Expanded(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  onPressed: () {
                    final snackBar = createSnackBar(
                        'Ruangan Berhasil Dibooking', Colors.green, 'Oke');

                    jadwalProv.buatJadwal(ModelJadwal(
                        email: userProv.emailUserLogin,
                        gambar: widget.gambar,
                        room_hotel: widget.room_hotel,
                        date: dateJadwal));
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: const Text('Pesan')))
        ],
      )
    ]);
  }
}
