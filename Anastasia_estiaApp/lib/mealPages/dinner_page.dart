import 'package:estia_app/food_info.dart';
import 'package:flutter/material.dart';

class DinnerPage extends StatelessWidget {
  final String dinnerFirstDish;
  final String dinnerMainDish1;
  final String dinnerMainDish2;
  final String dinnerSideDish;
  final String dinnerDessert1;
  final String dinnerDessert2;
  const DinnerPage(
      {Key? key,
      required this.dinnerFirstDish,
      required this.dinnerMainDish1,
      required this.dinnerMainDish2,
      required this.dinnerSideDish,
      required this.dinnerDessert1,
      required this.dinnerDessert2})
      : super(key: key);

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
                title: 'First Dish',
                entireText: dinnerFirstDish,
                svgImage: "plate.svg",
              ),
              FoodInfo(
                title: 'Main Dishes',
                entireText: '$dinnerMainDish1\n$dinnerMainDish2',
                svgImage: "dishPlate.svg",
              ),
              FoodInfo(
                title: 'Side Dish',
                entireText: dinnerSideDish,
                svgImage: "salad.svg",
              ),
              FoodInfo(
                title: 'Desserts',
                entireText: dinnerDessert2 !=
                        '-' // Check if dinnerDessert2 is not equal to "-"
                    ? '$dinnerDessert1\n$dinnerDessert2' // If dinnerDessert2 is not equal to "-", add it to foodInfo
                    : dinnerDessert1, // If dinnerDessert2 is equal to "-", only display dinnerDessert1
                svgImage: "cupcake.svg",
              ),
            ],
          )),
        ),
      ),
    );
  }
}
