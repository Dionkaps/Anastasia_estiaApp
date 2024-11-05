// import 'dart:convert';
// import 'dart:io';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:barcode_widget/barcode_widget.dart' as bw;
// import 'package:estia_app/card_data.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/material.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
// import 'package:image_cropper/image_cropper.dart';

// class CardsPage extends StatefulWidget {
//   const CardsPage({Key? key}) : super(key: key);

//   @override
//   State<CardsPage> createState() => _CardsPageState();
// }

// class _CardsPageState extends State<CardsPage> {
//   final _controller = PageController(); // Controller for the PageView
//   List<CardData> cardDataList = []; // List to store card data
//   int currentPageIndex = 0; // Index of the current page in the PageView

//   // Function to save card data to a file
//   Future<void> saveDataToFile() async {
//     final directory = await getApplicationDocumentsDirectory();
//     final file = File('${directory.path}/card_data.json');
//     final jsonData =
//         jsonEncode(cardDataList.map((card) => card.toJson()).toList());
//     await file.writeAsString(jsonData);
//   }

//   // Function to load card data from a file
//   Future<void> loadDataFromFile() async {
//     try {
//       final directory = await getApplicationDocumentsDirectory();
//       final file = File('${directory.path}/card_data.json');
//       final jsonData = await file.readAsString();
//       final List<dynamic> decodedData = jsonDecode(jsonData);
//       setState(() {
//         cardDataList =
//             decodedData.map((data) => CardData.fromJson(data)).toList();
//       });
//     } catch (e) {
//       debugPrint('Error loading data: $e');
//     }
//   }

//   // Function to show a dialog with crop instructions
//   Future<void> _showCropInstructionsDialog() async {
//     if (!mounted) return;
//     await showDialog<String>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15.0),
//           ),
//           title: const Text(
//             'Crop your card to focus on the Barcode',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           content: const Text(
//             'Please select your card and then crop it to focus on the Barcode.',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 if (!mounted) return;
//                 Navigator.of(context).pop();
//               },
//               child: const Text(
//                 'OK',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Function to pick an image from the gallery, crop it, and process the barcode
//   Future<void> pickImageAndProcess() async {
//     await _showCropInstructionsDialog();
//     if (!mounted) return;

//     final image = await ImagePicker().pickImage(source: ImageSource.gallery);

//     if (!mounted) return;

//     if (image == null) return;

//     final imageTemp = File(image.path);
//     final savedImage = await saveImage(imageTemp);

//     if (!mounted) return;

//     CroppedFile? croppedFile = await ImageCropper().cropImage(
//       sourcePath: image.path,
//       uiSettings: [
//         AndroidUiSettings(
//             toolbarTitle: 'Image Crop',
//             toolbarColor: const Color(0xFF9F1005),
//             toolbarWidgetColor: Colors.white,
//             statusBarColor: const Color(0xFF9F1005),
//             activeControlsWidgetColor: const Color(0xFF9F1005),
//             initAspectRatio: CropAspectRatioPreset.values[2],
//             hideBottomControls: true,
//             lockAspectRatio: false),
//         IOSUiSettings(
//           title: 'Cropper',
//         ),
//         WebUiSettings(
//           context: context,
//         ),
//       ],
//     );

//     if (!mounted) return;

//     if (croppedFile != null) {
//       // Create an InputImage from the cropped file path
//       final InputImage inputImage = InputImage.fromFilePath(croppedFile.path);

//       // Create an instance of BarcodeScanner
//       final BarcodeScanner barcodeScanner = BarcodeScanner();

//       try {
//         // Process the image and get the list of barcodes
//         List<Barcode> barcodes = await barcodeScanner.processImage(inputImage);

//         // Close the barcodeScanner when done
//         barcodeScanner.close();

//         if (!mounted) return;

//         if (barcodes.isNotEmpty) {
//           // Get the barcode data from the first barcode detected
//           String result = barcodes.first.rawValue ?? '';

//           String? username = await _showUsernameDialog();

//           if (!mounted) return;

//           if (username == null || username.isEmpty) {
//             // User canceled or entered an empty username
//             return;
//           }

//           // Create a new CardData with the new information
//           CardData newCardData = CardData(
//             imagePath: savedImage.path,
//             barcodeData: result,
//             username: username,
//           );

//           // Add the new card data to the beginning of the list
//           cardDataList.insert(0, newCardData);

//           if (!mounted) return;

//           setState(() {});

