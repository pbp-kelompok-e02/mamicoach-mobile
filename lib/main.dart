import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mamicoach_mobile/constants/colors.dart';
import 'package:mamicoach_mobile/screens/splash_screen.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:mamicoach_mobile/features/admin/providers/admin_provider.dart';
import 'package:mamicoach_mobile/providers/user_provider.dart';
import 'package:mamicoach_mobile/features/admin/providers/booking_provider.dart'
    as booking_p;
import 'package:mamicoach_mobile/features/admin/providers/payment_provider.dart'
    as payment_p;
import 'package:mamicoach_mobile/features/admin/providers/user_provider.dart'
    as admin_user_p;
import 'package:mamicoach_mobile/features/admin/providers/coach_provider.dart';
import 'package:mamicoach_mobile/core/network/auth_cookie_request.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Load user data from SharedPreferences on app start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).loadUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // CookieRequest provider for API calls
        Provider<CookieRequest>(create: (_) => AuthCookieRequest(navigatorKey)),
        // User provider
        ChangeNotifierProvider(create: (_) => UserProvider()),
        // Admin providers
        ChangeNotifierProvider(create: (_) => AdminAuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => booking_p.BookingProvider()),
        ChangeNotifierProvider(create: (_) => payment_p.PaymentProvider()),
        ChangeNotifierProvider(create: (_) => admin_user_p.UserProvider()),
        ChangeNotifierProvider(create: (_) => CoachProvider()),
      ],
      child: MaterialApp(
        title: 'MamiCoach',
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primaryGreen,
            primary: AppColors.primaryGreen,
            secondary: AppColors.coralRed,
            surface: AppColors.white,
            background: AppColors.white,
          ),
          scaffoldBackgroundColor: AppColors.white,
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          useMaterial3: true,
          fontFamily: 'Quicksand',
          textTheme: TextTheme(
            headlineLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              fontFamily: 'Quicksand',
              color: AppColors.black,
            ),
            headlineMedium: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Quicksand',
              color: AppColors.black,
            ),
            bodyLarge: TextStyle(
              fontSize: 16,
              fontFamily: 'Quicksand',
              color: AppColors.black,
            ),
            bodyMedium: TextStyle(
              fontSize: 14,
              fontFamily: 'Quicksand',
              color: AppColors.grey,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: AppColors.coralRed,
            foregroundColor: Colors.white,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
