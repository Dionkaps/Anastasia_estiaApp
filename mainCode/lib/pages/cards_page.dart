import 'package:auto_size_text/auto_size_text.dart';
import 'package:barcode_widget/barcode_widget.dart' as bw;
import 'package:flutter/material.dart';

class CardData {
  final String imagePath;
  final String barcodeData;
  final String username;

  CardData({
    required this.imagePath,
    required this.barcodeData,
    required this.username,
  });

  Map<String, dynamic> toJson() {
    return {
      'imagePath': imagePath,
      'barcodeData': barcodeData,
      'username': username,
    };
  }

  factory CardData.fromJson(Map<String, dynamic> json) {
    return CardData(
      imagePath: json['imagePath'],
      barcodeData: json['barcodeData'],
      username: json['username'],
    );
  }
}

class CardsPage extends StatefulWidget {
  const CardsPage({super.key});

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  final _controller = PageController(); // Controller for the PageView
  List<CardData> cardDataList = []; // List to store card data
  int currentPageIndex = 0; // Index of the current page in the PageView

  @override
  void initState() {
    super.initState();
    cardDataList.add(
      CardData(
        imagePath: 'assets/images/paso.png',
        barcodeData: '2405243',
        username: 'kapkap\'s bitch',
      ),
    );
  }

  // Function to show a dialog with the full image
  void showFullImage(CardData cardData) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor:
              Colors.transparent, // Optional: makes the background transparent
          child: GestureDetector(
            onTap: () => Navigator.of(context)
                .pop(), // Allows closing the dialog by tapping on the image
            child: Image.asset(
              cardData.imagePath,
              fit: BoxFit.contain, // Ensures the entire image is visible
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
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
              SizedBox(
                height: screenHeight * 0.15,
              ),
              Container(
                width: screenWidth,
                height: screenHeight * 0.85,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0),
                  ),
                  color: Color(0xffffffff),
                ),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        if (cardDataList.isEmpty)
                          const Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: Text(
                              'No cards added yet',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        else
                          SizedBox(
                            height: screenHeight * 0.6,
                            child: PageView.builder(
                              controller: _controller,
                              onPageChanged: (index) {
                                setState(() {
                                  currentPageIndex = index;
                                });
                              },
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0, left: 25, right: 25, bottom: 15),
                                  child: Card(
                                    color: const Color.fromARGB(
                                        255, 255, 252, 252),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    elevation: 10,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: <Widget>[
                                        Positioned(
                                          top: screenHeight * 0.025,
                                          left: screenWidth * 0.07,
                                          child: SizedBox(
                                            width: screenWidth * 0.55,
                                            child: AutoSizeText(
                                              cardDataList[index].username,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                fontSize: 27.0,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Comfortaa',
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: screenHeight * 0.05),
                                          child: Center(
                                            child: Transform.rotate(
                                              angle: 3.14 / 2,
                                              child: bw.BarcodeWidget(
                                                data: cardDataList[index]
                                                    .barcodeData,
                                                barcode: bw.Barcode.code39(),
                                                width: screenHeight * 0.45,
                                                height: screenHeight * 0.2,
                                                drawText: true,
                                                style: const TextStyle(
                                                  fontFamily: 'Comfortaa',
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: cardDataList.length,
                            ),
                          ),
                        Padding(
                          padding: EdgeInsets.only(top: 0.02 * screenHeight),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 185, 47, 37),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            onPressed: cardDataList.isNotEmpty
                                ? () {
                                    if (_controller.page != null) {
                                      showFullImage(cardDataList[
                                          _controller.page!.round()]);
                                    }
                                  }
                                : null,
                            child: Text(
                              'View Full Card',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[100]),
                            ),
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
