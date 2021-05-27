import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;


class NotificationPage extends StatefulWidget {

  final String value;
  
  NotificationPage({Key key, this.value}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String selectedNotificationPayload;
  
 _showNotification() async {

    WidgetsFlutterBinding.ensureInitialized();

    await _configureLocalTimeZone();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'channel id', 'channel name', 'channel description',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false);
    
    const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
    
   await flutterLocalNotificationsPlugin.schedule(
      1, 'Time to take medicine', '${widget.value.split(' ')[0]} has to be taken ${widget.value.split(' ')[1]} for ${widget.value.split(' ')[2]}', _nextInstanceOfTenAM(1, new Duration(seconds: 1)), platformChannelSpecifics, payload: 'anything');

    await flutterLocalNotificationsPlugin.schedule(
      2, 'Time to take medicine', '${widget.value.split(' ')[0]} has to be taken ${widget.value.split(' ')[1]} for ${widget.value.split(' ')[2]}', _nextInstanceOfTenAM(2, new Duration(seconds: 1)), platformChannelSpecifics, payload: 'anything');
  
  }

  tz.TZDateTime _nextInstanceOfTenAM(int hour, Duration duration) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(duration);
    }
    return scheduledDate;
  }

  Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

  @override
  void initState() {
    const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    
    this.flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    this.flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
        if(payload != null){
          debugPrint('notification payload: $payload');
        }
        selectedNotificationPayload = payload;
    });
    super.initState();
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
          SizedBox(height: 30.0),
          ElevatedButton(
            onPressed: _showNotification,
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
          width: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.black),
              left: BorderSide(color: Colors.black),
              right: BorderSide(color: Colors.black),
              bottom: BorderSide(color: Colors.black),
            ),
          ),
          child: Center(child: Text(body, style: TextStyle(color: Colors.black))),
        ),
      ],
    );
  }
}
