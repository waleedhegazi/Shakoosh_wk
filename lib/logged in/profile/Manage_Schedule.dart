import 'package:flutter/material.dart';
import 'package:shakoosh_wk/Assets.dart';
import 'package:intl/intl.dart';
import 'package:shakoosh_wk/register/Register_Next_Button.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:shakoosh_wk/Shakoosh_icons.dart';
import 'package:shakoosh_wk/repository/User_Repository.dart';

class ManageScheduleScreen extends StatefulWidget {
  const ManageScheduleScreen({super.key});
  @override
  State<ManageScheduleScreen> createState() {
    return _ManageScheduleScreenState();
  }
}

class _ManageScheduleScreenState extends State<ManageScheduleScreen> {
  int daysStartFrom = 0;
  int canceledTimes = 0;

  List<dynamic> canceledSpotsTemp = [
    ...UserRepository.getCurrentUser().getTimeTable()
  ];

  @override
  void initState() {
    var now = DateTime.now();
    String day = DateFormat('EEEE').format(now).toString();
    int hour = int.parse(DateFormat('H').format(now));
    if (hour > 19) {
      canceledTimes = 8;
    } else if (hour > 17) {
      canceledTimes = 7;
    } else if (hour > 16) {
      canceledTimes = 6;
    } else if (hour > 14) {
      canceledTimes = 5;
    } else if (hour > 13) {
      canceledTimes = 4;
    } else if (hour > 11) {
      canceledTimes = 3;
    } else if (hour > 10) {
      canceledTimes = 2;
    } else if (hour > 8) {
      canceledTimes = 1;
    }
    switch (day) {
      case 'Sunday':
        daysStartFrom = 1;
        break;
      case 'Monday':
        daysStartFrom = 2;
        break;
      case 'Tuesday':
        daysStartFrom = 3;
        break;
      case 'Wednesday':
        daysStartFrom = 4;
        break;
      case 'Thursday':
        daysStartFrom = 5;
        break;
      case 'Friday':
        daysStartFrom = 6;
        break;
    }
    super.initState();
  }

  void _onSaveChanges() {
    UserRepository.getCurrentUser().setTimeTable(canceledSpotsTemp);
    UserRepository.updateTimeTableInDatabase();

    //update in database
    _showMessage('Changes are saved');
    Navigator.of(context).pop();
  }

  Widget spotsGrid(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int counter = -1;
    return GridView(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
          crossAxisSpacing: screenWidth * 0.02,
          mainAxisSpacing: screenWidth * 0.02,
        ),
        children: canceledSpotsTemp.map((isCanceled) {
          if (++counter < canceledTimes) {
            return canceledSpot(screenWidth * 0.085);
          } else if (UserRepository.getCurrentUser().getTimeTable()[counter]) {
            return appointmentSpot(screenWidth * 0.085);
          } else {
            return spot(screenWidth * 0.085, counter, isCanceled);
          }
        }).toList());
  }

  Widget canceledSpot(double dimenssion) {
    return Container(
      width: dimenssion,
      height: dimenssion,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.scrim,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Widget appointmentSpot(double dimenssion) {
    return Container(
        width: dimenssion,
        height: dimenssion,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 245, 196, 63),
          borderRadius: BorderRadius.circular(3),
        ));
  }

  Widget spot(double dimenssion, int index, bool isTapped) {
    return InkWell(
        child: Container(
          width: dimenssion,
          height: dimenssion,
          decoration: BoxDecoration(
              color: isTapped
                  ? Color.fromARGB(0, 0, 0, 0)
                  : Color.fromARGB(255, 206, 206, 206),
              borderRadius: BorderRadius.circular(3),
              border: isTapped
                  ? Border.all(
                      width: 2, color: Color.fromARGB(255, 221, 220, 220))
                  : null),
        ),
        onTap: () {
          canceledSpotsTemp[index] = !canceledSpotsTemp[index];
          setState(() {});
        });
  }

  List<Widget> getDays() {
    List<Widget> daysList = [FittedBox(child: Text('Tod'))];
    for (int i = daysStartFrom + 1; i < daysStartFrom + 7; i++) {
      daysList.add(FittedBox(child: Text(Assets.days[i])));
    }
    return daysList;
  }

  void _showMessage(String txt) {
    showTopSnackBar(
        Overlay.of(context),
        Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(155, 59, 59, 59),
                borderRadius: BorderRadius.circular(20)),
            child: SizedBox(
              height: 50,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(ShakooshIcons.logo_transparent_black_2,
                    size: 40, color: Colors.white),
                Container(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(txt,
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.white)))
              ]),
            )));
  }

  @override
  Widget build(context) {
    double screenHeight = (MediaQuery.of(context).size.height) -
        (MediaQuery.of(context).padding.top) -
        (MediaQuery.of(context).padding.bottom);
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(screenHeight * 0.07),
            child: AppBar(
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                  )),
              title: Text("Search filters",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge),
            )),
        body: Container(
            height: screenHeight * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                SizedBox(
                  width: screenWidth * 0.8,
                  child: Text(
                    "Tap on the following spot(s) to change your availabilty at corresponding date and time",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Color.fromARGB(255, 173, 173, 173)),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    SizedBox(width: screenWidth * 0.1),
                    SizedBox(
                      width: screenWidth * 0.82,
                      child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            Assets.dayTimes,
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(children: [
                  Container(
                      padding:
                          EdgeInsets.only(right: 2, left: screenWidth * 0.03),
                      width: screenWidth * 0.1,
                      height: screenWidth * 0.68,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            ...getDays(),
                          ])),
                  SizedBox(
                      width: screenWidth * 0.82,
                      height: screenWidth * 0.715,
                      child: spotsGrid(context))
                ]),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: screenWidth * 0.1),
                    Container(
                      width: screenWidth * 0.085,
                      height: screenWidth * 0.085,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 245, 196, 63),
                          borderRadius: BorderRadius.circular(3)),
                    ),
                    Text(
                      '   Unavailable / Have an Appointment',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                SizedBox(height: screenWidth * 0.02),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  SizedBox(width: screenWidth * 0.1),
                  Container(
                    width: screenWidth * 0.085,
                    height: screenWidth * 0.085,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 206, 206, 206),
                        borderRadius: BorderRadius.circular(3)),
                  ),
                  Text('   Available',
                      style: Theme.of(context).textTheme.bodySmall)
                ]),
                SizedBox(
                  height: screenWidth * 0.02,
                ),
                Row(
                  children: [
                    SizedBox(width: screenWidth * 0.1),
                    Container(
                      width: screenWidth * 0.085,
                      height: screenWidth * 0.085,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(0, 0, 0, 0),
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(
                              width: 2,
                              color: Color.fromARGB(255, 221, 220, 220))),
                    ),
                    Text('   Selected',
                        style: Theme.of(context).textTheme.bodySmall)
                  ],
                ),
                const SizedBox(height: 20),
                NextButton(title: 'Save changes', onTap: _onSaveChanges)
              ],
            )));
  }
}
