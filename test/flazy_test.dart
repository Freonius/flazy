import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flazy/flazy.dart';

Future<void> mockOnClick() async {
  return;
}

void main() {
  testWidgets('MainButton renders correctly', (WidgetTester tester) async {
    // Build the MainButton widget
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: MainButton(
            'Button Text',
            onClick: mockOnClick,
          ),
        ),
      ),
    );

    // Verify that the MainButton renders correctly
    expect(find.text('Button Text'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('MainButton calls onClick callback when tapped',
      (WidgetTester tester) async {
    // Create a mock onClick callback
    bool onClickCalled = false;
    Future<void> onClick() async {
      onClickCalled = true;
    }

    // Build the MainButton widget with the mock onClick callback
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MainButton(
            'Button Text',
            onClick: onClick,
          ),
        ),
      ),
    );

    // Tap the MainButton
    await tester.tap(find.text('Button Text'));
    await tester.pump();

    // Verify that the onClick callback was called
    expect(onClickCalled, true);
  });
}
