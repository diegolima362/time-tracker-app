import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_tracker_app/app/home/models/job.dart';
import 'package:time_tracker_app/common_widgets/platform_alert_dialog.dart';
import 'package:time_tracker_app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:time_tracker_app/services/database.dart';

class EditJobPage extends StatefulWidget {
  final Database database;
  final Job job;

  const EditJobPage({Key key, @required this.database, this.job})
      : super(key: key);

  static Future<void> show(
    BuildContext context, {
    Database database,
    Job job,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditJobPage(
          database: database,
          job: job,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();

  String _name;
  int _ratePerHour;

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job.name;
      _ratePerHour = widget.job.ratePerHour;
    }
  }

  bool _validateAmdSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _submit() async {
    if (_validateAmdSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((e) => e.name).toList();

        if (widget.job != null) {
          allNames.remove(widget.job.name);
        }

        if (allNames.contains(_name.trim())) {
          PlatformAlertDialog(
            title: 'Name already used',
            content: 'Please chose a different job name',
            defaultActionText: 'OK',
          ).show(context);
        } else {
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          final job =
              Job(id: id, name: _name.trim(), ratePerHour: _ratePerHour);
          await widget.database.setJob(job);
          Navigator.of(context).pop();
        }
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job == null ? 'New Job' : 'Edit Job'),
        actions: [
          FlatButton(
            child: Text(
              'Save',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: _submit,
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Job name'),
        initialValue: _name,
        onSaved: (value) => _name = value,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Rate per hour'),
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
        onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
        validator: (value) => value.isNotEmpty && int.tryParse(value) != null
            ? null
            : 'Invalid or empty input',
      ),
    ];
  }
}
