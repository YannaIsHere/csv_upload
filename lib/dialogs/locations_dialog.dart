import 'package:flutter/material.dart';
import 'package:csv_upload/widgets/locations_table.dart';

class LocationsDialog extends StatelessWidget {
  final Future<Map<String, dynamic>> jsonMap;

  const LocationsDialog({Key? key, required this.jsonMap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      elevation: 0,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: SingleChildScrollView(
              child: FutureBuilder(
                future: jsonMap,
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    final jsonData = snapshot.data!;
                    final data = jsonData['data']['locations'] as List<dynamic>;
                    return _locationsInformation(data);
                  } else if (snapshot.hasError) {
                    return Text('Error loading data: ${snapshot.error}');
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                }),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _locationsInformation(List<dynamic> data){
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
