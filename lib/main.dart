import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../services/transaction_group_service.dart';
import '../services/transaction_service.dart';
import '../theme/theme_config.dart';
import '../views/main_screen.dart';
import '../views/transaction/transaction_detail.dart';
import '../views/transaction/transaction_preview.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => TransactionService()),
      ChangeNotifierProvider(create: (_) => TransactionGroupService()),
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
        GoRoute(
          path: '/',
          builder: (ctx, state) => const MainScreen(),
        ),
        GoRoute(
            path: '/transaction-edit/:transactionId',
            builder: (ctx, state) => TransactionDetailView(
                  transactionId: state.pathParameters['transactionId'] ?? "0",
                )),
        GoRoute(
            path: '/transaction/:transactionId',
            builder: (ctx, state) => TransactionPreviewView(
                  transactionId: state.pathParameters['transactionId'] ?? "0",
                )),
        // GoRoute(
        //     path: '/transaction-group-edit/:transactionGroupId',
        //     builder: (ctx, state) => TransactionPreviewView(
        //           transactionId:
        //               state.pathParameters['transactionGroupId'] ?? "0",
        //         )),
        // GoRoute(
        //     path: '/transaction-group/:transactionGroupId',
        //     builder: (ctx, state) => TransactionPreviewView(
        //           transactionId:
        //               state.pathParameters['transactionGroupId'] ?? "0",
        //         )),
        // GoRoute(
        //     path: '/transaction-label',
        //     builder: (ctx, state) => TransactionPreviewView(
        //           transactionId: state.pathParameters['transactionId'] ?? "0",
        //         )),
        // GoRoute(
        //     path: '/transaction-label/:transactionLabelId',
        //     builder: (ctx, state) => TransactionPreviewView(
        //           transactionId: state.pathParameters['transactionId'] ?? "0",
        //         )),
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
