import 'package:flutter_test/flutter_test.dart';
import 'package:hisabkitab/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('basic test', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    expect(find.text('Hisab Kitab'), findsOneWidget);
  });
}
