import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    void openURL() async {
      var url = Uri.parse(
          'https://www.google.com/maps/dir//Φοιτητική+Εστία+Πανεπιστήμιο+Πατρών,+26504+25ης+Μαρτίου+11+Πανεπιστημιούπολη+Πατρών+265+04/@37.6407245,23.1116627,10z/data=!4m9!4m8!1m0!1m5!1m1!1s0x135e4bf98d7b3fcd:0x6df8807295e50015!2m2!1d21.7897081!2d38.2861713!3e0?entry=ttu');

      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF9F1005),
      body: Stack(
        children: [
          Positioned(
            top: -screenWidth * 0.9 * 0.5,
            left: 0,
            right: 0,
            child: Container(
              width: screenWidth * 0.9,
              height: screenWidth * 0.9,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 185, 47, 37),
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                height: screenHeight * 0.15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Container(
                  width: screenWidth,
                  height: screenHeight * 0.7,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: screenHeight * 0.05),
                          child: const Text(
                            "Time schedule",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(bottom: screenHeight * 0.05 / 2),
                          child: DataTable(
                            columns: const <DataColumn>[
                              DataColumn(
                                label: Text(''),
                              ),
                              DataColumn(
                                label: Text(
                                  'Opens',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Closes',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                            rows: const <DataRow>[
                              DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(
                                    'Breakfast',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                                  DataCell(Text(
                                    '07.30',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                                  DataCell(Text(
                                    '09.30',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                                ],
                              ),
                              DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(
                                    'Lunch',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                                  DataCell(Text(
                                    '12.00',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                                  DataCell(Text(
                                    '15.30',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                                ],
                              ),
                              DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(
                                    'Dinner',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                                  DataCell(Text(
                                    '19.00',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                                  DataCell(Text(
                                    '21.00',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          color: Colors.grey,
                          height: 20,
                          thickness: 2,
                          indent: 20,
                          endIndent: 20,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: screenHeight * 0.05 / 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                "Directions",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<
                                          Color>(
                                      const Color.fromARGB(200, 185, 47, 37)),
                                ),
                                onPressed: openURL,
                                child: const Text(
                                  'Open Map',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
