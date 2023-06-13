import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:shakoosh_wk/data_models/Client_Account_Model.dart';
import 'package:shakoosh_wk/repository/Authentication_Repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shakoosh_wk/Assets.dart';
import 'package:shakoosh_wk/data_models/Appointment_Model.dart';
import 'package:shakoosh_wk/repository/User_Repository.dart';

class ClientRepository {
  static final _db = FirebaseFirestore.instance;
  static final userId = AuthenticationRepository.auth.currentUser!.uid;

  static List<AppointmentModel> _appointmentsList = [
    testAppointment,
    testAppointment2,
    testAppointment
  ];
  static List<AppointmentModel> _requestsList = [testAppointment3];

  static List<AppointmentModel> getAppointmentsList() {
    return _appointmentsList;
  }

  static List<AppointmentModel> getRequestsList() {
    return _requestsList;
  }

  static Future updateAppointmentsList() async {
    //_appointmentsList.clear();
    await FirebaseFirestore.instance
        .collection('appointment')
        .where('worker_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((list) {
      list.docs.map((appointment) async {
        _appointmentsList.add(AppointmentModel.fromJson(
            appointment.data(),
            Client.fromJson(await FirebaseFirestore.instance
                .collection('service_consumer')
                .doc(appointment.data()['client_id']!)
                .get()
                .then((value) {
              return (value.data()!);
            }).catchError((e) {
              print("Errrrrrror inside isssss ${e.toString()}");
            }))));
      });
    }).catchError((e) {
      print("Errrrrrror outside isssss ${e.toString()}");
    });
  }

  static Future removeAppointment(int index) async {
    _appointmentsList.removeAt(index);
    await _db
        .collection('appointment')
        .doc(_appointmentsList[index].getId())
        .delete();
  }
  // send notification

  static Future updateRequestsList() async {
    //_requestsList.clear();
    await FirebaseFirestore.instance
        .collection('request')
        .where('worker_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((list) {
      list.docs.map((appointment) async {
        _requestsList.add(AppointmentModel.fromJson(
            appointment.data(),
            Client.fromJson(await FirebaseFirestore.instance
                .collection('service_consumer')
                .doc(appointment.data()['client_id']!)
                .get()
                .then((value) {
              return (value.data()!);
            }).catchError((e) {
              print("Errrrrrror ${e.toString()}");
            }))));
      });
    }).catchError((e) {
      print("Errrrrrror ${e.toString()}");
    });
  }

  static Future<void> declineRequest(int index) async {
    _requestsList.removeAt(index);
    await _db.collection('request').doc(_requestsList[index].getId()).delete();
    // [TO DO] send notification to the client
  }

  static Future<bool> acceptRequest(int index) async {
    // the spot corresponding to the date and time of the appointment
    int spotIndex = getSpot(_requestsList[index].dateAndTime);
    if (UserRepository.getCurrentUser().timeTable[spotIndex]) {
      return false;
    } else {
      UserRepository.getCurrentUser().setTimeTableAt(spotIndex, true);
      await _db
          .collection('appointment')
          .doc(_requestsList[index].getId())
          .set(_requestsList[index].toJson());

      await _db
          .collection('request')
          .doc(_requestsList[index].getId())
          .delete();

      // [TO DO] send notification to the client
      return true;
    }
  }

  static int getSpot(DateTime date) {
    double hours = date.hour + date.minute * (5 / 300);
    date = DateTime(date.year, date.month, date.day);
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    int days = (date.difference(today).inDays);
    return (days * 8 + (hours - 9) * (2 / 3)).floor();
  }
}

Client testClient = Client(
    id: '',
    firstName: 'waleed',
    lastName: 'hegazi',
    email: 'waleed.hegazi.official@gmail.com',
    phoneNumber: '01101601978',
    creationDate: 'creationDate',
    profilePic: Assets.anonymousImage,
    profilePicURL: '',
    rate: 4.2,
    raters: 31);

AppointmentModel testAppointment = AppointmentModel(
    id: 'id',
    workerId: 'id',
    client: testClient,
    location: ClientLocation(
        city: 'giza',
        street: 'Amer',
        buildingNo: '12',
        floorNo: '8',
        apartmentNo: '23',
        geo: GeoFirePoint(
            UserRepository.getCurrentUser().getLocation().geo.latitude + 0.05,
            UserRepository.getCurrentUser().getLocation().geo.longitude +
                0.05)),
    dateAndTime: DateTime.now(),
    details:
        'details details details details details details details details details');

AppointmentModel testAppointment2 = AppointmentModel(
    id: 'id',
    workerId: 'id',
    client: testClient,
    location: ClientLocation(
        city: 'Cairo',
        street: 'Abdo-Basha',
        buildingNo: '9',
        floorNo: '12',
        apartmentNo: '20',
        geo: GeoFirePoint(
            UserRepository.getCurrentUser().getLocation().geo.latitude + 0.04,
            UserRepository.getCurrentUser().getLocation().geo.longitude +
                0.02)),
    dateAndTime: DateTime.now()
        .add(Duration(days: 3, hours: 1, minutes: 6, microseconds: 20)),
    details:
        'details details details details details details details details details');

AppointmentModel testAppointment3 = AppointmentModel(
    id: 'id',
    workerId: 'id',
    client: testClient,
    location: ClientLocation(
        city: '6-October',
        street: 'Al-Twheed',
        buildingNo: '126',
        floorNo: '2',
        apartmentNo: '4',
        geo: GeoFirePoint(
            UserRepository.getCurrentUser().getLocation().geo.latitude + 0.06,
            UserRepository.getCurrentUser().getLocation().geo.longitude +
                0.05)),
    dateAndTime: DateTime.now()
        .add(Duration(days: 1, hours: 3, minutes: 2, microseconds: 71)),
    details:
        'details details details details details details details details details');
