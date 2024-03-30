import 'dart:async';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

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
  final doorPaths = <(int, int), String?>{};

  Color? overlayColor;
  Color? backgroundColor;
  Color? tileBackgroundColor;

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

  var doorWidthInches = 8;
  var doorHeightInches = 7;

  @override
  Widget build(BuildContext context) {
    const dpi = 96.0;
    final width =
        doorWidthInches * dpi / 2; // why divide by 2? idk but it works
    final height = doorHeightInches * dpi / 2;

    // final width = imageWidth * 4 + (imageWidth / 2);
    // final height = imageHeight * 4 + (imageHeight / 2);

    final numberOfColumns = (width / imageWidth).round();
    final numberOfRows = (height / imageHeight).round();

    log({
      'imageWidth': imageWidth,
      'imageHeight': imageHeight,
      'width': width,
      'height': height,
      'numberOfColumns': numberOfColumns,
      'numberOfRows': numberOfRows,
    }.toString().replaceAll(',', ',\n'));

    final gestureDetectors = <Widget>[];
    // for (var i = 0; i < numberOfColumns; i++) {
    for (var j = 0; j < numberOfRows * numberOfColumns; j++) {
      final posX = j % numberOfColumns;
      final posY = j ~/ numberOfColumns;
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
                              doorPaths[(posX, posY)] =
                                  'assets/image_$index.png';
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
              color: tileBackgroundColor,
              image: DecorationImage(
                fit: BoxFit.fill,
                colorFilter: ColorFilter.mode(
                  overlayColor ?? Colors.transparent,
                  BlendMode.color,
                ),
                image: AssetImage(
                  (doorPaths[(posX, posY)] ?? 'assets/image_0.png'),
                ),
              ),
            ),
          ),
        ),
      );
      // }
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // open bottom sheet from scaffold
          showModalBottomSheet(
            enableDrag: true,
            isScrollControlled: true,
            context: context,
            builder: (context) {
              // show a color picker for the three colors
              return ListView(
                children: [
                  TextField(
                    controller:
                        TextEditingController(text: doorWidthInches.toString()),
                    // width of the door
                    decoration: const InputDecoration(
                      labelText: 'Width',
                    ),
                    // format the input to be a number
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          doorWidthInches = int.parse(value);
                        });
                      }
                    },
                  ),
                  TextField(
                    controller: TextEditingController(
                        text: doorHeightInches.toString()),
                    // height of the door
                    decoration: const InputDecoration(
                      labelText: 'Height',
                    ),
                    // format the input to be a number
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          doorHeightInches = int.parse(value);
                        });
                      }
                    },
                  ),
                  ColorPicker(
                    title: const Text('Overlay Color'),
                    pickersEnabled: const {
                      ColorPickerType.primary: false,
                      ColorPickerType.accent: false,
                      ColorPickerType.bw: false,
                      ColorPickerType.custom: false,
                      ColorPickerType.wheel: true,
                    },
                    color: overlayColor ?? Colors.transparent,
                    onColorChanged: (color) {
                      setState(() {
                        overlayColor = color;
                      });
                    },
                  ),
                  ColorPicker(
                    title: const Text('Background Color'),
                    pickersEnabled: const {
                      ColorPickerType.primary: false,
                      ColorPickerType.accent: false,
                      ColorPickerType.bw: false,
                      ColorPickerType.custom: false,
                      ColorPickerType.wheel: true,
                    },
                    color: backgroundColor ?? Colors.transparent,
                    onColorChanged: (color) {
                      setState(() {
                        backgroundColor = color;
                      });
                    },
                  ),
                  ColorPicker(
                    title: const Text('Tile Background Color'),
                    pickersEnabled: const {
                      ColorPickerType.primary: false,
                      ColorPickerType.accent: false,
                      ColorPickerType.bw: false,
                      ColorPickerType.custom: false,
                      ColorPickerType.wheel: true,
                    },
                    color: tileBackgroundColor ?? Colors.transparent,
                    onColorChanged: (color) {
                      setState(() {
                        tileBackgroundColor = color;
                      });
                    },
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.open_in_browser),
      ),
      body: Center(
        child: Builder(builder: (context) {
          return Container(
            width: width,
            color: backgroundColor ?? Colors.black38,
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
                return gestureDetectors[index];
              },
            ),
          );
        }),
      ),
    );
  }
}
