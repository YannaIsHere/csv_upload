import 'package:flutter/material.dart';
import 'package:csv_upload/Widgets/locations_table.dart';

class LocationsScreen extends StatefulWidget {
  final Future<Map<String, dynamic>> jsonMap;
  const LocationsScreen({super.key, required this.jsonMap});

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
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
          child: const Text('Locations Page'),
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _jsonMap,
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              final jsonData = snapshot.data!;
              final data = jsonData['data']['locations'] as List<dynamic>;
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

  Widget _safetyConsultantsInformation(List<dynamic> data){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
            child: Text(
              'LOCATIONS TABLE',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          LocationsTable(
            rows: List.generate(
              data.length,
              (index) {
                final consultant = data[index] as Map<String, dynamic>;
                final id = consultant['_id'];
                final location = consultant['location'];

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
                        child: Center(child: Text(location)),
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
