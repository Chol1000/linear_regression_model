import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/main.dart';

void main() {
  testWidgets('Salary prediction app loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const SalaryPredictionApp());
    
    expect(find.text('Graduate Salary Predictor'), findsOneWidget);
    expect(find.text('International Graduates Employment Prediction'), findsOneWidget);
    expect(find.text('Predict Salary'), findsOneWidget);
  });
}
