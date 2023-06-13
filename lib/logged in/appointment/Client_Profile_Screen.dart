import 'package:flutter/material.dart';
import 'package:shakoosh_wk/data_models/Client_Account_Model.dart';
import 'package:shakoosh_wk/repository/Client_Repository.dart';

class ClientProfile extends StatelessWidget {
  final int appointmentIndex;
  final bool isReq;
  final Client client;
  ClientProfile(
      {required this.appointmentIndex, required this.isReq, super.key})
      : client = isReq
            ? ClientRepository.getRequestsList()[appointmentIndex].client
            : ClientRepository.getAppointmentsList()[appointmentIndex].client;

  @override
  Widget build(context) {
    double screenHeight = (MediaQuery.of(context).size.height) -
        (MediaQuery.of(context).padding.top) -
        (MediaQuery.of(context).padding.bottom);
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
              title: Text("${client.getFirstName()}'s profile",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge),
            )),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              SizedBox(
                height: screenHeight * 0.2,
                width: screenHeight * 0.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: client.getProfilePic(),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "${client.getFirstName()} ${client.getLastName()}",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(client.getRate().toString(),
                      style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(
                    width: 2,
                  ),
                  SizedBox(width: 15, height: 15, child: client.getStar()),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(client.getRaters().toString(),
                      style: Theme.of(context).textTheme.bodyLarge),
                  SizedBox(width: 2),
                  const Icon(Icons.people_alt, size: 18)
                ],
              ),
              const SizedBox(height: 10),
              Text(
                client.getEmail(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.phone, size: 18),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  client.getPhoneNumberFormatted(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(width: 10)
              ]),
            ]));
  }
}
