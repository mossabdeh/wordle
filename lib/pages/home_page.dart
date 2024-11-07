import 'package:flutter/material.dart';
import '../components/grid.dart';
import '../components/keyboard_row.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: const Text('Wordle'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
              flex: 7,
              child:Container(color: Colors.yellow,
              child: const Grid(),
              )),

          Expanded(
              flex: 4,
              child:Container(color: Colors.green,
              child: const Column(
                children: [
                  keyBoardRow(min: 1, max: 7,),
                  keyBoardRow(min: 8, max: 15,),
                  keyBoardRow(min: 16 ,max: 23, ),
                  keyBoardRow(min: 24,max: 29, )
                ],
              ),

              )),

        ],
      ),
    );
  }
}




