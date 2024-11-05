import 'package:estia_app/food_info.dart';
import 'package:flutter/material.dart';

class LunchPage extends StatelessWidget {
  final String lunchFirstDish;
  final String lunchMainDish1;
  final String lunchMainDish2;
  final String lunchSideDish;
  final String lunchDessert1;
  final String lunchDessert2;
  const LunchPage(
      {Key? key,
      required this.lunchFirstDish,
      required this.lunchMainDish1,
      required this.lunchMainDish2,
      required this.lunchSideDish,
      required this.lunchDessert1,
      required this.lunchDessert2})
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
                entireText: lunchFirstDish,
                title: "First Dish",
                svgImage: "plate.svg",
              ),
              FoodInfo(
                title: 'Main Dishes',
                entireText: '$lunchMainDish1\n$lunchMainDish2',
                svgImage: "dishPlate.svg",
              ),
              FoodInfo(
                title: 'Side Dish',
                entireText: lunchSideDish,
                svgImage: "salad.svg",
              ),
              FoodInfo(
                title: 'Desserts',
                entireText: lunchDessert2 !=
                        '-' // Check if lunchDessert2 is not equal to "-"
                    ? '$lunchDessert1\n$lunchDessert2' // If lunchDessert2 is not equal to "-", add it to foodInfo
                    : lunchDessert1, // If lunchDessert2 is equal to "-", only display lunchDessert1
                svgImage: "cupcake.svg",
              ),
            ],
          )),
        ),
      ),
    );
  }
}
