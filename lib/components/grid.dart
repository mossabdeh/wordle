import 'package:flutter/material.dart';

import 'letter_taped_widget.dart';

class Grid extends StatelessWidget {
  const Grid({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder( /* Scrollable 2D array */
        itemCount: 30,
        padding: EdgeInsets.fromLTRB(36, 20, 36, 20),
        //physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            crossAxisCount: 5  /* The number of Columns (Vertical Scroll) */
        ),
        itemBuilder:(context , index){
          return Container(
          decoration: BoxDecoration(
            border: Border.all() //
          ),
            child: LetterTapedWidget(index: index,),
          );
        }
    );
  }
}
