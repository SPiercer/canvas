import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyCanvasScreen(),
    );
  }
}

class MyCanvasScreen extends StatefulWidget {
  const MyCanvasScreen({super.key});

  @override
  State<MyCanvasScreen> createState() => _MyCanvasScreenState();
}

class _MyCanvasScreenState extends State<MyCanvasScreen> {
  final colorMap = <(double, double), ColorFilter?>{};
  String path = 'assets/image_0.png';
  double imageWidth = 0;
  double imageHeight = 0;
  final doorPaths = {(0, 0): ''};

  Future<void> init() async {
    // get image size hight and width
    final image = AssetImage(path);
    final completer = Completer<ui.Image>();
    image.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener((info, _) => completer.complete(info.image)));
    await completer.future.then((image) {
      log('image width: ${image.width}\nimage height: ${image.height}');
      setState(() {
        imageWidth = image.width.toDouble();
        imageHeight = image.height.toDouble();
      });
    });
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const dpi = 94.0;

    const width = 8 * dpi / 2;
    const height = 7 * dpi / 2;

    // final width = imageWidth * 4 + (imageWidth / 2);
    // final height = imageHeight * 4 + (imageHeight / 2);

    final numberOfColumns = (width ~/ imageWidth);
    final numberOfRows = (height ~/ imageHeight);

    log({
      'imageWidth': imageWidth,
      'imageHeight': imageHeight,
      'width': width,
      'height': height,
      'numberOfColumns': numberOfColumns,
      'numberOfRows': numberOfRows,
    }.toString().replaceAll(',', ',\n'));

    final gestureDetectors = <Widget>[];
    for (var i = 0; i < numberOfColumns; i++) {
      for (var j = 1; j < numberOfRows; j++) {
        gestureDetectors.add(
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    // get all items in assets folder

                    return Dialog(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                        ),
                        itemCount: 5,
                        itemBuilder: (_, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                              setState(() {
                                path = 'assets/image_$index.png';
                              });
                              init();
                            },
                            child: Image.asset(
                              'assets/image_$index.png',
                              errorBuilder: (context, error, stackTrace) =>
                                  const SizedBox(),
                            ),
                          );
                        },
                      ),
                    );
                  });
            },
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff2242c7).withOpacity(.2),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  // colorFilter:
                  //     ColorFilter.mode(Color(0xfff5e1c8), BlendMode.color),
                  // colorFilter: colorMap[(x, y)],
                  image:
                      AssetImage((true != null ? path : 'assets/image_0.png')),
                ),
              ),
            ),
          ),
        );
      }
    }

    return Scaffold(
      body: Center(
        child: Builder(builder: (context) {
          return Container(
            color: Colors.black38,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: numberOfColumns,
                childAspectRatio: imageWidth / imageHeight,
                crossAxisSpacing: 0,
                mainAxisSpacing: 1,
              ),
              itemCount: gestureDetectors.length,
              itemBuilder: (_, index) {
                if (index % (numberOfRows - 1) == 0) {
                  return ColoredBox(
                    color: const Color(0xffd5d5d5),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: 10,
                      ),
                      child: gestureDetectors[index],
                    ),
                  );
                }

                if (index % (numberOfRows - 1) == numberOfRows - 2) {
                  return ColoredBox(
                    color: const Color(0xffd5d5d5),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(
                        end: 10,
                      ),
                      child: gestureDetectors[index],
                    ),
                  );
                }

                return gestureDetectors[index];
              },
            ),
          );
        }),
      ),
    );
  }
}
