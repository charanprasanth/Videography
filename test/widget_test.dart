import 'package:flutter_test/flutter_test.dart';
import 'package:videography/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const VideographyApp());
    expect(find.byType(VideographyApp), findsOneWidget);
  });
}
