import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/app/sign_in/email_sign_in_form_stateful.dart';
import 'package:time_tracker_app/services/auth.dart';

import 'mocks.dart';

void main() {
  MockAuth mockAuth;
  setUp(() {
    mockAuth = MockAuth();
  });

  Future<void> pumpEmailSignInForm(WidgetTester tester,
      {VoidCallback onSignedIn}) async {
    await tester.pumpWidget(
      Provider<AuthBase>(
        create: (_) => mockAuth,
        child: MaterialApp(
          home: Scaffold(
            body: EmailSingInFormStateful(
              onSignedIn: onSignedIn,
            ),
          ),
        ),
      ),
    );
  }

  void stubSignInWithEmailAndPasswordSucceeds() {
    when(mockAuth.signInWithEmailAndPassword(any, any))
        .thenAnswer((_) => Future<User>.value(User(uid: '000')));
  }

  void stubSignInWithEmailAndPasswordThrows() {
    when(mockAuth.signInWithEmailAndPassword(any, any))
        .thenThrow(PlatformException(code: 'ERROR_WRONG_PASSWORD'));
  }

  group('sign in', () {
    testWidgets('no email and password try to sign in',
        (WidgetTester tester) async {
      var signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);

      final signInButton = find.text('Sign In');
      await tester.tap(signInButton);

      verifyNever(mockAuth.signInWithEmailAndPassword(any, any));
      expect(signedIn, false);
    });

    testWidgets('valid email and password try to sign in',
        (WidgetTester tester) async {
      var signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);

      stubSignInWithEmailAndPasswordSucceeds();

      const email = 'email@email.com';
      const password = 'password';

      final emailField = find.byKey(Key('email'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);

      final passwordField = find.byKey(Key('password'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, password);

      await tester.pump();

      final signInButton = find.text('Sign In');
      await tester.tap(signInButton);

      verify(mockAuth.signInWithEmailAndPassword(email, password)).called(1);
      expect(signedIn, true);
    });

    testWidgets('invalid email and password try to sign in',
        (WidgetTester tester) async {
      var signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: () => signedIn = true);

      stubSignInWithEmailAndPasswordThrows();

      const email = 'email@email.com';
      const password = 'password';

      final emailField = find.byKey(Key('email'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);

      final passwordField = find.byKey(Key('password'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, password);

      await tester.pump();

      final signInButton = find.text('Sign In');
      await tester.tap(signInButton);

      verify(mockAuth.signInWithEmailAndPassword(email, password)).called(1);
      expect(signedIn, false);
    });
  });

  group('register', () {
    testWidgets('toggle to register mode', (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);

      final registerButton = find.text('Need an account? Register');
      await tester.tap(registerButton);

      await tester.pump();

      final createAccountButton = find.text('Create an account');
      expect(createAccountButton, findsOneWidget);
    });

    testWidgets('email and password try to register',
        (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);

      final registerButton = find.text('Need an account? Register');
      await tester.tap(registerButton);

      await tester.pump();

      const email = 'email@email.com';
      const password = 'password';

      final emailField = find.byKey(Key('email'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);

      final passwordField = find.byKey(Key('password'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, password);

      await tester.pump();

      final createAccountButton = find.text('Create an account');
      expect(createAccountButton, findsOneWidget);
      await tester.tap(createAccountButton);

      verify(mockAuth.createUserWithEmailAndPassword(email, password))
          .called(1);
    });
  });
}
