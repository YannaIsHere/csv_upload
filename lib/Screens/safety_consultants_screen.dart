import 'package:flutter/material.dart';
import 'package:csv_upload/Widgets/safety_consultants_table.dart';

class SafetyConsultantsScreen extends StatefulWidget {
  final Future<Map<String, dynamic>> jsonMap;
  const SafetyConsultantsScreen({super.key, required this.jsonMap});

  @override
  State<SafetyConsultantsScreen> createState() =>
      _SafetyConsultantsScreenState();
}

class _SafetyConsultantsScreenState extends State<SafetyConsultantsScreen> {
  late final Future<Map<String, dynamic>> _jsonMap;

  @override
  void initState() {
    _jsonMap = widget.jsonMap;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(
          color: Colors.blue,
          child: const Text('Safety Consultants Page'),
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _jsonMap,
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              final jsonData = snapshot.data!;
              final data =
                  jsonData['data']['safetyConsultants'] as List<dynamic>;
              return _safetyConsultantsInformation(data);
            } else if (snapshot.hasError) {
              return Text('Error loading data: ${snapshot.error}');
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
        ),
      ),
    );
  }

  Widget _safetyConsultantsInformation(List<dynamic> data) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
            child: Text(
              'SAFETY CONSULTANTS TABLE',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SafetyConsultantsTable(
            rows: List.generate(
              data.length,
              (index) {
                final consultant = data[index] as Map<String, dynamic>;
                final id = consultant['_id'];
                final firstName = consultant['firstName'];
                final lastName = consultant['lastName'];
                final email = consultant['role'];

                return TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text(id)),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text(firstName)),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text(lastName)),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: Text(email)),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
