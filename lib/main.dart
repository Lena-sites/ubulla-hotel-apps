import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget{
  const HomePage({super.key});
  @override
  State<StatefulWidget> createState()=>_MyAppState();
}

class _MyAppState extends State<HomePage>{
  //isi variabel

  @override
  Widget build(BuildContext context){
    // mengambil ukuran layar
    final screenWidth = MediaQuery.of(context).size.width;
    //jika lebar >600 dianggap layarnya lebar/besar
    final isLargeScreen = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTcbuof2CQfWRGirFLEiJbIaRm4WSmNOgnuZq7LDiTdxA&s=10',
                width: 90,
                height: 100,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [

          ],
        ),
      )
    );
  }
}