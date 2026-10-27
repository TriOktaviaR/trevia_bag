
import 'package:flutter_test/flutter_test.dart';
import 'package:trevia_bag/main.dart';

void main() {
  testWidgets('Trevia Bag app dapat dibuka', (WidgetTester tester) async {
    await tester.pumpWidget(const TreviaBagApp());

    expect(find.byType(TreviaBagApp), findsOneWidget);
  });
}
