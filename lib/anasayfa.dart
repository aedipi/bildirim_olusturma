import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart'as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class Anasayfa extends StatefulWidget {
  const Anasayfa({Key? key}) : super(key: key);

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  var flp = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    kurulum();
  }

  Future<void> kurulum() async {
    var androidAyari = AndroidInitializationSettings("@mipmap/ic_launcher");
    var iosAyari = IOSInitializationSettings();
    var kurulumAyari = InitializationSettings(android: androidAyari, iOS: iosAyari);
    await flp.initialize(kurulumAyari,onSelectNotification: bildirimSecilme);
  }

  Future<void> bildirimSecilme(String? payLoad) async {
    if(payLoad!=null){
      print("Bildirim seçildi : $payLoad");
    }
  }

  Future<void> bildirimGoster() async {
    var androidBildirimDetayi = AndroidNotificationDetails("id", "name",channelDescription: "aciklama",
        priority: Priority.high,importance: Importance.max);
    var iosBildirimDetayi = IOSNotificationDetails();
    var bildirimDetayi = NotificationDetails(android: androidBildirimDetayi,iOS: iosBildirimDetayi);
    await flp.show(0, "Başlık", "İçerik", bildirimDetayi,payload: "Payload içerik");
  }
  Future<void> bildirimGosterGecikmeli() async {
    var androidBildirimDetayi = AndroidNotificationDetails("id", "name",channelDescription: "aciklama",
        priority: Priority.high,importance: Importance.max);
    var iosBildirimDetayi = IOSNotificationDetails();
    var bildirimDetayi = NotificationDetails(android: androidBildirimDetayi,iOS: iosBildirimDetayi);
    tz.initializeTimeZones();
    var gecikme = tz.TZDateTime.now(tz.local).add(Duration(seconds: 10));
    await flp.zonedSchedule(0, "Başlık", "İçerik",gecikme, bildirimDetayi,payload: "Payload içerik",
      androidAllowWhileIdle: true,uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bildirim Merkezi"),),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(onPressed: (){
              bildirimGoster();
            }, child: const Text("Bildirim Oluştur")),
            ElevatedButton(onPressed: (){
              bildirimGosterGecikmeli();
            }, child: const Text("Bildirim Oluştur ( Gecikmeli )")),
          ],
        ),
      ),
    );
  }
}
