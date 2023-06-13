import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shakoosh_wk/Assets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
//import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:shakoosh_wk/Shakoosh_icons.dart';

class UserAccountModel {
  final String id;
  final String profession;
  String hourlyRate;
  String email;
  String password;
  String firstName;
  String lastName;
  final bool isActive;
  final String creationDate;
  String phoneNumber;
  String? profilePicURL;
  Image? profilePic;
  SvgPicture star = Assets.ratingStarsImages[5];
  double rate = 5;
  int raters;
  Location location;
  List<dynamic> timeTable;

  UserAccountModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.creationDate,
    this.profilePicURL,
    this.profilePic,
    this.rate = 5,
    this.raters = 0,
    required this.location,
    required this.hourlyRate,
    required this.profession,
    this.timeTable = const [
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false
    ],
    required this.isActive,
  });

  factory UserAccountModel.fromJson(Map<String, dynamic> json) {
    return UserAccountModel(
        id: json['id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        email: json['email'],
        password: json['password'],
        phoneNumber: json['phone_number'],
        rate: json['rate_ratio'],
        raters: json['number_of_raters'],
        creationDate: json['creation_date'],
        profilePicURL: json['profile_pic_url'],
        profession: json['profession'],
        hourlyRate: json['hourly_rate'],
        isActive: json['is_active'],
        timeTable: json['time_table'],
        profilePic: (json['profile_pic_url'] != null)
            ? Image.network(json['profile_pic_url'])
            : null,
        location: Location.fromJson(json['location']));
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "password": password,
      "phone_number": phoneNumber,
      "rate_ratio": rate,
      "number_of_raters": raters,
      "creation_date": creationDate,
      "location": location.toJson(),
      "hourly_rate": hourlyRate,
      "profession": profession,
      "is_active": isActive,
      "time_table": timeTable,
      "profile_pic_url": profilePicURL
    };
  }

  void setProfilePicURL(String? newURL) {
    profilePicURL = newURL;
  }

  void setProfilePic(String newURL) {
    profilePic = Image.network(newURL);
  }

  String? getProfilePicURL() {
    return profilePicURL;
  }

  Image getProfilePic() {
    if (profilePicURL != null) {
      return profilePic!;
    } else {
      return Assets.anonymousImage;
    }
  }

  String getId() {
    return id;
  }

  String getEmail() {
    return email;
  }

  void setEmail(String email) {
    this.email = email;
  }

  String getFirstName() {
    return firstName;
  }

  void setFirstName(String firstName) {
    this.firstName = firstName;
  }

  String getLastName() {
    return lastName;
  }

  void setLastName(String lastName) {
    this.lastName = lastName;
  }

  String getPassword() {
    return password;
  }

  void setPassword(String password) {
    this.password = password;
  }

  double getRate() {
    return rate;
  }

  int getRaters() {
    return raters;
  }

  String getPhoneNumber() {
    return phoneNumber;
  }

  String getPhoneNumberFormatted() {
    return "(+2) ${phoneNumber.substring(0, 3)} ${phoneNumber.substring(3, 7)} ${phoneNumber.substring(7)}";
  }

  void setPhoneNumber(String phoneNumber) {
    this.phoneNumber = phoneNumber;
  }

  String getCreationDate() {
    return creationDate;
  }

  Location getLocation() {
    return location;
  }

  void setLocation(Location newLocation) {
    location = newLocation;
  }

  String getHourlyRate() {
    return hourlyRate;
  }

  void setHourlyRate(String newHourlyRate) {
    hourlyRate = newHourlyRate;
  }

  String getProfession() {
    return profession;
  }

  List<dynamic> getTimeTable() {
    return timeTable;
  }

  void setTimeTable(List<dynamic> newTable) {
    timeTable = [...newTable];
  }

  void setTimeTableAt(int index, bool value) {
    timeTable[index] = value;
  }

  IconData getIconData() {
    switch (profession) {
      case 'Carpenter':
        return ShakooshIcons.carpenter2;
      case 'Plumber':
        return ShakooshIcons.plumber2;
      case 'Painter':
        return ShakooshIcons.decorator1;
      case 'Electrician':
        return ShakooshIcons.electrician2;
      case 'Bricklayer':
        return ShakooshIcons.bricklayer2;
    }
    return ShakooshIcons.logo_transparent_black_2;
  }

  SvgPicture getStar() {
    if (rate == 5) {
      return Assets.ratingStarsImages[5];
    }
    if (rate > 4) {
      return Assets.ratingStarsImages[4];
    }
    if (rate > 3) {
      return Assets.ratingStarsImages[3];
    }
    if (rate > 2) {
      return Assets.ratingStarsImages[2];
    }
    if (rate > 1) {
      return Assets.ratingStarsImages[1];
    }
    return Assets.ratingStarsImages[0];
  }
}

class Location {
  final String city;
  final String district;
  final GeoFirePoint geo;
  final bool isVisible = true;
  Location({
    required this.city,
    required this.district,
    required this.geo,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
        geo: GeoFirePoint(json['geo']['geopoint'].latitude,
            json['geo']['geopoint'].longitude),
        city: json['city'],
        district: json['district']);
  }

  Map<String, dynamic> toJson() {
    return {
      'geo': geo.data,
      'city': city,
      'district': district,
      'is_visible': isVisible
    };
  }
}

class Accounts {
  static UserAccountModel dummyAccount = UserAccountModel(
      id: "id",
      firstName: 'loading',
      lastName: '',
      email: 'user.email',
      password: 'Cars44',
      phoneNumber: '01100000000',
      profession: 'loading',
      hourlyRate: '-',
      isActive: false,
      timeTable: [],
      location:
          Location(city: 'Giza', district: 'Faisal', geo: GeoFirePoint(20, 10)),
      creationDate: (DateFormat.yMMMd().format(DateTime.now())).toString());

  static bool isEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  static bool hasLowerCase(String password) {
    return RegExp(r"^(?=.*[a-z])").hasMatch(password);
  }

  static bool hasUpperCase(String password) {
    return RegExp(r"^(?=.*[A-Z])").hasMatch(password);
  }

  static bool hasDigits(String password) {
    return RegExp(r"^(?=.*?[0-9])").hasMatch(password);
  }

  static bool hasSpecialChar(String password) {
    return RegExp(r"^(?=.*?[!@#\$&*~])").hasMatch(password);
  }

  static bool hasCharsOnly(String text) {
    return RegExp(r"^([A-Za-z\s]+$)").hasMatch(text);
  }
}
