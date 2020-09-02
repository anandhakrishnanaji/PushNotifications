import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _message;
  WebSocketChannel channel;
  bool _iserror = false;
  var sub;
  String text;

  @override
  void initState() {
    super.initState();
    FlutterLocalNotificationsPlugin notifications =
        new FlutterLocalNotificationsPlugin();
    var androidInit = AndroidInitializationSettings('ic_android_black_24dp');
    var iOSInit = IOSInitializationSettings();
    channel = IOWebSocketChannel.connect('ws://192.168.1.22:8000/ws/notify/');
    _message = new TextEditingController();
    var init = InitializationSettings(androidInit, iOSInit);
    notifications.initialize(init).then((done) {
      sub = channel.stream.listen((newData) {
        text = json.decode(newData)['message'];
        notifications.show(
            0,
            "New announcement",
            text,
            NotificationDetails(
                AndroidNotificationDetails(
                    "announcement_app_0", "Announcement App", ""),
                IOSNotificationDetails()));
      });
    });
  }

  @override
  void dispose() {
    _iserror = false;
    _message.dispose();
    channel.sink.close(status.goingAway);
    sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Container(
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _message,
              autofocus: false,
              decoration: InputDecoration(
                hintText: 'Type your Message',
                errorText: _iserror ? 'Textfield is empty!' : null,
                contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: OutlineInputBorder(),
              ),
            ),
            IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  setState(() {
                    _message.text.isEmpty ? _iserror = true : _iserror = false;
                  });
                  if (!_iserror)
                    channel.sink.add(jsonEncode({'message': _message.text}));
                })
          ],
        ),
      ),
    );
  }
}
