import "package:firebase_core/firebase_core.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/foundation.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:sasat_toko/api/api_manager.dart";
import "package:shared_preferences/shared_preferences.dart";

class FirebaseNotification {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    await Firebase.initializeApp();

    // Setup notification channels
    await _setupNotificationChannels();

    // Request permissions
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (kDebugMode) {
      print("Notification permissions: ${settings.authorizationStatus}");
    }

    // Initialize local notifications
    await _initLocalNotifications();

    // Setup message handlers
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Setup token refresh listener
    FirebaseMessaging.instance.onTokenRefresh.listen(_handleTokenRefresh);
  }

  static Future<bool> updateFcmToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) {
        if (kDebugMode) {
          print("FCM token is null");
        }
        return false;
      }

      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString("auth_token") == null) {
        if (kDebugMode) {
          print("No auth token available");
        }
        return false;
      }

      final response = await ApiManager.updateFcmToken(token);
      if (kDebugMode) {
        print("FCM token updated: $token");
      }
      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print("Error updating FCM token: $e");
      }
      return false;
    }
  }

  static Future<void> _setupNotificationChannels() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      "your_channel_id",
      "Your Channel Name",
      importance: Importance.max,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> _initLocalNotifications() async {
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: DarwinInitializationSettings(),
    );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    if (kDebugMode) {
      print("Foreground message: ${message.notification?.title}");
    }
    await _showNotification(message);
  }

  static Future<void> _showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      "your_channel_id",
      "Your Channel Name",
      importance: Importance.max,
      priority: Priority.high,
    );

    await _notificationsPlugin.show(
      0,
      message.notification?.title ?? "New Notification",
      message.notification?.body ?? "No message content",
      const NotificationDetails(android: androidDetails),
    );
  }

  static Future<void> _handleTokenRefresh(String newToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString("auth_token") != null) {
        await ApiManager.updateFcmToken(newToken);
        if (kDebugMode) {
          print("Refreshed FCM token: $newToken");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error refreshing token: $e");
      }
    }
  }

  @pragma("vm:entry-point")
  static Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    await Firebase.initializeApp();
    await _showNotification(message);
  }
}
