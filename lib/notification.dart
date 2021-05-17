import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationPage extends StatefulWidget {

  final String value;
  
  NotificationPage({Key key, this.value}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  String selectedNotificationPayload;

  notification() async {

    const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        if(payload != null){
          debugPrint('notification payload: $payload');
        }
        selectedNotificationPayload = payload;
    });

    //Execute Notification  
    await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'scheduled title',
    'scheduled body',
    tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
    const NotificationDetails(
        android: AndroidNotificationDetails('your channel id',
            'your channel name', 'your channel description')),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
    await flutterLocalNotificationsPlugin.show(0, 'Notification title', 'body', null, payload: 'item x');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Page', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _column("Medicine Name", "${widget.value.split(' ')[0]}"),
              _column("Time to take", "${widget.value.split(' ')[1]}"),
              _column("Days to take", "${widget.value.split(' ')[2]}"),
            ],
          ),
          ElevatedButton(
            onPressed: (){
              notification();
            }, 
            child: Container(
              height: 60,
              width: 200,
              child: Center(child: Text('Set as notification')),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.orange),
            ),
          ),
        ],
      ),
    );
  }

  Widget _column(String title, String body){
    return Column(
      children: [
        Text(title, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        SizedBox(height: 5.0),
        Container(
          height: 50,
          width: 80,
          color: Colors.white,
          child: Text(body, style: TextStyle(color: Colors.black)),
        ),
      ],
    );
  }
}