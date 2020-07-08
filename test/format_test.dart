import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:time_tracker_app/app/home/job_entries/format.dart';

void main() {
  group('hours', () {
    test('positive', () {
      expect(Format.hours(10), '10h');
    });

    test('zero', () {
      expect(Format.hours(0), '0h');
    });

    test('negative', () {
      expect(Format.hours(-10), '0h');
    });

    test('decimal', () {
      expect(Format.hours(4.5), '4.5h');
    });
  });

  group('date - GB Locale', () {
    setUp(() async {
      Intl.defaultLocale = 'en_GB';
      await initializeDateFormatting(Intl.defaultLocale);
    });

    test('2020-07-08', () {
      expect(Format.date(DateTime(2020, 07, 08)), '8 Jul 2020');
    });
  });

  group('dayOfWeek - GB Locale', () {
    setUp(() async {
      Intl.defaultLocale = 'en_GB';
      await initializeDateFormatting(Intl.defaultLocale);
    });

    test('wednesday', () {
      expect(Format.dayOfWeek(DateTime(2020, 07, 08)), 'Wed');
    });
  });

  group('dayOfWeek - BR Locale', () {
    setUp(() async {
      Intl.defaultLocale = 'pt_BR';
      await initializeDateFormatting(Intl.defaultLocale);
    });

    test('quarta', () {
      expect(Format.dayOfWeek(DateTime(2020, 07, 08)), 'qua');
    });
  });

  group('currency - US locale', () {
    setUp(() {
      Intl.defaultLocale = 'en_US';
    });

    test('positive', () {
      expect(Format.currency(10), '\$10');
    });

    test('zero', () {
      expect(Format.currency(0), '');
    });

    test('negative', () {
      expect(Format.currency(-10), '-\$10');
    });
  });
}
