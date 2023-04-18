import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SafetyConsultantsTable extends StatelessWidget {
  List<TableRow>? rows;
  SafetyConsultantsTable({super.key, this.rows});
  
  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(color: Colors.grey),
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(),
        1: FlexColumnWidth(),
        2: FlexColumnWidth(),
        3: FlexColumnWidth(),
      },
      children: [
        const TableRow(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 207, 207, 207),
          ),
          children: [
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child:
                      Text('ID', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text('First Name',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text('Last Name',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text('Role',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
        ...?rows,
      ],
    );
  }
}
