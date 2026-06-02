import 'package:flutter_test/flutter_test.dart';
import 'package:final_binome_mobile/main.dart';

void main() {
  testWidgets('App starts with Binome title', (tester) async {
    await tester.pumpWidget(const BinomeApp());
    expect(find.text('Binome'), findsOneWidget);
  });
}
