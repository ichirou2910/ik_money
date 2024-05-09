import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ik_app/services/transaction_service.dart';
import 'package:ik_app/theme/theme_config.dart';
import 'package:ik_app/views/accounting/accounting_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => TransactionService()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: GoRouter(routes: [
        // TODO: change back to main screen
        GoRoute(path: '/', builder: (ctx, state) => const AccountingScreen()),
        GoRoute(
            path: '/accounting',
            builder: (ctx, state) => const AccountingScreen())
      ]),
      themeMode: ThemeMode.system,
      theme: themeData(ThemeConfig.lightTheme),
      darkTheme: themeData(ThemeConfig.darkTheme),
    );
  }

  ThemeData themeData(ThemeData theme) {
    return theme.copyWith(
      textTheme: GoogleFonts.sourceSans3TextTheme(
        theme.textTheme,
      ),
    );
  }
}
