import 'package:csv_upload/screens/accounts_screen.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart';
import 'package:csv_upload/network/api.dart';

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
  bool isButtonEnabledAPI = false;
  bool isButtonEnabledUpload = true;
  late bool _displayAccountsScreen = false;

  void _loadCSVData(String csvData) {
    List<List<dynamic>> csvTable = const CsvToListConverter().convert(csvData);
    setState(() {
      _tableData = csvTable;
      isButtonEnabledUpload = false;
    });
  }

  Future<void> _openFileExplorer() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      fileBytes = result.files.single.bytes;
      fileName = result.files.single.name;
      PlatformFile file = result.files.first;
      String csvData = String.fromCharCodes(file.bytes!);
      _loadCSVData(csvData);
      isButtonEnabledAPI = true;
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
      body: _displayAccountsScreen ? AccountsScreen(jsonMap: uploadCsvFile(fileBytes!, fileName)) : SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: _csvTableData(_tableData),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
      
              ElevatedButton(
                onPressed: isButtonEnabledAPI
                    ? () {
                        setState(() {
                          _displayAccountsScreen = !_displayAccountsScreen;
                        });
                      }
                    : null,
                child: const Text('Send Data to API'),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'uploadCSV',
            onPressed: isButtonEnabledUpload ? _openFileExplorer : null,
            tooltip: 'Upload CSV',
            backgroundColor: isButtonEnabledUpload ? Colors.blue : Colors.grey[500],
            foregroundColor: isButtonEnabledUpload ? Colors.white : Colors.grey[200],
            child: const Icon(Icons.upload_file),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'clearTable',
            onPressed: () {
              setState(() {
                _tableData = [];
                isButtonEnabledAPI = false;
                isButtonEnabledUpload = true;
                _displayAccountsScreen = false;
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
    return ListView.builder(
      shrinkWrap: true,
      itemCount: tableData.length,
      itemBuilder: (BuildContext context, int index) {
        List<dynamic> rowData = tableData[index];
        return Table(
          border: TableBorder.all(color: Colors.grey),
          columnWidths: const <int, TableColumnWidth>{
            0: FlexColumnWidth(),
            1: FlexColumnWidth(),
            2: FlexColumnWidth(),
            3: FlexColumnWidth(),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(
                color: index == 0 ? const Color.fromARGB(255, 207, 207, 207) : null,
              ),
              children: [
                TableCell(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${rowData[0]}'),
                    ),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${rowData[1]}'),
                    ),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${rowData[2]}'),
                    ),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${rowData[3]}'),
                    ),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${rowData[4]}'),
                    ),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${rowData[5]}'),
                    ),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${rowData[6]}'),
                    ),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${rowData[7]}'),
                    ),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${rowData[8]}'),
                    ),
                  ),
                ),
                TableCell(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${rowData[9]}'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
