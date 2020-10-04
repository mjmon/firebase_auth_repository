import 'package:firebase_auth_repository/src/models/index.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('User', () {
    const id = 'mock-id';
    const email = 'mock-email';

    test('throws AssertionError when email is null', () {
      expect(() => User(id: id, email: null, name: null, photo: null),
          throwsAssertionError);
    });

    test('throws AssertionError when id is null', () {
      expect(() => User(id: null, email: email, name: null, photo: null),
          throwsAssertionError);
    });

    test('uses value equality', () {
      expect(User(id: id, email: email, name: null, photo: null),
          User(id: id, email: email, name: null, photo: null));
    });
  });
}
