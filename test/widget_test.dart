import 'package:flutter_test/flutter_test.dart';
import 'package:flu2/main.dart';

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const SkinDiseaseApp());

    expect(find.text('Scan'), findsOneWidget);
  });
}
