import 'package:flutter_test/flutter_test.dart';
import 'package:refocus/main.dart';
import 'package:refocus/models/app_state.dart';

void main() {
  testWidgets('ReFocus app splash screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      AppStateProvider(
        notifier: AppState(),
        child: const ReFocusApp(),
      ),
    );

    // Verify that the subtitle is found on the splash screen
    expect(find.text('Reclaim Your Focus,\nLive Better'), findsOneWidget);
  });
}
