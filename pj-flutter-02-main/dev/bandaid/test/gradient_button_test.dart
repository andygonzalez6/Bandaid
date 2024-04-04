import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:bandaid/components/gradient_button.dart';

void main() {
  testWidgets('GradientButton should render correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      ResponsiveSizer(
        builder: (context, orientation, screenType) {
          return MaterialApp(
            home: Scaffold(
              body: GradientButton(
                text: 'Test Button',
                onPressed: () {},
              ),
            ),
          );
        },
      ),
    );

    // Verify that the button text is rendered.
    expect(find.text('Test Button'), findsOneWidget);

    // Verify that the button has the correct gradient colors.
    expect(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is DecoratedBox &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).gradient is LinearGradient &&
            (widget.decoration as BoxDecoration).gradient!.colors[0] == Color(0xff4338CA) &&
            (widget.decoration as BoxDecoration).gradient!.colors[1] == Color(0xff6D28D9),
      ),
      findsOneWidget,
    );

    // Verify that the button has the correct elevation.
    expect(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is ElevatedButton &&
            widget.style?.elevation?.resolve({}) == 0,
      ),
      findsOneWidget,
    );

    // Tap the button and trigger onPressed.
    await tester.tap(find.text('Test Button'));
    await tester.pump();

  });
}

// The test covers rendering, gradient colors, elevation, and interaction of the GradientButton. 
// It ensures that the button is rendered correctly with the expected properties and behavior.