import 'package:shakoosh_wk/Shakoosh_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:shakoosh_wk/logged in/profile/Location_Picker.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:shakoosh_wk/register/Register_Next_Button.dart';
import 'package:shakoosh_wk/SnackBars.dart';

class LocationPicker extends StatelessWidget {
  final TextEditingController cityController;
  final TextEditingController districtController;
  final String? cityErrorText;
  final String? districtErrorText;
  final String? pointErrorText;
  final String buttonTitle;
  final bool showError;
  final bool locationIsPicked;
  final void Function() onButtonTap;
  final void Function(GeoPoint point) setPoint;

  const LocationPicker(
      {required this.cityErrorText,
      required this.locationIsPicked,
      required this.showError,
      required this.pointErrorText,
      required this.districtErrorText,
      required this.buttonTitle,
      required this.onButtonTap,
      required this.cityController,
      required this.districtController,
      required this.setPoint,
      super.key});

  void _setPoint(BuildContext context) async {
    GeoPoint? pickedLocation = await showSimplePickerLocation(
      context: context,
      isDismissible: true,
      initCurrentUserPosition: true,
    );
    if (pickedLocation != null) {
      setPoint(pickedLocation);
      SnackBars.showMessage(context, "Location is picked");
    }
  }

  @override
  Widget build(context) {
    double screenHeight = (MediaQuery.of(context).size.height) -
        (MediaQuery.of(context).padding.top) -
        (MediaQuery.of(context).padding.bottom);
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Fill the following location information',
              style: Theme.of(context).textTheme.bodyLarge),
          SizedBox(height: 40),
          LocationTextField(
            textController: cityController,
            error: cityErrorText,
            showError: showError,
            hint: "ex: Giza",
            label: "City",
            widgetWidth: screenWidth * 0.6,
            limit: 15,
          ),
          SizedBox(
            height: screenWidth * 0.02,
          ),
          LocationTextField(
            textController: districtController,
            error: districtErrorText,
            showError: showError,
            hint: "ex: Faisal",
            label: "District",
            widgetWidth: screenWidth * 0.6,
            limit: 15,
          ),
          SizedBox(
            height: screenWidth * 0.02,
          ),
          InkWell(
            onTap: () {
              _setPoint(context);
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 20),
              width: screenWidth * 0.6,
              height: screenHeight * 0.08,
              decoration: BoxDecoration(
                  color: locationIsPicked
                      ? Color.fromARGB(255, 245, 196, 63)
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(30)),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  'Location ',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.tertiary),
                ),
                Icon(
                  ShakooshIcons.helmet_marker,
                  color: Theme.of(context).colorScheme.tertiary,
                  size: 35,
                )
              ]),
            ),
          ),
          Text(
            (showError && pointErrorText != null) ? pointErrorText! : '',
            style: const TextStyle(color: Color.fromARGB(255, 167, 34, 24)),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          NextButton(onTap: onButtonTap, title: buttonTitle)
        ]);
  }
}

class LocationTextField extends StatelessWidget {
  const LocationTextField(
      {required this.widgetWidth,
      required this.error,
      required this.showError,
      required this.hint,
      required this.limit,
      required this.label,
      required this.textController,
      super.key});
  final TextEditingController textController;
  final double widgetWidth;
  final int limit;
  final String hint;
  final String label;
  final String? error;
  final bool showError;

  @override
  Widget build(context) {
    return SizedBox(
      width: widgetWidth,
      child: TextField(
        keyboardType: TextInputType.name,
        textCapitalization: TextCapitalization.sentences,
        maxLength: limit,
        controller: textController,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary, width: 1)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary, width: 3)),
          errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(
                  color: Color.fromARGB(255, 167, 34, 24), width: 1)),
          focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(
                  color: Color.fromARGB(255, 167, 34, 24), width: 3)),
          errorStyle: const TextStyle(color: Color.fromARGB(255, 167, 34, 24)),
          errorText: showError ? error : null,
          labelText: label,
          labelStyle: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
