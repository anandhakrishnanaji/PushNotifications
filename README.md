# push_notification_app

Flutter app that implements Push Notifications with Django Channels using websocket protocol.Uses Libraries flutter_local_notifications and web_socket_channel.

## Getting Started

### Setup Django Locally

#### Requirements
* Django==3.0.7
* channels==2.4.0
* channels-redis==2.4.2
* djangorestframework==3.11.0
* Install Redis
* Run ``ifconfig`` and obtain IP_ADDRESS
* Run ``python3 manage.py runserver [IP_ADDRESS]:8000``

### Setup Flutter app

#### Requirements
* Flutter 1.17.5
* Change the URL inside main.dart to ws://[IP_ADDRESS]:8000/ws/notify/
* Connect the device and the system to a single network.
* Run ``flutter run``

## Libraries used in Flutter

* [Web Socket Channel](https://pub.dev/packages/web_socket_channel)
* [Flutter Local Notification](https://pub.dev/packages/flutter_local_notifications)

### Web Socket Channel
Web Socket Channel library is a flutter library that helps in creating a websocket connection with a server. Websockets helps in retaining the connection unlike a http request which also helps in 2 way communication, by which the server sends the message to the client. It provides a StreamChannel wrapper for websocket connections. In the app I've used a StreamSubscription to listen to messages from server.

### Flutter Local Notifications
Flutter Local Notification is a flutter library that helps in making push notifications available to a flutter app.When a message is recieved from the server, it notifies by displaying a push notification with vibration and sound.The push notification is available even when the app is in background.
