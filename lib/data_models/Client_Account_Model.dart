import 'package:flutter/material.dart';
import 'package:shakoosh_wk/Assets.dart';
import 'package:flutter_svg/flutter_svg.dart';
//import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Client {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String creationDate;
  final String phoneNumber;
  final String profilePicURL;
  final Image profilePic;
  final double rate;
  final int raters;

  Client({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.creationDate,
    required this.profilePic,
    required this.profilePicURL,
    required this.rate,
    required this.raters,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
        id: json['id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        email: json['email'],
        phoneNumber: json['phone_number'],
        rate: json['rate_ratio'],
        raters: json['number_of_raters'],
        creationDate: json['creation_date'],
        profilePicURL: json['profile_pic_url'],
        profilePic: (json['profile_pic_url'] != null)
            ? Image.network(json['profile_pic_url'])
            : Assets.anonymousImage);
  }

  Image getProfilePic() {
    return profilePic;
  }

  String getEmail() {
    return email;
  }

  String getFirstName() {
    return firstName;
  }

  String getLastName() {
    return lastName;
  }

  double getRate() {
    return rate;
  }

  int getRaters() {
    return raters;
  }

  String getPhoneNumberFormatted() {
    return "(+2) ${phoneNumber.substring(0, 3)} ${phoneNumber.substring(3, 7)} ${phoneNumber.substring(7)}";
  }

  String getCreationDate() {
    return creationDate;
  }

  String getId() {
    return id;
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

class ClientLocation {
  final String city;
  final String street;
  final String buildingNo;
  final String floorNo;
  final String apartmentNo;
  final GeoFirePoint geo;
  ClientLocation({
    required this.city,
    required this.street,
    required this.buildingNo,
    required this.floorNo,
    required this.apartmentNo,
    required this.geo,
  });

  factory ClientLocation.fromJson(Map<String, dynamic> json) {
    return ClientLocation(
        geo: GeoFirePoint(json['geo']['geopoint'].latitude,
            json['geo']['geopoint'].longitude),
        city: json['city'],
        street: json['street'],
        buildingNo: json['building_number'],
        floorNo: json['floor_number'],
        apartmentNo: json['apartment_number']);
  }

  Map<String, dynamic> toJson() {
    return {
      'geo': geo.data,
      'city': city,
      'street': street,
      'building_number': buildingNo,
      'floor_number': floorNo,
      'apartment_number': apartmentNo
    };
  }
}
