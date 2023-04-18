import 'dart:convert';
import 'package:csv_upload/Screens/accounts_screen.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class CsvScreen extends StatefulWidget {
  const CsvScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CsvScreenState createState() => _CsvScreenState();
}

class _CsvScreenState extends State<CsvScreen> {
  List<List<dynamic>> _tableData = [];
  late Uint8List file;
  late String? fileName;
  Uint8List? fileBytes;
  bool isButtonEnabled = false;

  void _loadCSVData(String csvData) {
    List<List<dynamic>> csvTable = const CsvToListConverter().convert(csvData);
    setState(() {
      _tableData = csvTable;
    });
  }

  Future<Map<String, dynamic>> uploadCsvFile(
      Uint8List fileBytes, String? fileName) async {
    var request = http.MultipartRequest('POST',
        Uri.parse('https://dev-wcf-api.edifyai.com/api/accounts/uploads'));
    request.files.add(
        http.MultipartFile.fromBytes('file', fileBytes, filename: fileName));
    var response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> jsonMap = json.decode(responseBody);
      return jsonMap;
    } else {
      throw Exception('Error uploading file');
    }
  }

  Future<void> _openFileExplorer() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      fileBytes = result.files.single.bytes;
      fileName = result.files.single.name;
      PlatformFile file = result.files.first;
      String csvData = String.fromCharCodes(file.bytes!);
      _loadCSVData(csvData);
      isButtonEnabled = true;
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CSV Upload'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _csvTableData(_tableData),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: isButtonEnabled
                  ? () {
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AccountsScreen(
                                    jsonMap:
                                        uploadCsvFile(fileBytes!, fileName))));
                      });
                    }
                  : null,
              child: const Text('Send Data to API'),
            )
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'uploadCSV',
            onPressed: _openFileExplorer,
            tooltip: 'Upload CSV',
            child: const Icon(Icons.upload_file),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'clearTable',
            onPressed: () {
              setState(() {
                _tableData = [];
                isButtonEnabled = false;
              });
            },
            tooltip: 'Clear Table',
            child: const Icon(Icons.clear),
          ),
        ],
      ),
    );
  }

  Widget _csvTableData(List<dynamic> tableData) {
    return Table(
      border: TableBorder.all(color: Colors.grey),
      columnWidths: const <int, TableColumnWidth>{
        0: FixedColumnWidth(180),
        1: FixedColumnWidth(180),
        2: FixedColumnWidth(180),
        3: FixedColumnWidth(180),
        4: FixedColumnWidth(180),
        5: FixedColumnWidth(180),
        6: FixedColumnWidth(180),
        7: FixedColumnWidth(180),
        8: FixedColumnWidth(180),
        9: FixedColumnWidth(180),
      },
      children: [
        ...tableData.asMap().entries.map((entry) {
          int index = entry.key;
          List<dynamic> rowData = entry.value;

          return TableRow(
            decoration: BoxDecoration(
              color: index == 0 ? const Color.fromARGB(255, 207, 207, 207) : null,
            ),
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${rowData[0]}'),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${rowData[1]}'),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${rowData[2]}'),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${rowData[3]}'),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${rowData[4]}'),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${rowData[5]}'),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${rowData[6]}'),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${rowData[7]}'),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${rowData[8]}'),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${rowData[9]}'),
                ),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }
}