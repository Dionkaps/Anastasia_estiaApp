import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class FoodInfo extends StatefulWidget {
  final String entireText;
  final String title;
  final String svgImage;

  const FoodInfo({
    Key? key,
    required this.entireText,
    required this.title,
    required this.svgImage,
  }) : super(key: key);

  @override
  State<FoodInfo> createState() => _FoodInfoState();
}

class _FoodInfoState extends State<FoodInfo> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(255, 255, 255, 255),
          border: Border.all(
            color: const Color(0xffeeeeee),
            width: 1,
          ),
        ),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: <Widget>[
                    SvgPicture.asset('assets/images/${widget.svgImage}',
                        height: 22.0,
                        width: 22.0), // Replace with your SVG file path
                    const SizedBox(
                        width:
                            10), // Add some spacing between the icon and the text
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Comfortaa',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: const Divider(),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 5, bottom: 15),
              child: Text(widget.entireText,
                  style:
                      const TextStyle(fontSize: 18, fontFamily: 'Comfortaa')),
            ),
          ],
        ),
      ),
    );
  }
}
