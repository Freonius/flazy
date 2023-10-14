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

  testWidgets('MainButton is unclickable when callback is called',
      (WidgetTester tester) async {
    // Create a mock onClick callback
    int onClickCalled = 0;
    Future<void> onClick() async {
      onClickCalled++;
      await Future.delayed(const Duration(seconds: 2));
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
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.tap(find.byType(CircularProgressIndicator));
    await tester.pump();
    // Verify that the onClick callback was called
    expect(onClickCalled, 1);
    await tester.pump(const Duration(seconds: 2));
  });

  testWidgets('MainButton renders with the correct colors',
      (WidgetTester tester) async {
    const cc = ColorScheme(
      brightness: Brightness.light,
      primary: Colors.amber,
      onPrimary: Colors.teal,
      secondary: Colors.purple,
      onSecondary: Colors.pink,
      error: Colors.black,
      onError: Colors.black,
      background: Colors.amber,
      onBackground: Colors.teal,
      surface: Colors.amber,
      onSurface: Colors.teal,
    );
    // Build the MainButton widget
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData.from(colorScheme: cc),
        home: const Scaffold(
          body: MainButton(
            'Button Text',
            onClick: mockOnClick,
          ),
        ),
      ),
    );

    final textWidget = find.text(
      'Button Text',
    );
    final textStyle = tester.widget<Text>(textWidget).style;
    expect(textStyle, isNotNull);
    expect(textStyle!.color, equals(Colors.purple));
  });
}
