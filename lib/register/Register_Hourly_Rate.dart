import 'package:flutter/material.dart';
import 'package:shakoosh_wk/register/Register_Next_Button.dart';

class HourlyRateInput extends StatelessWidget {
  final void Function(int hourlyRate) setHourlyRate;
  final void Function() onButtonTap;
  final String buttonTitle;
  final int price;

  const HourlyRateInput(
      {required this.setHourlyRate,
      required this.onButtonTap,
      required this.buttonTitle,
      required this.price,
      super.key});
  void _increment() {
    if (price < 200) {
      setHourlyRate(price + 10);
    }
  }

  void _decrement() {
    if (price > 40) {
      setHourlyRate(price - 10);
    }
  }

  @override
  Widget build(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('How much do you want to charge per hour',
            style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 50),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          InkWell(
            onTap: _decrement,
            child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (price > 40)
                        ? Color.fromARGB(255, 245, 196, 63)
                        : Colors.grey),
                child: Center(
                    child: Text('-',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).colorScheme.tertiary)))),
          ),
          Text(
            '   $price EGP  ',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Theme.of(context).colorScheme.secondary),
          ),
          InkWell(
            onTap: _increment,
            child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (price < 200)
                        ? Color.fromARGB(255, 245, 196, 63)
                        : Colors.grey),
                child: Center(
                    child: Text(
                  '+',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Theme.of(context).colorScheme.tertiary),
                ))),
          ),
        ]),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
        ),
        NextButton(onTap: onButtonTap, title: buttonTitle)
      ],
    );
  }
}
