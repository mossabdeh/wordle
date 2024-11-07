import 'package:flutter/material.dart';

import '../constants/keyboard.dart';

class keyBoardRow extends StatelessWidget {
  const keyBoardRow({required this.min , required this.max,
    Key? key,
  });

  final int min , max ;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    int index = 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: keyboardState.entries.map((e) {
        index++;
        if (index >= min && index <= max) {
          return Padding(
            padding:  EdgeInsets.all(size.width * 0.006),
            child : ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Container(
              color: Colors.red,
              width: e.key.displayName == 'ENTER' || e.key.displayName == 'DEL' ?
              size.width * 0.2 :
              size.width * 0.11,
              height: size.height * 0.065,
              child : Material(
                child: InkWell(
                  onTap:(){} ,
                child : Center(child:Text(e.key.displayName))),
              )),
            )); // Use `displayName` here
        } else {
          return const SizedBox();
        }
      }).toList(),
    );
  }


}