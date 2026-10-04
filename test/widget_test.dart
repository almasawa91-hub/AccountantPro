import 'package:flutter_test/flutter_test.dart';
import 'package:accountant_pro/main.dart';

void main() {
  testWidgets('AccountantPro home screen loads', (tester) async {
    await tester.pumpWidget(const AccountantProApp());
    expect(find.text('المحاسب برو'), findsWidgets);
    expect(find.text('المبيعات'), findsOneWidget);
  });
}
