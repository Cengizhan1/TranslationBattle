import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myfirsproje/home.dart';
import 'package:myfirsproje/main.dart';
import 'package:myfirsproje/rankedQueue.dart';
import 'package:myfirsproje/service/auth.dart';
import 'package:myfirsproje/soruEkleme.dart';
import 'package:myfirsproje/timeTrial.dart';

import 'Finish.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  AuthService _authService = AuthService();

  var user = FirebaseAuth.instance.currentUser;
  var fireStore = FirebaseFirestore.instance;

  var usersRef = FirebaseFirestore.instance.collection("Person");
  var onlineRef = FirebaseDatabase.instance.ref('.info/connected');

  @override
  void initState() {
    // TODO: implement initState

    FirebaseDatabase.instance
        .ref('status/${user.uid}')
        .onDisconnect()
        .set('offline')
        .then((value) => {
              print("asdad"),
              fireStore
                  .collection("Person")
                  .doc(user.uid)
                  .update({'durum': true}),
            });

    FirebaseDatabase.instance.ref('status/${user.uid}').set('online');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 60;
    return Scaffold(
      body: Container(
        color: Color(0xFF272837),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Listener")
              .doc("Nzm")
              .snapshots(),
          builder: (context, listener) {
            return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Person")
                  .doc(user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                var dinleyici = listener.data;
                //Fluttertoast.showToast(msg: listener.hasData.toString());
                Fluttertoast.showToast(msg: dinleyici.data().toString());
                if (dinleyici.data() != null) {
                  if (dinleyici["arkIstek"] == "gonderildi") {
                    Fluttertoast.showToast(msg: "Ark isteği alındı");
                  }
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  var alinanVeri = snapshot.data["nick"];
                  var urlTutucu = snapshot.data["resim"];

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                              child: Row(
                                children: [
                                  Image.network(
                                    urlTutucu,
                                    height: 50,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(2, 0, 0, 0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    KullaniciGecmis()));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF2952BF),
                                          border: Border.all(width: 1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          alinanVeri,
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontFamily: 'İtalic',
                                              decoration: TextDecoration.none,
                                              fontSize: 12,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 2, 0, 5),
                              child: Image.network(
                                "https://pbs.twimg.com/media/CktwjRtWkAAm3Dc.png",
                                width: 150.0,
                                height: 100.0,
                              ),
                            ),
                            Text(
                              'Translation Battle',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'yazi',
                                  decoration: TextDecoration.none,
                                  fontSize: 50,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            circButton(FontAwesomeIcons.info, soruEkleme()),
                            circButton(
                                FontAwesomeIcons.medal,
                                achievementScreen(
                                  nick: alinanVeri,
                                )),
                            circButton(
                                FontAwesomeIcons.lightbulb,
                                Finishh(
                                  elo: 150,
                                  finishKullaniciAdi: "cengiz",
                                  kazan: "kazandı",
                                  totalScore: 7,
                                )),
                            circButton(FontAwesomeIcons.cog, profileScreen()),
                          ],
                        ),
                        Wrap(
                          runSpacing: 8,
                          children: [
                            GestureDetector(
                              onTap: () {
                                final list = nextNumbers(10, min: 0, max: 29);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChoiseLevel(
                                      lKullanici: alinanVeri,
                                      list: list,
                                      url: urlTutucu,
                                    ),
                                  ),
                                );
                              },
                              child: modeButton(
                                  'Play',
                                  'Play o normal game',
                                  FontAwesomeIcons.trophy,
                                  Color(0xFF2F80ED),
                                  width),
                            ),
                            GestureDetector(
                              onTap: () {
                                final list = nextNumbers(29, min: 0, max: 29);
                                print(list[1]);
                                print(list);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => timeTrial(
                                      list: list,
                                      homekullaniciAdi: alinanVeri,
                                      url: urlTutucu,
                                    ),
                                  ),
                                );
                              },
                              child: modeButton(
                                  'Time Trial',
                                  'Race against the clock',
                                  FontAwesomeIcons.userClock,
                                  Color(0xFFDF1D5A),
                                  width),
                            ),
                            GestureDetector(
                              onTap: () {
                                final list = nextNumbers(10, min: 0, max: 29);
                                var currentID =
                                    FirebaseAuth.instance.currentUser.uid;
                                FirebaseFirestore.instance
                                    .collection("Games")
                                    .get()
                                    .then((data) {
                                  var readdata = data.docs;
                                  var odakurucuid;
                                  for (int i = 0; i < readdata.length; i++) {
                                    if (readdata[i]["odaVisiblity"] == true) {
                                      odakurucuid = readdata[i]["odaID"];
                                      FirebaseFirestore.instance
                                          .collection("Games")
                                          .doc(odakurucuid)
                                          .update({
                                        "odaVisiblity": false,
                                        "user2": alinanVeri,
                                        "user2resim": urlTutucu.toString(),
                                        "user2totalScore": 0,
                                        "user2time": 0,
                                        "user2testDurum": "devam",
                                      });
                                      print(odakurucuid);
                                      return Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  rankLaunchScreen(
                                                    user: "user2",
                                                    nick: alinanVeri,
                                                    odaID: odakurucuid,
                                                    list: list,
                                                  )));
                                    }
                                  }
                                  FirebaseFirestore.instance
                                      .collection("Games")
                                      .doc(currentID)
                                      .set({
                                    "odaID": currentID,
                                    "odaVisiblity": true,
                                    "user1": alinanVeri,
                                    "user2": "Waiting",
                                    "user1resim": urlTutucu.toString(),
                                    "user2resim": "bekle",
                                    "user1totalScore": 0,
                                    "user2totalScore": 0,
                                    "user1time": 0,
                                    "user2time": 0,
                                    "user1testDurum": "devam",
                                    "user2testDurum": "baslamadi",
                                    "silmeDurumu": false
                                  });
                                  return Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              rankLaunchScreen(
                                                user: "user1",
                                                nick: alinanVeri,
                                                odaID: currentID,
                                                list: list,
                                              )));
                                });
                              },
                              child: modeButton(
                                  'Ranks',
                                  'Show ranks',
                                  FontAwesomeIcons.couch,
                                  Color(0xFF45D280),
                                  width),
                            ),
                            GestureDetector(
                              onTap: () {
                                FirebaseFirestore.instance
                                    .collection("Listener")
                                    .doc("Nzm")
                                    .set({
                                  "user1uid":
                                      FirebaseAuth.instance.currentUser.uid,
                                  "user1nick": alinanVeri,
                                  "user1resim": urlTutucu,
                                  "user2uid": "yok",
                                  "user2nick": "yok",
                                  "user2resim": "yok",
                                  "arkIstek": "false",
                                  "oyunIstek": ""
                                });
                              },
                              child: modeButton(
                                  'Pass & Play',
                                  'Challenge your friends',
                                  FontAwesomeIcons.userFriends,
                                  Color(0xFFFF8306),
                                  width),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }

  int nextNumber({int min, int max}) => min + Random().nextInt(max - min + 1);

  List<int> nextNumbers(int length, {int min, int max}) {
    final numbers = Set<int>();
    while (numbers.length < length) {
      final number = nextNumber(min: min, max: max);
      numbers.add(number);
    }
    return List.of(numbers);
  }

  Padding circButton(IconData icon, Widget page) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: RawMaterialButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => page));
        },
        fillColor: Colors.white,
        shape: CircleBorder(),
        constraints: BoxConstraints(minHeight: 35, minWidth: 35),
        child: FaIcon(icon, size: 22, color: Color(0xFF2F3041)),
      ),
    );
  }

  GestureDetector modeButton(
      String title, String subtitle, IconData icon, Color color, double width) {
    return GestureDetector(
      child: Container(
        width: width,
        height: 80,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 17, 0, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      fontFamily: 'Manrope',
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                        fontFamily: 'Manrope',
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 17, 25, 20),
              child: FaIcon(
                icon,
                size: 35,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}

//kullanıcı adına tıklanınca sayfa
class KullaniciGecmis extends StatefulWidget {
  @override
  _KullaniciGecmisState createState() => _KullaniciGecmisState();
}

class _KullaniciGecmisState extends State<KullaniciGecmis> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Users")
          .doc("normalGame")
          .collection(FirebaseAuth.instance.currentUser.uid)
          .orderBy("tarih", descending: true)
          .snapshots(),
      builder: (context, veriAl) {
        if (veriAl.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          var veri = veriAl.data.docs;
          var size = MediaQuery.of(context).size;
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Colors.black54, Color.fromRGBO(0, 41, 102, 1)])),
              child: Column(
                children: [
                  Container(
                    color: Color(0xFFE3E2E2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          height: 50,
                          width: 50,
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 24,
                            color: Colors.black54,
                          ),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black54),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                        Text(
                          'Profiles details',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Container(height: 24, width: 24)
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 20),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Cengizhan Yavuz',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.normal),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'ELO : 200',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.normal),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              '165 test çözüldü.',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/translatebattle.appspot.com/o/avatar1.png?alt=media&token=1b0bb93b-7f94-4776-af1d-836a15eca22a',
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                    child: Scrollbar(
                      showTrackOnHover: true,
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.all(8.0),
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.fromLTRB(9, 9, 9, 1),
                            height: 65,
                            decoration: BoxDecoration(
                              color: Colors.deepOrange,
                              border: Border.all(
                                width: 1,
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(veri[index]["kullanıcıAdi"],
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          veri[index]["süre"].toString(),
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          veri[index]["totalScore"].toString(),
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          veri[index]["tarih"].toString(),
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white)),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

// Level seçme ekranı
class ChoiseLevel extends StatefulWidget {
  String lKullanici, url;
  List<int> list;

  ChoiseLevel({this.lKullanici, this.list, this.url});

  @override
  _ChoiseLevelState createState() => _ChoiseLevelState();
}

class _ChoiseLevelState extends State<ChoiseLevel> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Person")
            .doc(FirebaseAuth.instance.currentUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          var veri = snapshot.data;
          var levels = veri["level"];
          return Scaffold(
            backgroundColor: Color(0xFF303247),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Levels",
                      style: TextStyle(
                        fontFamily: "yazi",
                        fontSize: 45,
                        color: Color(0xFFC9F3F3),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        levelButton(
                            "https://firebasestorage.googleapis.com/v0/b/translatebattle.appspot.com/o/1.png?alt=media&token=3720e6ec-ea48-4cdf-a1fc-3790b59241c8",
                            1,
                            levels),
                        levelButton(
                            "https://firebasestorage.googleapis.com/v0/b/translatebattle.appspot.com/o/2.png?alt=media&token=ebf89548-46f4-4158-bf6a-2f8032f90bef",
                            2,
                            levels),
                        levelButton(
                            "https://firebasestorage.googleapis.com/v0/b/translatebattle.appspot.com/o/3.png?alt=media&token=3a6147d3-41ea-46f0-af68-49c435b57ba0",
                            3,
                            levels),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        levelButton(
                            "https://firebasestorage.googleapis.com/v0/b/translatebattle.appspot.com/o/4.png?alt=media&token=11592df6-49da-4497-b8bd-794c4a4945f4",
                            4,
                            levels),
                        levelButton(
                            "https://firebasestorage.googleapis.com/v0/b/translatebattle.appspot.com/o/5.png?alt=media&token=392a9ee9-172d-4e08-b9e1-21954123939f",
                            5,
                            levels),
                        levelButton(
                            "https://firebasestorage.googleapis.com/v0/b/translatebattle.appspot.com/o/6.png?alt=media&token=3029f9c1-79b0-4bce-bf38-50274255a8e1",
                            6,
                            levels),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        levelButton(
                            "https://firebasestorage.googleapis.com/v0/b/translatebattle.appspot.com/o/7.png?alt=media&token=d1a691af-7abe-4619-a146-bb8c8b3351f7",
                            7,
                            levels),
                        levelButton(
                            "https://firebasestorage.googleapis.com/v0/b/translatebattle.appspot.com/o/8.png?alt=media&token=22bf8e50-2395-4e47-a227-cef2086ae131",
                            8,
                            levels),
                        levelButton(
                            "https://firebasestorage.googleapis.com/v0/b/translatebattle.appspot.com/o/9.png?alt=media&token=f49332e2-5d7c-4969-9226-0a7d688e9bb2",
                            9,
                            levels),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Padding levelButton(String url, int level, int kilit) {
    var kilitKontrol = false;

    if (kilit < level) {
      url =
          "https://firebasestorage.googleapis.com/v0/b/translatebattle.appspot.com/o/unlock.png?alt=media&token=02c336f7-f810-4f74-bde9-588db4592f2a";
      kilitKontrol = true;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xFF00FFFA).withOpacity(.7),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  color: Color(0xE404805A).withOpacity(.35),
                  blurRadius: 40,
                  spreadRadius: 2)
            ]),
        child: ElevatedButton(
          onPressed: () {
            if (kilitKontrol == false) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home(
                            homekullaniciAdi: widget.lKullanici,
                            list: widget.list,
                            url: widget.url,
                            kilitlevel: level,
                          )));
            } else {
              Fluttertoast.showToast(msg: "Bu seviye kilitlidir!");
            }
          },
          style: ElevatedButton.styleFrom(
            primary: Color(0xFF1A8B8B),
            fixedSize: (Size(75, 75)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(38),
            ),
          ),
          child: Image.network(
            url,
            height: 40,
          ),
        ),
      ),
    );
  }
}

