import 'package:flutter/foundation.dart';
import 'package:time_tracker_app/app/home/models/job.dart';
import 'package:time_tracker_app/services/api_path.dart';
import 'package:time_tracker_app/services/firestore_service.dart';

abstract class Database {
  Future<void> createJob(Job job);

  Stream<List<Job>> jobsStream();
}

class FirestoreDatabase implements Database {
  final String uid;

  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final _service = FirestoreService.instance;

  Future<void> createJob(Job job) async => await _service.setData(
        path: APIPath.job(uid, 'job_abc'),
        data: job.toMap(),
      );

  Stream<List<Job>> jobsStream() => _service.collectionStream(
        path: APIPath.jobs(uid),
        builder: (data) => Job.fromMap(data),
      );
}
