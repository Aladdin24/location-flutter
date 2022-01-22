import 'package:flutter/material.dart';
import 'package:location/utils/utils.dart';

class SpecificsCard1 extends StatelessWidget {
  final String name;
  final String name2;

  SpecificsCard1({required this.name, required this.name2});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        height: 80,
        width: 120,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Text(
              name,
              style: BasicHeading,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              name2,
              style: SubHeading,
            ),
          ],
        ));
  }
}
