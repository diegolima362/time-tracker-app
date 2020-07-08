import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_app/app/home/models/job.dart';

void main() {
  group('fromMap', () {
    test('null data', () {
      final job = Job.fromMap(null, '000');
      expect(job, null);
    });

    test('job with all properties', () {
      final job = Job.fromMap({
        'name': 'Coding',
        'ratePerHour': 10,
      }, '000');
      expect(job, Job(id: '000', name: 'Coding', ratePerHour: 10));
    });

    test('missing name', () {
      final job = Job.fromMap({
        'ratePerHour': 10,
      }, '000');
      expect(job, null);
    });
  });

  group('toMap', () {
    test('valid name, ratePerHour', () {
      final job = Job(name: 'Coding', ratePerHour: 10, id: '000');
      expect(job.toMap(), {
        'name': 'Coding',
        'ratePerHour': 10,
      });
    });
  });
}
