import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:shakoosh_wk/Shakoosh_icons.dart';
import 'package:shakoosh_wk/register/Register_Next_Button.dart';

class ProfessionAndPriceToggle extends StatelessWidget {
  final void Function(int? professionIndex) setProfession;
  final void Function() onButtonTap;
  final String buttonTitle;
  final int professionIndex;

  const ProfessionAndPriceToggle(
      {required this.setProfession,
      required this.onButtonTap,
      required this.buttonTitle,
      required this.professionIndex,
      super.key});

  @override
  Widget build(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('I\'m a/an',
            style:
                Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 20)),
        SizedBox(height: 40),
        ToggleSwitch(
          dividerColor: Colors.grey,
          fontSize: 16,
          iconSize: 30,
          isVertical: true,
          minWidth: 250.0,
          radiusStyle: true,
          cornerRadius: 15,
          initialLabelIndex: professionIndex,
          activeBgColor: [Color.fromARGB(255, 245, 196, 63)],
          activeFgColor: Theme.of(context).colorScheme.tertiary,
          inactiveBgColor: Theme.of(context).colorScheme.tertiary,
          inactiveFgColor: Theme.of(context).colorScheme.secondary,
          labels: [
            'Plumber',
            'Carpenter',
            'Bricklayer',
            'Decorator',
            'Electrician'
          ],
          icons: [
            ShakooshIcons.plumber2,
            ShakooshIcons.carpenter2,
            ShakooshIcons.bricklayer2,
            ShakooshIcons.decorator1,
            ShakooshIcons.electrician2
          ],
          onToggle: (index) {
            setProfession(index);
          },
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
        ),
        NextButton(onTap: onButtonTap, title: buttonTitle)
      ],
    );
  }
}
