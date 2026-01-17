import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:game_assessment/data/game_local_data_source.dart';
import 'package:game_assessment/main.dart';

void main() {
  testWidgets('App loads with Tic Tac Toe title', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final dataSource = GameLocalDataSource(prefs);

    await tester.pumpWidget(MyApp(dataSource: dataSource));
    await tester.pumpAndSettle();

    expect(find.text('Tic Tac Toe'), findsOneWidget);
  });
}