//           saveDataToFile();
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text(
//                 'Barcode not found. Image not saved.',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               duration: Duration(seconds: 2),
//             ),
//           );
//         }
//       } catch (e) {
//         barcodeScanner.close();
//         if (!mounted) return;
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text(
//               'Failed to process the image. Please try again.',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             duration: Duration(seconds: 2),
//           ),
//         );
//       }
//     }
//   }

//   // Function to show a dialog with the full image
//   void showFullImage(CardData cardData) {
//     if (!mounted) return;
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           child: Container(
//             width: double.infinity,
//             height: double.infinity,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: FileImage(File(cardData.imagePath)),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // Function to show a dialog for entering a username
//   Future<String?> _showUsernameDialog() async {
//     if (!mounted) return null;
//     String? username;

//     await showDialog<String>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15.0),
//           ),
//           title: const Text(
//             'Enter a name for your card',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           content: TextField(
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontFamily: 'Comfortaa',
//             ),
//             onChanged: (value) {
//               username = value;
//             },
//             maxLength: 10,
//             decoration: const InputDecoration(
//               hintText: 'Card\'s Name',
//               hintStyle: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontFamily: 'Comfortaa',
//               ),
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 if (!mounted) return;
//                 Navigator.of(context).pop(username);
//               },
//               child: const Text(
//                 'OK',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         );
//       },
//     );

//     return username;
//   }

//   // Function to save an image to the application documents directory
//   Future<File> saveImage(File image) async {
//     final directory = await getApplicationDocumentsDirectory();
//     final path = directory.path;
//     final timestamp = DateTime.now().millisecondsSinceEpoch;

//     return image.copy('$path/$timestamp.png');
//   }

//   // Function to save image data to shared preferences
//   Future saveImageData(String path, String barcodeData, String username) async {
//     final prefs = await SharedPreferences.getInstance();
//     final imagePaths = prefs.getStringList('imagePaths') ?? [];
//     imagePaths.add(path);

//     final barcodeDataList = prefs.getStringList('barcodeDataList') ?? [];
//     barcodeDataList.add(barcodeData);

//     final usernameList = prefs.getStringList('usernameList') ?? [];
//     usernameList.add(username);

//     await prefs.setStringList('imagePaths', imagePaths);
//     await prefs.setStringList('barcodeDataList', barcodeDataList);
//     await prefs.setStringList('usernameList', usernameList);
//   }

//   // Function to load images from shared preferences
//   Future loadImages() async {
//     final prefs = await SharedPreferences.getInstance();
//     final imagePaths = prefs.getStringList('imagePaths') ?? [];
//     final barcodeDataList = prefs.getStringList('barcodeDataList') ?? [];
//     final usernameList = prefs.getStringList('usernameList') ?? [];

//     setState(() {
//       cardDataList = List.generate(imagePaths.length, (index) {
//         return CardData(
//           imagePath: imagePaths[index],
//           barcodeData: barcodeDataList[index],
//           username: usernameList[index],
//         );
//       });
//     });
//   }

//   // Function to delete an image
//   void deleteImage(CardData cardData) async {
//     if (!mounted) return;
//     bool deleteConfirmed = await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15.0),
//           ),
//           title: const Text(
//             'Confirm Deletion',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           content: const Text(
//             'Are you sure you want to delete this card?',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 if (!mounted) return;
//                 Navigator.of(context).pop(false);
//               },
//               child: const Text(
//                 'Cancel',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 if (!mounted) return;
//                 Navigator.of(context).pop(true);
//               },
//               child: const Text(
//                 'Delete',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         );
//       },
//     );

//     if (!mounted) return;

//     if (deleteConfirmed == true) {
//       setState(() {
//         cardDataList.remove(cardData);
//       });

//       final prefs = await SharedPreferences.getInstance();
//       final imagePaths = prefs.getStringList('imagePaths') ?? [];
//       final barcodeDataList = prefs.getStringList('barcodeDataList') ?? [];
//       final usernameList = prefs.getStringList('usernameList') ?? [];

//       imagePaths.remove(cardData.imagePath);
//       barcodeDataList.remove(cardData.barcodeData);
//       usernameList.remove(cardData.username);

//       await prefs.setStringList('imagePaths', imagePaths);
//       await prefs.setStringList('barcodeDataList', barcodeDataList);
//       await prefs.setStringList('usernameList', usernameList);

//       saveDataToFile();
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     loadImages();
//     loadDataFromFile();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;
//     double screenWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: const Color(0xFF9F1005),
//       body: Stack(
//         children: [
//           Positioned(
//             top: -screenWidth * 0.9 * 0.5,
//             left: 0,
//             right: 0,
//             child: Container(
//               width: screenWidth * 0.9,
//               height: screenWidth * 0.9,
//               decoration: const BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Color.fromARGB(255, 185, 47, 37),
//               ),
//             ),
//           ),
//           Column(
//             children: <Widget>[
//               Container(
//                 height: screenHeight * 0.15,
//               ),
//               Container(
//                 width: screenWidth,
//                 height: screenHeight * 0.85,
//                 decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(50.0),
//                     topRight: Radius.circular(50.0),
//                   ),
//                   color: Color(0xffffffff),
//                 ),
//                 child: SafeArea(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         if (cardDataList.isEmpty)
//                           const Padding(
//                             padding: EdgeInsets.only(top: 20.0),
//                             child: Text(
//                               'No cards added yet',
//                               style: TextStyle(
//                                 fontSize: 18.0,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           )
//                         else
//                           SizedBox(
//                             height: screenHeight * 0.6,
//                             child: PageView.builder(
//                               controller: _controller,
//                               onPageChanged: (index) {
//                                 setState(() {
//                                   currentPageIndex = index;
//                                 });
//                               },
//                               itemBuilder: (context, index) {
//                                 return Padding(
//                                   padding: const EdgeInsets.only(
//                                       top: 0, left: 25, right: 25, bottom: 15),
//                                   child: Card(
//                                     color: const Color.fromARGB(
//                                         255, 255, 252, 252),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(25),
//                                     ),
//                                     elevation: 10,
//                                     child: Stack(
//                                         clipBehavior: Clip.none,
//                                         children: <Widget>[
//                                           Positioned(
//                                             top: screenHeight * 0.025,
//                                             left: screenWidth * 0.07,
//                                             child: SizedBox(
//                                               width: screenWidth * 0.55,
//                                               child: AutoSizeText(
//                                                   cardDataList[index].username,
//                                                   maxLines: 2,
//                                                   style: const TextStyle(
//                                                     fontSize: 27.0,
//                                                     fontWeight: FontWeight.bold,
//                                                     fontFamily: 'Comfortaa',
//                                                   )),
//                                             ),
//                                           ),
//                                           Positioned(
//                                             top: screenHeight * 0.021,
//                                             right: screenWidth * 0.07,
//                                             child: Container(
//                                               decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(15),
//                                                 border: const Border(
//                                                   top: BorderSide(
//                                                       width: 1.24,
//                                                       color: Color(0xFF9F1005)),
//                                                   left: BorderSide(
//                                                       width: 1.24,
//                                                       color: Color(0xFF9F1005)),
//                                                   right: BorderSide(
//                                                       width: 1.24,
//                                                       color: Color(0xFF9F1005)),
//                                                   bottom: BorderSide(
//                                                       width: 1.24,
//                                                       color: Color(0xFF9F1005)),
//                                                 ),
//                                               ),
//                                               child: IconButton(
//                                                 iconSize: 30,
//                                                 icon: const Icon(Icons.delete),
//                                                 onPressed: () {
//                                                   deleteImage(
//                                                       cardDataList[index]);
//                                                 },
//                                               ),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: EdgeInsets.only(
//                                                 top: screenHeight * 0.05),
//                                             child: Center(
//                                               child: Transform.rotate(
//                                                 angle: 3.14 / 2,
//                                                 child: bw.BarcodeWidget(
//                                                   data: cardDataList[index]
//                                                           .barcodeData ??
//                                                       '',
//                                                   barcode: bw.Barcode.code39(),
//                                                   width: screenHeight * 0.45,
//                                                   height: screenHeight * 0.2,
//                                                   drawText: true,
//                                                   style: const TextStyle(
//                                                     fontFamily: 'Comfortaa',
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ]),
//                                   ),
//                                 );
//                               },
//                               itemCount: cardDataList.length,
//                             ),
//                           ),
//                         if (cardDataList.length > 1)
//                           SmoothPageIndicator(
//                             controller: _controller,
//                             count: cardDataList.length,
//                             effect: const WormEffect(
//                               activeDotColor: Color.fromARGB(255, 185, 47, 37),
//                               dotColor: Color.fromARGB(255, 217, 107, 99),
//                               dotHeight: 15,
//                               dotWidth: 15,
//                             ),
//                           ),
//                         Padding(
//                           padding: EdgeInsets.only(top: 0.02 * screenHeight),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor:
//                                       const Color.fromARGB(255, 185, 47, 37),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(30.0),
//                                   ),
//                                 ),
//                                 onPressed: () {
//                                   pickImageAndProcess();
//                                 },
//                                 child: Text(
//                                   '+ Add Card',
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.grey[100]),
//                                 ),
//                               ),
//                               const SizedBox(width: 16),
//                               ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor:
//                                       const Color.fromARGB(255, 185, 47, 37),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(30.0),
//                                   ),
//                                 ),
//                                 onPressed: cardDataList.isNotEmpty
//                                     ? () {
//                                         if (_controller.page != null) {
//                                           showFullImage(cardDataList[
//                                               _controller.page!.round()]);
//                                         }
//                                       }
//                                     : null,
//                                 child: Text(
//                                   'View Full Card',
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.grey[100]),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
