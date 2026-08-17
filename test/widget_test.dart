import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Static truth test', () {
    expect(true, isTrue);
  });

  test('Basic arithmetic test', () {
    expect(2 + 2, equals(4));
  });

  test('String test', () {
    const appName = 'Keep Notes';
    expect(appName, isNotEmpty);
    expect(appName, equals('Keep Notes'));
  });
}