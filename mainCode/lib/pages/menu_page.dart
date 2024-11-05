import 'dart:convert';
import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:estia_app/mealPages/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:estia_app/mealPages/breakfast_page.dart';
import 'package:estia_app/mealPages/dinner_page.dart';
import 'package:estia_app/lunch_page.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'dart:math'; // For sin and pi in animation

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with TickerProviderStateMixin {
  final now = DateTime.now();
  final formatter = DateFormat('MMMM yyyy');
  double borderWidth = 1.24;
  var formatted;

  // Use the formatted string
  String? currentMonthYear;

  // Format date to JSON's date format
  String? yearLastTwoDigits;
  String? dateToFind;

  int _controller = 0;
  String breakfast = '-';
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  String lunchFirstDish = '-';
  String lunchMainDish1 = '-';
  String lunchMainDish2 = '-';
  String lunchSideDish = '-';
  String lunchDessert1 = '-';
  String lunchDessert2 = '-';
  String dinnerFirstDish = '-';
  String dinnerMainDish1 = '-';
  String dinnerMainDish2 = '-';
  String dinnerSideDish = '-';
  String dinnerDessert1 = '-';
  String dinnerDessert2 = '-';
  List<Map<String, dynamic>> savedData = [];
  bool? dataFound;

  late AnimationController _animationController;

  Future<void>? _futureData;

  @override
  void initState() {
    super.initState();
    formatted = formatter.format(now);
    currentMonthYear = formatted;
    yearLastTwoDigits = now.year.toString().substring(2);
    dateToFind = "${now.day}/${now.month}/$yearLastTwoDigits";
    _controller = calculatePageIndex();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(); // Repeats the animation indefinitely

    // Initialize the Future with a minimum 1-second delay
    _futureData = Future.wait([
      fetchData(),
      Future.delayed(const Duration(seconds: 1)),
    ]);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Function to fetch data from the internet
  Future<void> fetchData() async {
    try {
      final now = DateTime.now();
      final formatter = DateFormat('MMMM_yyyy');
      final formatted = formatter.format(now);

      final url =
          'https://raw.githubusercontent.com/ValiaDourou/rest-api-and-scheduled-python-script/main/$formatted.json';
      debugPrint('Attempting to download data from: $url');
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        List<Map<String, dynamic>> fetchedData =
            List<Map<String, dynamic>>.from(jsonResponse);

        // Update the state with the fetched data
        savedData = fetchedData;
        dataFound = true;

        // Set the meal details based on the current date
        await loadJsonData(dateToFind ?? '');
      } else {
        debugPrint('Failed to load data from internet.');
        // Handle error if needed
        throw Exception('Failed to load data from internet.');
      }
    } catch (error) {
      debugPrint('Error fetching data: $error');
      // Handle error if needed
    }
  }

  // Function to load JSON data for a specific date
  Future<void> loadJsonData(String dateToFind) async {
    debugPrint('Attempting to load meal data for date: $dateToFind');
    if (savedData.isEmpty) {
      if (mounted) {
        setState(() {
          dataFound = false;
        });
      }
      debugPrint('No data available to load for $dateToFind');
      return;
    }

    bool found = false;

    for (var item in savedData) {
      if (item['day'] == dateToFind) {
        if (mounted) {
          setState(() {
            // Update the flag to indicate that data is found
            dataFound = true;

            // Set the meal details
            breakfast = item['breakfast'] ?? '-';
            lunchFirstDish = item['lunch_first_dish'] ?? '-';
            lunchMainDish1 = item['lunch_main_dish_1'] ?? '-';
            lunchMainDish2 = item['lunch_main_dish_2'] ?? '-';
            lunchSideDish = item['lunch_side_dish'] ?? '-';
            lunchDessert1 = item['lunch_dessert_1'] ?? '-';
            lunchDessert2 = item['lunch_dessert_2'] ?? '-';
            dinnerFirstDish = item['dinner_first_dish'] ?? '-';
            dinnerMainDish1 = item['dinner_main_dish_1'] ?? '-';
            dinnerMainDish2 = item['dinner_main_dish_2'] ?? '-';
            dinnerSideDish = item['dinner_side_dish'] ?? '-';
            dinnerDessert1 = item['dinner_dessert_1'] ?? '-';
            dinnerDessert2 = item['dinner_dessert_2'] ?? '-';
          });
        }
        debugPrint('Data found for $dateToFind:');
        found = true;
        break;
      }
    }

    if (!found) {
      if (mounted) {
        setState(() {
          dataFound = false;
        });
      }
      debugPrint('No meal data found for $dateToFind');
    }
  }

  // Function to calculate the PageView index based on the current time
  int calculatePageIndex() {
    DateTime now = DateTime.now();

    // Define the end times for each meal
    DateTime breakfastEnd = DateTime(now.year, now.month, now.day, 9, 30);
    DateTime lunchTimeEnd = DateTime(now.year, now.month, now.day, 15, 30);
    DateTime dinnerTimeEnd = DateTime(now.year, now.month, now.day, 21, 0);

    // Check the TimePeriod which is currently active and display the corresponding PageView index
    if (now.isAfter(dinnerTimeEnd) || now.isBefore(breakfastEnd)) {
      return 0; // Breakfast
    } else if (now.isAfter(breakfastEnd) && now.isBefore(lunchTimeEnd)) {
      return 1; // Lunch
    } else if (now.isAfter(lunchTimeEnd) && now.isBefore(dinnerTimeEnd)) {
      return 2; // Dinner
    } else {
      return 0; // Default to Breakfast
    }
  }

  // Function to handle refresh logic
  void _handleRefresh() {
    setState(() {
      _futureData = Future.wait([
        fetchData(),
        Future.delayed(const Duration(seconds: 1)),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    double dateBorderRadius = 12;
    double dateDayFontSize = 11.0;
    double dateNumFontSize = 20.0;
    Color tabsBackgroundColor = const Color.fromARGB(255, 255, 255, 255);
    Color tabsTextColor = const Color.fromARGB(255, 255, 255, 255);
    Color textColor = const Color.fromARGB(255, 0, 0, 0);
    Color mainColor = const Color(0xFF9F1005);

    int clickCount = 0;
    DateTime? firstClickTime;

    // Function to show a popup card with animation
    void showPopupCard() {
      DateTime startDate = DateTime(2023, 8, 22);
      DateTime currentDate = DateTime.now();
      int daysPassed = currentDate.difference(startDate).inDays;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent, // Make background transparent
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale:
                          1.0 + 0.1 * sin(_animationController.value * 2 * pi),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 160,
                          ),
                          Text(
                            '$daysPassed',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      );
    }

    // Function to handle tap on the AppBar title
    void handleTap() {
      final now = DateTime.now();
      if (firstClickTime == null ||
          now.difference(firstClickTime!).inSeconds >= 5) {
        clickCount = 0;
        firstClickTime = now;
      }

      clickCount++;

      if (clickCount == 4) {
        showPopupCard();
        clickCount = 0;
        firstClickTime = null;
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFF9F1005),
      appBar: AppBar(
        title: GestureDetector(
          onTap: handleTap,
          child: const Center(
            child: Text(
              'Meals',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Comfortaa',
                color: Colors.white,
              ),
            ),
          ),
        ),
        backgroundColor: const Color(0xFF9F1005),
      ),
      body: FutureBuilder<void>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading indicator
            return const Center(
              child: LoadingWidget(),
            );
          } else if (snapshot.hasError) {
            // Handle error
            return Center(
              child: Text('An error occurred: ${snapshot.error}'),
            );
          } else {
            // Data is ready, build the UI
            return Container(
              color: mainColor,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: Container(
                  color: Colors.grey[100],
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  SvgPicture.asset('assets/images/calendar.svg',
                                      height: 22.0, width: 22.0),
                                  const SizedBox(width: 10),
                                  Text(
                                    DateFormat('MMMM').format(DateTime.now()),
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(Icons.refresh),
                                onPressed: _handleRefresh,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          child: EasyDateTimeLine(
                            initialDate: DateTime.now(),
                            onDateChange: (selectedDate) {
                              String formattedDate =
                                  "${selectedDate.day}/${selectedDate.month}/${selectedDate.year.toString().substring(2)}";
                              debugPrint('Date selected: $formattedDate');
                              loadJsonData(formattedDate);
                            },
                            activeColor: mainColor,
                            headerProps: const EasyHeaderProps(
                              showHeader: false,
                              showMonthPicker: false,
                              selectedDateFormat: SelectedDateFormat.monthOnly,
                            ),
                            dayProps: EasyDayProps(
                              height: screenHeight * 0.08,
                              width: screenHeight * 0.065,
                              dayStructure: DayStructure.dayStrDayNum,
                              todayStyle: DayStyle(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 3,
                                    color: mainColor,
                                  ),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(dateBorderRadius)),
                                ),
                                borderRadius: dateBorderRadius,
                                dayNumStyle: TextStyle(
                                    fontSize: dateNumFontSize,
                                    fontWeight: FontWeight.bold),
                                dayStrStyle: TextStyle(
                                    fontSize: dateDayFontSize,
                                    fontWeight: FontWeight.bold),
                              ),
                              inactiveDayStyle: DayStyle(
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                        width: borderWidth, color: mainColor),
                                    left: BorderSide(
                                        width: borderWidth, color: mainColor),
                                    right: BorderSide(
                                        width: borderWidth, color: mainColor),
                                    bottom: BorderSide(
                                        width: borderWidth, color: mainColor),
                                  ),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(dateBorderRadius)),
                                ),
                                borderRadius: dateBorderRadius,
                                dayNumStyle: TextStyle(
                                    fontSize: dateNumFontSize,
                                    fontWeight: FontWeight.bold),
                                dayStrStyle: TextStyle(
                                    fontSize: dateDayFontSize,
                                    fontWeight: FontWeight.bold),
                              ),
                              activeDayStyle: DayStyle(
                                borderRadius: dateBorderRadius,
                                dayNumStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: dateNumFontSize,
                                    fontWeight: FontWeight.bold),
                                dayStrStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: dateDayFontSize,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: DefaultTabController(
                              length: 3,
                              initialIndex:
                                  _controller, // Initial tab index based on current time
                              child: Scaffold(
                                backgroundColor: const Color(0xFFF5F5F5),
                                body: SafeArea(
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: SegmentedTabControl(
                                          // Customization of widget
                                          radius: const Radius.circular(8),
                                          backgroundColor: Colors.white,
                                          indicatorColor: mainColor,
                                          tabTextColor: Colors.black45,
                                          selectedTabTextColor: Colors.white,
                                          squeezeIntensity: 2,
                                          height: 40,
                                          tabPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 8),
                                          textStyle: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Outfit',
                                              fontWeight: FontWeight.w600),
                                          selectedTextStyle: const TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Outfit',
                                            fontWeight: FontWeight.w900,
                                          ),
                                          // Options for selection
                                          tabs: [
                                            SegmentTab(
                                              label: 'Breakfast',
                                              backgroundColor:
                                                  tabsBackgroundColor,
                                              selectedTextColor: tabsTextColor,
                                              textColor: textColor,
                                            ),
                                            SegmentTab(
                                              label: 'Lunch',
                                              backgroundColor:
                                                  tabsBackgroundColor,
                                              selectedTextColor: tabsTextColor,
                                              textColor: textColor,
                                            ),
                                            SegmentTab(
                                              label: 'Dinner',
                                              backgroundColor:
                                                  tabsBackgroundColor,
                                              selectedTextColor: tabsTextColor,
                                              textColor: textColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 70),
                                        child: (dataFound ?? false)
                                            ? TabBarView(
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                children: [
                                                  BreakfastPage(
                                                    breakfast: breakfast,
                                                  ),
                                                  LunchPage(
                                                    lunchFirstDish:
                                                        lunchFirstDish,
                                                    lunchMainDish1:
                                                        lunchMainDish1,
                                                    lunchMainDish2:
                                                        lunchMainDish2,
                                                    lunchSideDish:
                                                        lunchSideDish,
                                                    lunchDessert1:
                                                        lunchDessert1,
                                                    lunchDessert2:
                                                        lunchDessert2,
                                                  ),
                                                  DinnerPage(
                                                    dinnerFirstDish:
                                                        dinnerFirstDish,
                                                    dinnerMainDish1:
                                                        dinnerMainDish1,
                                                    dinnerMainDish2:
                                                        dinnerMainDish2,
                                                    dinnerSideDish:
                                                        dinnerSideDish,
                                                    dinnerDessert1:
                                                        dinnerDessert1,
                                                    dinnerDessert2:
                                                        dinnerDessert2,
                                                  ),
                                                ],
                                              )
                                            : const Center(
                                                child: Text(
                                                  "Estia is closed today.",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
