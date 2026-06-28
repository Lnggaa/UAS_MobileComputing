import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/journal.dart';
import 'models/user.dart';
import 'providers/journal_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/onboarding_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/add_journal_screen.dart';
import 'screens/detail_journal_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(JournalAdapter());
  Hive.registerAdapter(UserAdapter());

  // Open boxes
  await Hive.openBox<Journal>(AppBoxes.journals);
  await Hive.openBox<User>(AppUserBoxes.users);
  await Hive.openBox(AppUserBoxes.session);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..init()),
        ChangeNotifierProvider(create: (_) => JournalProvider()..init()),
      ],
      child: const TravelJournalApp(),
    ),
  );
}

class TravelJournalApp extends StatelessWidget {
  const TravelJournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AuthGate(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/add-journal': (context) => const AddJournalScreen(),
        '/stats': (context) => const StatsScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail-journal') {
          final journalId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => DetailJournalScreen(journalId: journalId),
          );
        }
        if (settings.name == '/edit-journal') {
          final journalId = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => AddJournalScreen(journalId: journalId),
          );
        }
        return null;
      },
    );
  }
}

// Widget penentu halaman awal
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (!auth.isLoggedIn) {
      // Belum login → cek ada akun atau belum
      if (auth.hasAccount) {
        return const LoginScreen();
      } else {
        return const RegisterScreen();
      }
    }

    // Sudah login → cek onboarding
    final user = auth.currentUser!;
    if (!user.hasSeenOnboarding) {
      return const OnboardingScreen();
    }

    return const DashboardScreen();
  }
}