// İnfo ekranı
class infoScreen extends StatefulWidget {
  @override
  _infoScreenState createState() => _infoScreenState();
}

class _infoScreenState extends State<infoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Finishh(
                finishKullaniciAdi: "nzm",
                totalScore: 10,
              ),
            ),
          );
        },
      ),
    );
  }
}

// Ödül ekranı
class achievementScreen extends StatefulWidget {
  String nick;

  achievementScreen({this.nick});

  @override
  _achievementScreenState createState() => _achievementScreenState();
}

class _achievementScreenState extends State<achievementScreen> {
  var user = FirebaseAuth.instance.currentUser;
  var fireStore = FirebaseFirestore.instance;

  showAlertDialog(BuildContext context, String nick, String resim) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "Quit",
        style: TextStyle(
            color: Colors.red, fontSize: 17, fontWeight: FontWeight.bold),
      ),
      onPressed: () => Navigator.pop(context, false),
    );
    Widget continueButton = TextButton(
      child: Text(
        "Ekle",
        style: TextStyle(
            color: Colors.green, fontSize: 17, fontWeight: FontWeight.bold),
      ),
      onPressed: () =>
          FirebaseFirestore.instance.collection("Listener").doc("Nzm").set({
        "user1uid": FirebaseAuth.instance.currentUser.uid,
        "user1nick": nick,
        "user1resim": resim,
        "user2uid": "yok",
        "user2nick": "yok",
        "user2resim": "yok",
        "arkIstek": "gonderildi",
        "oyunIstek": "yok"
      }).then((value) => Navigator.pop(context, false)),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      content: Text(
        "Arkadaş eklemek istediğinize emin misiniz?",
        style: TextStyle(
            color: Colors.black, fontSize: 17, fontWeight: FontWeight.normal),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Person")
          .orderBy("elo", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          Text("Aktarım Başarısız!");
        }
        var veriler = snapshot.data.docs;

        return Scaffold(
            backgroundColor: Color(0xFF272837),
            appBar: AppBar(
              title: Text(
                "Top List",
                style: TextStyle(
                  fontSize: 50,
                  color: Colors.white,
                  fontFamily: "yazi",
                ),
              ),
              centerTitle: true,
              backgroundColor: Color(0xFF2B2B44),
            ),
            body: ListView.builder(
                shrinkWrap: true,
                itemCount: veriler.length,
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot satirVerisi = veriler[index];
                  return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: BorderSide(
                              color: (widget.nick == satirVerisi["nick"])
                                  ? Colors.green
                                  : Colors.red,
                              width: 2.0)),
                      color: Color(0xFFAEB0BD),
                      elevation: 5,
                      margin: EdgeInsets.fromLTRB(5, 8, 5, 1),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: GestureDetector(
                          onTap: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 60,
                                width: 60,
                                child: Image.network(satirVerisi["resim"]),
                              ),
                              Text(
                                satirVerisi["nick"],
                                textAlign: TextAlign.left,
                              ),
                              (index == 0)
                                  ? Image.network(
                                      "https://firebasestorage.googleapis.com/v0/b/translatebattle.appspot.com/o/goldcup.png?alt=media&token=e6cb2247-0610-4c15-abd0-76acf7ac5798",
                                      height: 50,
                                    )
                                  : (index == 1)
                                      ? Image.network(
                                          "https://firebasestorage.googleapis.com/v0/b/translatebattle.appspot.com/o/silvercup.png?alt=media&token=38dcd681-3c13-46f5-8ffb-20fb7cc75ba4",
                                          height: 50,
                                        )
                                      : (index == 2)
                                          ? Image.network(
                                              "https://firebasestorage.googleapis.com/v0/b/translatebattle.appspot.com/o/bronzecup.png?alt=media&token=f297223c-a234-4f45-b0a8-76344365bc63",
                                              height: 50,
                                            )
                                          : Image.network(
                                              "https://firebasestorage.googleapis.com/v0/b/translatebattle.appspot.com/o/medal.png?alt=media&token=2cdf8695-f53a-4365-991a-428a93b78f56",
                                              height: 50,
                                            ),
                              Text(
                                satirVerisi["elo"].toString(),
                                textAlign: TextAlign.right,
                              ),
                              FloatingActionButton(
                                onPressed: () {
                                  showAlertDialog(context, satirVerisi["nick"],
                                      satirVerisi["resim"]);
                                },
                                mini: true,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    side: BorderSide(
                                        color: Colors.black, width: 1.4)),
                                backgroundColor: Color(0xFFAEB0BD),
                                child: Image.network(
                                  "https://firebasestorage.googleapis.com/v0/b/translatebattle.appspot.com/o/useradd.png?alt=media&token=95ef25c9-0ccf-4ec8-8cf3-f53692620140",
                                  height: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ));
                }));
      },
    );
  }
}

