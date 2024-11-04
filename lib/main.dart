import 'package:chatty/common/routes/routes.dart';
import 'package:chatty/common/style/style.dart';
import 'package:chatty/common/utils/FirebaseMassagingHandler.dart';
import 'package:chatty/init_dependencies.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  await InitDependencies.init();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(
    DevicePreview(
      // White background looks professional in website embedding
      backgroundColor: Colors.white,

      // Enable preview by default for web demo
      enabled: true,

      // Start with Galaxy A50 as it's a common Android device
      defaultDevice: Devices.ios.iPhone13ProMax,

      // Show toolbar to let users test different devices
      isToolbarVisible: true,

      // Keep English only to avoid confusion in demos
      availableLocales: [Locale('en', 'US')],

      // Customize preview controls
      tools: const [
        // Device selection controls
        DeviceSection(
          model: true, // Option to change device model to fit your needs
          orientation: false, // Lock to portrait for consistent demo
          frameVisibility: false, // Hide frame options
          virtualKeyboard: false, // Hide keyboard
        ),

        // Theme switching section
        // SystemSection(
        //   locale: false, // Hide language options - we're keeping it English only
        //   theme: false, // Show theme switcher if your app has dark/light modes
        // ),

        // Disable accessibility for demo simplicity
        // AccessibilitySection(
        //   boldText: false,
        //   invertColors: false,
        //   textScalingFactor: false,
        //   accessibleNavigation: false,
        // ),

        // Hide extra settings to keep demo focused
        // SettingsSection(
        //   backgroundTheme: false,
        //   toolsTheme: false,
        // ),
      ],

      // Curated list of devices for comprehensive preview
      devices: [
        // ... Devices.all, // uncomment to see all devices

        // Popular Android Devices
        Devices.android.samsungGalaxyA50, // Mid-range
        Devices.android.samsungGalaxyNote20, // Large screen
        Devices.android.samsungGalaxyS20, // Flagship
        Devices.android.samsungGalaxyNote20Ultra, // Premium
        Devices.android.onePlus8Pro, // Different aspect ratio
        Devices.android.sonyXperia1II, // Tall screen

        // Popular iOS Devices
        Devices.ios.iPhoneSE, // Small screen
        Devices.ios.iPhone12, // Standard size
        Devices.ios.iPhone12Mini, // Compact
        Devices.ios.iPhone12ProMax, // Large
        Devices.ios.iPhone13, // Latest standard
        Devices.ios.iPhone13ProMax, // Latest large
        Devices.ios.iPhone13Mini, // Latest compact
        Devices.ios.iPhoneSE, // Budget option
      ],
      builder: (context) => const MyApp(),
    ),
  );
  
  firebaseChatInit().whenComplete(() => FirebaseMessagingHandler.config());
}

Future<void> firebaseChatInit() async {
  FirebaseMessaging.onBackgroundMessage(
      FirebaseMessagingHandler.firebaseMessagingBackground);

  if (GetPlatform.isAndroid) {
    FirebaseMessagingHandler.flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .createNotificationChannel(FirebaseMessagingHandler.channel_call);

    FirebaseMessagingHandler.flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()!
        .createNotificationChannel(FirebaseMessagingHandler.channel_message);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 780),
      builder: (context, child) => GetMaterialApp(
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: AppTheme.light,
        initialRoute: AppRoutes.INITIAL,
        getPages: AppPages.routes,
      ),
    );
  }
}
