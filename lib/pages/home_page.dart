import 'package:flutter/material.dart';

import '../components/grid.dart';

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
        title: Text('Wordle'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
              flex: 7,
              child:Container(color: Colors.yellow,
              child: Grid(),
              )),

          Expanded(
              flex: 4,
              child:Container(color: Colors.green,)),
        ],
      ),
    );
  }
}


