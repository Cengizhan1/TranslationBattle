import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myfirsproje/home.dart';
import 'package:myfirsproje/main.dart';
import 'package:myfirsproje/ranks.dart';
import 'package:myfirsproje/service/auth.dart';

class Menu extends StatefulWidget {
  String kullaniciAdi;

  Menu({this.kullaniciAdi});

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  AuthService _authService = AuthService();
  var mevcutKullanici = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 60;

    return Scaffold(
      body: Container(
        color: Color(0xFF272837),
        child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Person")
                .doc(mevcutKullanici.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              var alinanVeri = snapshot.data["nick"];

              return Padding(
                padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.topRight,
                          padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
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
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                        circButton(FontAwesomeIcons.info, infoScreen()),
                        circButton(FontAwesomeIcons.medal, achievementScreen()),
                        circButton(FontAwesomeIcons.lightbulb, hintScreen()),
                        circButton(FontAwesomeIcons.cog, profileScreen()),
                      ],
                    ),
                    Wrap(
                      runSpacing: 14,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChoiseLevel(
                                  lKullanici: alinanVeri,
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
                          onTap: () {},
                          child: modeButton(
                              'Time Trial',
                              'Race against the clock',
                              FontAwesomeIcons.userClock,
                              Color(0xFFDF1D5A),
                              width),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Ranks(),
                              ),
                            );
                          },
                          child: modeButton('Ranks', 'Show ranks',
                              FontAwesomeIcons.couch, Color(0xFF45D280), width),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: modeButton(
                              'Pass & Play',
                              'Challenge your friends',
                              FontAwesomeIcons.userFriends,
                              Color(0xFFFF8306),
                              width),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        _authService.signOut();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GirisEkrani()));
                      },
                      child: Text(
                        "Çıkış",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
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

// Level seçme ekranı
class ChoiseLevel extends StatefulWidget {
  String lKullanici;

  ChoiseLevel({this.lKullanici});

  @override
  _ChoiseLevelState createState() => _ChoiseLevelState();
}

class _ChoiseLevelState extends State<ChoiseLevel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFF272837),
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Lütfen oynamak istediğiniz seviyeyi seçin",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.bold),
              ),
              Text("                                            "
                  ""
                  "       "),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(250, 60),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                child: Text(
                  "Kolay",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.white,
                      fontFamily: 'Manrope',
                      decoration: TextDecoration.none),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(
                        homekullaniciAdi: widget.lKullanici,
                      ),
                    ),
                  );
                },
              ),
              Text("              "),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(250, 60),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                child: Text(
                  "Orta",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.white,
                      decoration: TextDecoration.none),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(
                        homekullaniciAdi: widget.lKullanici,
                      ),
                    ),
                  );
                },
              ),
              Text("              "),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(250, 60),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50))),
                child: Text(
                  "Zor",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.white,
                      fontFamily: 'Manrope',
                      decoration: TextDecoration.none),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(
                        homekullaniciAdi: widget.lKullanici,
                      ),
                    ),
                  );
                },
              )
            ],
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
    return Container();
  }
}

// Ödül ekranı
class achievementScreen extends StatefulWidget {
  @override
  _achievementScreenState createState() => _achievementScreenState();
}

class _achievementScreenState extends State<achievementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF272837),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(FirebaseAuth.instance.currentUser.uid)
              .snapshots(),
          builder: (context, veriAl) {
            var veri = veriAl.data.docs;
            return ListView.builder(
                padding: EdgeInsets.all(8.0),
                itemCount: veri.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(veri[index]["kullanıcıAdi"],
                              style: TextStyle(fontSize: 15)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(veri[index]["elo"].toString(),
                              style: TextStyle(fontSize: 15)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(veri[index]["süre"].toString(),
                              style: TextStyle(fontSize: 15)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(veri[index]["totalScore"].toString(),
                              style: TextStyle(fontSize: 15)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(veri[index]["tarih"].toString(),
                              style: TextStyle(fontSize: 15)),
                        )
                      ],
                    ),
                  );
                });
          }),
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
    return Container();
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
    return Scaffold(
      backgroundColor: Color(0xFF272837),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              controller: adc,
              decoration: const InputDecoration(
                labelText: "Kullanıcı adını giriniz",
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white)),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFFFFFFF),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              controller: nickc,
              decoration: const InputDecoration(
                labelText: "Kullanıcı nick giriniz",
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white)),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFFFFFFF),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              style: TextStyle(color: Colors.white),
              controller: sifrec,
              decoration: const InputDecoration(
                labelText: "Kullanıcı şifre giriniz",
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white)),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFFFFFFF),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                {
                  _authService.guncelle(sifrec.text, nickc.text, adc.text);
                }
              },
              style: ElevatedButton.styleFrom(
                  primary: Color(0xFF2F80ED),
                  fixedSize: Size(250, 60),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))),
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
          )
        ],
      ),
    );
  }
}
