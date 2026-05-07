import 'package:flutter_test/flutter_test.dart';
import 'package:studyplan/main.dart';

void main() {
  testWidgets('App loads', (WidgetTester tester) async {
    await tester.pumpWidget(const StudyPlanApp());
    expect(find.text('Study'), findsOneWidget);
  });
}