// İpucu ekranı
class hintScreen extends StatefulWidget {
  @override
  _hintScreenState createState() => _hintScreenState();
}

class _hintScreenState extends State<hintScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

// Profil ekranı
class profileScreen extends StatefulWidget {
  @override
  _profileScreenState createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {
  final TextEditingController sifrec = TextEditingController();
  final TextEditingController nickc = TextEditingController();
  final TextEditingController adc = TextEditingController();
  AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Person")
            .doc(FirebaseAuth.instance.currentUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          var urlTutucu = snapshot.data["resim"];
          var nick = snapshot.data["nick"];
          var userName = snapshot.data["userName"];
          return Scaffold(
            backgroundColor: Color(0xE2013865),
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () {
                            _authService.signOut();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GirisEkrani()));
                          },
                          icon: Icon(
                            Icons.exit_to_app,
                            color: Color(0xE4D0C5C5),
                            size: 25,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 13, 0, 30),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Avatar()));
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xff055884),
                            fixedSize: Size(95, 95),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60),
                            ),
                          ),
                          child: Image.network(
                            urlTutucu,
                            height: 95,
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Container(
                            height: size.height * .55,
                            width: size.width,
                            decoration: BoxDecoration(
                                color: Color(0xFF105A58).withOpacity(.75),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(28)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xE4928686).withOpacity(.6),
                                      blurRadius: 50,
                                      spreadRadius: 2)
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 12, 15, 0),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      child: TextFormField(
                                        controller: adc,
                                        style: TextStyle(color: Colors.white),
                                        decoration: const InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.person,
                                            color: Color(0xFFD1D9DC),
                                          ),
                                          hintText: "Yeni kullanıcı adı",
                                          prefixText: " ",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
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
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: TextFormField(
                                        controller: nickc,
                                        style: TextStyle(color: Colors.white),
                                        decoration: const InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.sports_esports,
                                            color: Color(0xFFD1D9DC),
                                          ),
                                          hintText: "Yeni nick",
                                          prefixText: " ",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
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
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: TextFormField(
                                        obscureText: true,
                                        controller: sifrec,
                                        validator: (_passwordController) {
                                          return _passwordController.length >= 6
                                              ? null
                                              : "Şifre 6 karakterden az olamaz";
                                        },
                                        style: TextStyle(color: Colors.white),
                                        decoration: const InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.vpn_key,
                                            color: Color(0xFFD1D9DC),
                                          ),
                                          hintText: "Yeni şifre",
                                          prefixText: " ",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
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
                                    ),
                                    SizedBox(
                                      height: 40,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        {
                                          if (sifrec.text == "") {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Şifre kısmı boş bırakılamaz!");
                                            return;
                                          }
                                          _authService.guncelle(
                                            sifrec.text,
                                            (nickc.text == ""
                                                ? nickc.text = nick
                                                : nickc.text),
                                            (adc.text == ""
                                                ? adc.text = userName
                                                : adc.text),
                                          );
                                        }
                                        adc.clear();
                                        sifrec.clear();
                                        nickc.clear();
                                      },
                                      style: ElevatedButton.styleFrom(
                                          primary: Color(0xff055884),
                                          fixedSize: Size(250, 55),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25))),
                                      child: Text(
                                        'Güncelle',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25,
                                            color: Colors.white,
                                            fontFamily: 'Manrope',
                                            decoration: TextDecoration.none),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class rankLaunchScreen extends StatefulWidget {
  String user, nick, odaID;
  List<int> list;

  rankLaunchScreen({this.user, this.nick, this.odaID, this.list});

  @override
  _rankLaunchScreenState createState() => _rankLaunchScreenState();
}

