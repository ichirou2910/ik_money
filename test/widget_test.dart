// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:ik_money/main.dart';
import 'package:ik_money/services/transaction_group_service.dart';
import 'package:ik_money/services/transaction_service.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Main function initialization', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TransactionService()),
        ChangeNotifierProvider(create: (_) => TransactionGroupService()),
      ],
      builder: (context, child) {
        return const MyApp();
      },
    ));

    // Verify the app launches with the expected initial widget
    expect(find.byType(MyApp), findsOneWidget);
  });
}
