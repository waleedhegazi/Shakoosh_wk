import 'package:flutter/material.dart';
import 'package:shakoosh_wk/Custom_Page_Route.dart';
import 'package:shakoosh_wk/data_models/Appointment_Model.dart';
import 'package:shakoosh_wk/logged in/appointment/Client_Profile_Screen.dart';
import 'package:shakoosh_wk/repository/Client_Repository.dart';
import 'package:shakoosh_wk/register/Register_Next_Button.dart';
import 'package:shakoosh_wk/Dialogs.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});
  @override
  State<AppointmentsScreen> createState() {
    return _AppointmentsScreenState();
  }
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  List<AppointmentModel> list = ClientRepository.getAppointmentsList();
  int listIndex = 0;
  bool isOnReq = false;

  void _switchPage(int index) {
    switch (index) {
      case 0:
        list = ClientRepository.getAppointmentsList();
        isOnReq = false;
        break;
      case 1:
        list = ClientRepository.getRequestsList();
        isOnReq = true;
    }
    setState(() {});
  }

  void _openProfile(int index) {
    Navigator.of(context).push(CustomPageRoute(
        child: ClientProfile(appointmentIndex: index, isReq: isOnReq)));
  }

  void _cancelAppointment(int index) {
    Dialogs.showCustomizedTextDialog(context, () {
      _deleteAppointment(index);
    }, 'Are you sure you want to cancel this appointment? This may affect your rate.',
        'Confirm', 'Cancel');
  }

  void _deleteAppointment(int index) {
    setState(() {
      ClientRepository.removeAppointment(index);
    });
  }

  void _acceptRequest(int index) {
    setState(() {
      ClientRepository.acceptRequest(index);
    });
  }

  void _declineRequest(int index) {
    setState(() {
      ClientRepository.declineRequest(index);
    });
  }

  void _declineConfitmation(int index) {
    Dialogs.showCustomizedTextDialog(context, () {
      _declineRequest(index);
    }, 'Are you sure you want to decline this request?', 'Decline', 'Cancel');
  }

  @override
  Widget build(context) {
    double screenHeight = (MediaQuery.of(context).size.height) -
        (MediaQuery.of(context).padding.top) -
        (MediaQuery.of(context).padding.bottom);
    double screenWidth = (MediaQuery.of(context).size.width);
    listIndex = 0;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight * 0.07),
          child: AppBar(
            title: SizedBox(
              width: screenWidth,
              child: Text("My appointments",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge),
            ),
          )),
      body: SizedBox(
          height: screenHeight * 0.85,
          child: Column(children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: screenWidth * 0.025),
              child: ToggleSwitch(
                minWidth: double.infinity,
                initialLabelIndex: isOnReq ? 1 : 0,
                cornerRadius: 10.0,
                labels: [
                  'Appointments  ( ${ClientRepository.getAppointmentsList().length} )',
                  'Requests  ( ${ClientRepository.getRequestsList().length} )'
                ],
                activeBgColor: [const Color.fromARGB(255, 245, 196, 63)],
                inactiveBgColor: Theme.of(context).colorScheme.tertiary,
                activeFgColor: Theme.of(context).colorScheme.tertiary,
                inactiveFgColor: Theme.of(context).colorScheme.secondary,
                onToggle: (index) {
                  _switchPage(index!);
                },
              ),
            ),
            SizedBox(
                height: screenHeight * 0.75,
                child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (ctx, index) {
                      return AppointmentCard(
                        appointmentIndex: listIndex++,
                        openProfile: _openProfile,
                        cancelAppointment: _cancelAppointment,
                        acceptRequest: _acceptRequest,
                        declineRequest: _declineConfitmation,
                        isOnReq: isOnReq,
                      );
                    }))
          ])),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final void Function(int index) openProfile;
  final void Function(int index) cancelAppointment;
  final void Function(int index) acceptRequest;
  final void Function(int index) declineRequest;
  final bool isOnReq;
  final int appointmentIndex;
  final AppointmentModel appointment;
  AppointmentCard(
      {required this.appointmentIndex,
      required this.isOnReq,
      required this.openProfile,
      required this.cancelAppointment,
      required this.acceptRequest,
      required this.declineRequest,
      super.key})
      : appointment = isOnReq
            ? ClientRepository.getRequestsList()[appointmentIndex]
            : ClientRepository.getAppointmentsList()[appointmentIndex];
  @override
  Widget build(context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Card(
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: screenWidth * 0.025, horizontal: screenWidth * 0.05),
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(right: screenWidth * 0.04),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: screenWidth * 0.2,
                        width: screenWidth * 0.2,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: appointment.client.getProfilePic(),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: screenWidth * 0.25,
                        child: FittedBox(
                          child: Text(
                            "${appointment.client.getFirstName()} ${appointment.client.getLastName()}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(appointment.client.getRate().toString(),
                              style: Theme.of(context).textTheme.bodyLarge),
                          const SizedBox(
                            width: 2,
                          ),
                          SizedBox(
                              width: 15,
                              height: 15,
                              child: appointment.client.getStar()),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(appointment.client.getRaters().toString(),
                              style: Theme.of(context).textTheme.bodyLarge),
                          SizedBox(width: 2),
                          const Icon(Icons.people_alt, size: 18)
                        ],
                      ),
                      SizedBox(height: 5),
                      SizedBox(
                        width: screenWidth * 0.25,
                        child: NextButton(
                            title: 'View',
                            onTap: () {
                              openProfile(appointmentIndex);
                            }),
                      )
                    ]),
              ),
              Container(
                  width: screenWidth * 0.55,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Theme.of(context).colorScheme.tertiary),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      SizedBox(
                        width: screenWidth * 0.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('On: ${appointment.getDate()}',
                                style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(height: 4),
                            Text('${appointment.getTime()}',
                                style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Divider(
                        color: Theme.of(context).colorScheme.secondary,
                        thickness: 1,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('City:  ${appointment.getLocation().city}',
                                  style: Theme.of(context).textTheme.bodySmall),
                              const SizedBox(height: 2),
                              Text('St:  ${appointment.getLocation().street}',
                                  style: Theme.of(context).textTheme.bodySmall),
                              const SizedBox(height: 2),
                              Text(
                                  'Building:  ${appointment.getLocation().buildingNo}',
                                  style: Theme.of(context).textTheme.bodySmall),
                              const SizedBox(height: 2),
                              Text(
                                  'Floor:  ${appointment.getLocation().floorNo}',
                                  style: Theme.of(context).textTheme.bodySmall),
                              const SizedBox(height: 2),
                              Text(
                                  'Apartment:  ${appointment.getLocation().apartmentNo}',
                                  style: Theme.of(context).textTheme.bodySmall),
                            ],
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(children: [
                                  Icon(Icons.social_distance),
                                  SizedBox(width: 5),
                                  Text(
                                    '${appointment.getDistanceFromClient()}',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  )
                                ]),
                                SizedBox(height: 2),
                                Row(children: [
                                  Icon(Icons.directions_walk),
                                  SizedBox(width: 5),
                                  Text(
                                    '${appointment.getTimeWalkingToClient()}',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  )
                                ]),
                                SizedBox(height: 2),
                                Row(
                                  children: [
                                    Icon(Icons.two_wheeler),
                                    SizedBox(width: 5),
                                    Text(
                                        '${appointment.getTimeDrivingToClient()}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall),
                                  ],
                                )
                              ])
                        ],
                      ),
                      const SizedBox(height: 10),
                      Divider(
                        color: Theme.of(context).colorScheme.secondary,
                        thickness: 1,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Details: ${appointment.getDetails()}',
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          isOnReq
                              ? Row(
                                  children: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: Colors.green),
                                      onPressed: () {
                                        acceptRequest(appointmentIndex);
                                      },
                                      child: Text(
                                        'Accept',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary),
                                      ),
                                    ),
                                    SizedBox(width: 3),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                          backgroundColor: Colors.red),
                                      onPressed: () {
                                        declineRequest(appointmentIndex);
                                      },
                                      child: Text(
                                        'Decline',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .tertiary),
                                      ),
                                    )
                                  ],
                                )
                              : TextButton(
                                  onPressed: () {
                                    cancelAppointment(appointmentIndex);
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.transparent),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  ))
                        ],
                      )
                    ],
                  )),
            ]),
      ),
    );
  }
}