class _rankLaunchScreenState extends State<rankLaunchScreen> {
  var odaDurum;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Person").snapshots(),
        builder: (context, veri2) {
          return StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Games")
                  .doc(widget.odaID)
                  .snapshots(),
              builder: (context, veri) {
                odaDurum = veri.data["odaVisiblity"].toString();
                var user1 = veri.data["user1"].toString();
                var user2 = veri.data["user2"].toString();
                var user1resim = veri.data["user1resim"].toString();
                var user2resim = veri.data["user2resim"].toString();

                if (odaDurum == "false") {
                  Future.delayed(
                    Duration(milliseconds: 2500),
                    () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => rankedQueue(
                            user: widget.user,
                            homekullaniciAdi: widget.nick,
                            user1: user1,
                            user2: user2,
                            user1url: user1resim,
                            user2url: user2resim,
                            odaID: widget.odaID,
                            list: widget.list,
                          ),
                        ),
                      );
                    },
                  );
                }

                return Scaffold(
                  backgroundColor: Color(0xE2013865),
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Column(
                              children: [
                                Image.network(
                                  (user1resim == "bekle")
                                      ? "https://w7.pngwing.com/pngs/273/858/png-transparent-question-mark-computer-icons-exclamation-mark-desktop-question-mark-emoji-angle-text-logo.png"
                                      : user1resim,
                                  height: 150,
                                  width: 150,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  user1,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Column(
                              children: [
                                (user2resim == "bekle")
                                    ? Padding(
                                        padding: const EdgeInsets.all(20 + .0),
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          child: CircularProgressIndicator(
                                            color: Colors.deepOrange,
                                            strokeWidth: 4,
                                          ),
                                        ),
                                      )
                                    : Image.network(
                                        user2resim,
                                        height: 150,
                                        width: 150,
                                      ),
                                SizedBox(
                                  height: 23,
                                ),
                                Text(
                                  user2,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        (odaDurum == "true")
                            ? "Kullanıcı Bekleniyor"
                            : "Oyun birazdan başlayacak",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection("Games")
                              .doc(widget.odaID)
                              .delete()
                              .then((value) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Menu(),
                              ),
                            );
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.deepOrange,
                            fixedSize: Size(250, 55),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25))),
                        child: Text(
                          'İptal',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color: Colors.white,
                              fontFamily: 'Manrope',
                              decoration: TextDecoration.none),
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }
}

