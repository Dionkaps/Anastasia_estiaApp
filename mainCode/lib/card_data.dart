//Class to represent the data of a card
class CardData {
  final String imagePath;
  final String? barcodeData;
  final String username;

  //Constructor for CardData
  CardData({
    required this.imagePath,
    required this.barcodeData,
    required this.username,
  });

  //Function to convert CardData to JSON
  Map<String, dynamic> toJson() {
    return {
      'imagePath': imagePath,
      'barcodeData': barcodeData,
      'username': username,
    };
  }

  //
  //Factory constructor to create CardData from JSON
  factory CardData.fromJson(Map<String, dynamic> json) {
    return CardData(
      imagePath: json['imagePath'],
      barcodeData: json['barcodeData'],
      username: json['username'],
    );
  }
}