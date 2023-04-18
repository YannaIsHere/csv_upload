import 'package:flutter/material.dart';
import 'package:csv_upload/widgets/wcf_safety_consultants.dart';
import 'package:csv_upload/widgets/policy_numbers.dart';
import 'safety_consultants_screen.dart';
import 'locations_screen.dart';

class AccountsScreen extends StatefulWidget {
  final Future<Map<String, dynamic>> jsonMap;
  const AccountsScreen({super.key, required this.jsonMap});

  @override
  // ignore: library_private_types_in_public_api
  _AccountsScreenState createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
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
          child: const Text('Accounts Page'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
              future: _jsonMap,
              builder: ((context, snapshot) {
                Title(color: Colors.black, child: const Text('Account'));
                if (snapshot.hasData) {
                  final jsonData = snapshot.data!;
                  final data = jsonData['data']['accounts'] as List<dynamic>;
                  return _accountsInformation(data);
                } else if (snapshot.hasError) {
                  return Text('Error loading data: ${snapshot.error}');
                } else {
                  return Column(
                    children: const [
                      SizedBox(height: 20),
                      Center(child: CircularProgressIndicator()),
                      SizedBox(height: 20),
                    ],
                  );
                }
              }),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SafetyConsultantsScreen(jsonMap: _jsonMap)));
                      });
                    },
                    child: const Text('Safety Consultants'),
                  ),
                  const SizedBox(width: 20,),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    LocationsScreen(jsonMap: _jsonMap)));
                      });
                    },
                    child: const Text('Locations'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _accountsInformation(List<dynamic> data) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index) {
        final account = data[index] as Map<String, dynamic>;
        final accountName = account['account']['accountName'];
        final errorMessageAC = account['account']['errorMessage'];

        final safetyConsultants =
            account['wcfSafetyConsultants'] as List<dynamic>;
        final policyNumbers = account['policyNumbers'] as List<dynamic>;

        final rows = <TableRow>[];
        final rows2 = <TableRow>[];

        //SAFETY CONSULTANTS
        for (var i = 0; i < safetyConsultants.length; i++) {
          final consultant = safetyConsultants[i] as Map<String, dynamic>;
          final id = consultant['_id'];
          final firstName = consultant['firstName'];
          final lastName = consultant['lastName'];
          final email = consultant['email'];
          final phone = consultant['phone'];
          final errormessageSC = consultant['errorMessage'];

          rows.add(
            TableRow(
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
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text(phone)),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text(errormessageSC ?? '')),
                  ),
                ),
              ],
            ),
          );
        }

        //POLICY NUMBERS
        for (var i = 0; i < policyNumbers.length; i++) {
          final policy = policyNumbers[i] as Map<String, dynamic>;
          final policyNumber = policy['policyNumber'];
          final errorMessagePN = policy['errorMessage'];

          rows2.add(
            TableRow(
              children: [
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text(policyNumber)),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text(errorMessagePN ?? '')),
                  ),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              ListTile(
                title: Text(
                  accountName,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                subtitle: RichText(
                  text: TextSpan(
                    text: errorMessageAC ?? '',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
                child: Text(
                  'WCF SAFETY CONSULTANT',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              WFCSafetyConsultantsTable(rows: rows),
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: SizedBox(
                  height: 30,
                  child: Text(
                    'POLICY NUMBERS',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              PolicyNumbersTable(rows: rows2),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        );
      },
    );
  }
}