//Avatar seçim ekranı
class Avatar extends StatefulWidget {
  @override
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  var user = FirebaseAuth.instance.currentUser;
  var firebase = FirebaseFirestore.instance;

  AuthService authService = AuthService();

  var alinanDosya;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar1.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar1.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar2.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar2.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar3.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar3.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar4.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar4.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar5.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar5.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar6.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar6.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar7.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar7.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar8.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar8.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar9.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar9.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar10.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar10.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar11.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar11.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar12.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar12.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar13.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar13.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar14.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar14.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar15.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar15.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar16.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar16.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar17.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar17.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar18.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar18.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar19.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar19.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar20.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar20.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar21.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar21.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar22.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar22.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar23.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar23.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar24.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar24.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar25.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar25.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar26.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar26.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar27.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar27.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar28.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar28.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar29.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar29.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar30.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar30.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar31.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar31.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar32.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar32.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar33.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar33.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar34.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar34.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar35.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar35.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar36.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar36.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar37.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar37.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar38.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar38.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar39.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar39.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar40.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar40.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar41.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar41.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar42.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar42.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar43.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar43.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar44.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar44.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar45.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar45.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar46.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar46.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar47.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar47.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar48.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar48.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar49.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar49.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar50.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar50.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar51.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar51.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authService.resimAl("avatar52.png").then((value) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => profileScreen()));
                      });
                    },
                    child: Image(
                      image: AssetImage("images/avatar52.png"),
                      height: 150,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      fixedSize: Size(130, 130),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(55),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
