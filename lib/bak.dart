// import 'dart:developer';
// import 'dart:io';
// import 'dart:math' show Random;

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyCanvasScreen(),
//     );
//   }
// }

// class MyCanvasScreen extends StatefulWidget {
//   const MyCanvasScreen({super.key});

//   @override
//   State<MyCanvasScreen> createState() => _MyCanvasScreenState();
// }

// class _MyCanvasScreenState extends State<MyCanvasScreen> {
//   final colorMap = <(double, double), ColorFilter?>{};

//   @override
//   Widget build(BuildContext context) {
//     const width = 600.0;
//     const height = 400.0;

//     const numberOfColumns = 3 + 1;
//     const numberOfRows = 3 + 1;

//     // create a list of gestureDetectors to handle the taps on the canvas on the same position as the hinges
//     final gestureDetectors = <Widget>[];
//     for (var i = 0; i < numberOfColumns - 1; i++) {
//       final x = (width / (numberOfColumns - 1)) * i;
//       for (var j = 1; j < numberOfRows; j++) {
//         final y = (height / (numberOfRows - 1)) * j;
//         gestureDetectors.add(
//           Positioned(
//             left: x,
//             top: y - 110,
//             child: GestureDetector(
//               onTap: () {
//                 setState(() {
//                   if (colorMap[(x, y)] != null) {
//                     colorMap[(x, y)] = null;
//                   } else {
//                     colorMap[(x, y)] =
//                         const ColorFilter.mode(Colors.red, BlendMode.color);
//                   }
//                 });
//               },
//               child: Container(
//                 width: width / 4,
//                 height: height / 3.3,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     fit: BoxFit.cover,
//                     colorFilter: colorMap[(x, y)],
//                     image: FileImage(File(
//                         'F:\\Repos\\dynamic_link_project\\target_app\\trimSP_Closed.jpg')),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       }
//     }

//     return Scaffold(
//       body: Center(
//         child: ColoredBox(
//           color: Colors.black38,
//           child: Builder(builder: (context) {
//             return SizedBox(
//               width: width,
//               child: GridView.builder(
//                 shrinkWrap: true,
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: numberOfRows - 1,
//                   childAspectRatio: 3 / 2,
//                   crossAxisSpacing: 0,
//                   mainAxisSpacing: 1,
//                 ),
//                 itemCount: gestureDetectors.length,
//                 itemBuilder: (_, index) {
//                   return Padding(child: gestureDetectors[index]);
//                 },
//               ),
//             );
//             return SizedBox(
//               width: width,
//               height: height,
//               child: Stack(
//                 clipBehavior: Clip.none,
//                 fit: StackFit.expand,
//                 children: [
//                   // const CustomPaint(
//                   //   painter: MyCanvasPainter(
//                   //     numberOfColumns: numberOfColumns,
//                   //     numberOfRows: numberOfRows,
//                   //   ),
//                   // ),
//                   ...gestureDetectors,
//                 ],
//               ),
//             );
//           }),
//         ),
//       ),
//     );
//   }
// }

// class MyCanvasPainter extends CustomPainter {
//   final int numberOfColumns;
//   final int numberOfRows;

//   const MyCanvasPainter({
//     this.numberOfColumns = 5,
//     this.numberOfRows = 6,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     // draw a line
//     final linePaint = Paint()
//       ..color = const Color(0xff9CA3AF)
//       ..strokeWidth = 15;

//     for (var i = 0; i < numberOfColumns; i++) {
//       final x = (size.width / (numberOfColumns - 1)) * i;
//       canvas.drawLine(
//         Offset(x, 0),
//         Offset(x, size.height),
//         linePaint,
//       );
//     }

//     for (var i = 0; i < numberOfRows; i++) {
//       final y = (size.height / (numberOfRows - 1)) * i;

//       canvas.drawLine(
//         Offset(-8, y),
//         Offset(size.width + 8, y),
//         i == 0 ? (linePaint..strokeWidth = 20) : (linePaint..strokeWidth = 10),
//       );
//     }

//     // draw same square on the 4th column

//     // draw same square on the side bars
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return false;
//   }
// }
