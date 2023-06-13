import 'package:shakoosh_wk/data_models/Client_Account_Model.dart';
import 'package:shakoosh_wk/repository/User_Repository.dart';
import 'package:intl/intl.dart';

class AppointmentModel {
  final String id;
  final String workerId;
  final Client client;
  final ClientLocation location;
  final String appointmentDate;
  final String appointmentTime;
  final DateTime dateAndTime;
  final String details;
  final double distanceFromClient;

  AppointmentModel({
    required this.id,
    required this.workerId,
    required this.client,
    required this.dateAndTime,
    required this.location,
    required this.details,
  })  : appointmentDate = DateFormat.MMMMEEEEd().format(dateAndTime).toString(),
        appointmentTime = DateFormat.jm().format(dateAndTime).toString(),
        distanceFromClient = UserRepository.getCurrentUser()
            .getLocation()
            .geo
            .distance(lat: location.geo.latitude, lng: location.geo.longitude);

  factory AppointmentModel.fromJson(Map<String, dynamic> json, Client client) {
    return AppointmentModel(
        id: json['id'],
        workerId: json['worker_id'],
        client: client,
        details: json['details'],
        location: ClientLocation.fromJson(json['location']),
        dateAndTime: DateTime.fromMillisecondsSinceEpoch(
            json['appointment_date'] * 1000));
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'worker_id': workerId,
      'client_id': client.getId(),
      'location': location.toJson(),
      'appointment_date': dateAndTime.millisecondsSinceEpoch,
      'details': details
    };
  }

  String getId() {
    return id;
  }

  String getDate() {
    return appointmentDate;
  }

  String getTime() {
    return appointmentTime;
  }

  DateTime getDateAndTime() {
    return dateAndTime;
  }

  String getDetails() {
    return details;
  }

  ClientLocation getLocation() {
    return location;
  }

  String getDistanceFromClient() {
    if (distanceFromClient < 1) {
      return "${(distanceFromClient * 1000).toStringAsFixed(0)} m";
    } else {
      return "${distanceFromClient.toStringAsFixed(2)} km";
    }
  }

  String getTimeWalkingToClient() {
    int time = (distanceFromClient * 1000 / 109).floor();
    if (time < 10) {
      return "0${time} mins";
    } else {
      return "${time} mins";
    }
  }

  String getTimeDrivingToClient() {
    int time = (distanceFromClient * 1000 / 805).floor();
    if (time > 9) {
      return "${time} mins";
    } else {
      return "0${time} mins";
    }
  }
}
