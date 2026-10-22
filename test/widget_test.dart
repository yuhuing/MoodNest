import 'package:flutter_test/flutter_test.dart';

import 'package:moodnest/main.dart';

void main() {
  testWidgets('Home screen shows the app name and features', (tester) async {
    await tester.pumpWidget(const MoodNestApp());

    expect(find.text('MoodNest'), findsOneWidget);
    expect(find.text('Chat'), findsOneWidget);
    expect(find.text('Diary'), findsOneWidget);
  });
}
