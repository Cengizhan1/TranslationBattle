import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class soruEkleme extends StatefulWidget {
  @override
  _soruEklemeState createState() => _soruEklemeState();
}

class _soruEklemeState extends State<soruEkleme> {
  final TextEditingController soruc = TextEditingController();
  final TextEditingController cevap1c = TextEditingController();
  final TextEditingController cevap2c = TextEditingController();
  final TextEditingController cevap3c = TextEditingController();
  final TextEditingController dogrucevapc = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Column(
          children: [
            TextFormField(
              controller: soruc,
              style: TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Soru kelimesini giriniz .",
                prefixText: " ",
                hintStyle: TextStyle(color: Colors.grey),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.white,
                )),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            TextFormField(
              controller: cevap1c,
              style: TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "1. cevapı giriniz .",
                prefixText: " ",
                hintStyle: TextStyle(color: Colors.grey),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.white,
                )),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            TextFormField(
              controller: cevap2c,
              style: TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "2. cevapı giriniz .",
                prefixText: " ",
                hintStyle: TextStyle(color: Colors.grey),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.white,
                )),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            TextFormField(
              controller: cevap3c,
              style: TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "3. cevapı giriniz .",
                prefixText: " ",
                hintStyle: TextStyle(color: Colors.grey),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.white,
                )),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            TextFormField(
              controller: dogrucevapc,
              style: TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Doğru cevabı giriniz .",
                prefixText: " ",
                hintStyle: TextStyle(color: Colors.grey),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.white,
                )),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Map<String, dynamic> data = {
                  'soru': " " '"${soruc.text.toString()}"' " türkçesi nedir",
                  '1': cevap1c.text.toString(),
                  '2': cevap2c.text.toString(),
                  '3': cevap3c.text.toString(),
                  'dogrucevap': int.parse(dogrucevapc.text),
                };
                FirebaseFirestore.instance
                    .collection("Questions")
                    .doc()
                    .set(data);
                soruc.clear();
                cevap1c.clear();
                cevap2c.clear();
                cevap3c.clear();
                dogrucevapc.clear();
              },
              child: Text(
                "Soruyu ekle",
                textAlign: TextAlign.center,
              ),
              style: ElevatedButton.styleFrom(
                primary: Color(0xff055884),
                fixedSize: Size(95, 95),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
