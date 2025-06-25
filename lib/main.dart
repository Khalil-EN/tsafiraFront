import 'package:flutter/material.dart';
import 'package:table_calendar_example/FirstPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'providers/plan_provider.dart'; // Import the provider
//import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure all bindings are initialized
  //MobileAds.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Use the generated options
  );
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => PlanProvider()),
          ],
          child: MyApp()));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Tsafira(),

    );
  }
}

// Hotel : Search hotel - Gethoteldetails - (SelectRoom (reserver?))!! - (getters  -> attributes)
// Restaurant : SearchRestaurant - Getdetails - select! - (getters  -> attributes)
// Activities : searchActivities - getDetails - getActivitiesVisitedbyFriends - (getters-> attributes) ...
// Plans : getMostbookedPlan - generatePlan - createPlan (getters and setters -> attributes)
// User : updateProfile - verifyEmail(sms) - savePlan - payment!!?? - getHistory - logout - authenticate - getSupport - (getters and setters -> attributes)