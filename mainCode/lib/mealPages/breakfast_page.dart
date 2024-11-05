import 'package:estia_app/food_info.dart';
import 'package:flutter/material.dart';

class BreakfastPage extends StatelessWidget {
  final String breakfast;
  const BreakfastPage({Key? key, required this.breakfast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.only(top: 0, left: 25, right: 25, bottom: 15),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              FoodInfo(
                entireText: breakfast,
                title: "Dishes",
                svgImage: "plate.svg",
              )
            ],
          )),
        ),
      ),
    );
  }
}
