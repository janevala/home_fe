// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';
// import 'dart:ui' as ui;

// import 'package:ext_storage/ext_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_benchmark/models/transitions_test_models/transitions_config_model.dart';
// import 'package:flutter_benchmark/utils/app_localizations.dart';
// import 'package:flutter_benchmark/utils/helper_functions.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:video_player/video_player.dart';

// class TransitionsTestPage extends StatefulWidget {
//   @override
//   _TransitionsTestPageState createState() => _TransitionsTestPageState();
// }

// class _TransitionsTestPageState extends State<TransitionsTestPage> with TickerProviderStateMixin {
//   VideoPlayerController _videoController;
//   VideoPlayerController _secondVideoController;
//   Future<void> _initializeVideoPlayerFuture;
//   Future<void> _initializeSecondVideoPlayerFuture;

//   AnimationController _fadeController;
//   Animation<double> _slowRotate;
//   bool _bgVisibilityToggle = true;

//   AnimationController _slideControllerOne,
//       _slideControllerTwo,
//       _slideControllerThree,
//       _rotateController;
//   Animation<Offset> _slideLoopOne, _slideLoopTwo, _slideLoopThree;

//   AnimationController _reversingController;
//   Animation _circularSlide;

//   AnimationController _slowController;

//   double _scalingHeight = 60, _scalingWidth = 60;
//   int _scaleDuration = 2;

//   bool _fontStyleToggle = false;

//   TransitionsConfigModel _configModel = TransitionsConfigModel(
//       fadeTransition: false,
//       slideTransition: false,
//       rotationTransition: false,
//       iconTransition: false,
//       textTransition: false,
//       shadows: false,
//       randomTimes: false,
//       randomSizes: false,
//       randomCurves: false);

//   @override
//   void initState() {
//     _loadAndInitialize(context);
//     _initializeMainVideoPlayers();

//     super.initState();
//   }

//   @override
//   void dispose() {
//     _fadeController.dispose();
//     _videoController.dispose();
//     _secondVideoController.dispose();
//     _slideControllerOne.dispose();
//     _slideControllerTwo.dispose();
//     _rotateController.dispose();
//     _reversingController.dispose();
//     _slowController.dispose();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           title: Text(AppLocalizations.of(context).translate("animations_transitions_scenario"))),
//       body: Stack(
//         children: <Widget>[
//           if (_configModel.fadeTransition) _widgetFadeInOut(context),
//           if (_configModel.rotationTransition) _widgetRotation(context),
//           if (_configModel.slideTransition) _widgetSlideCorners(context),
//           if (_configModel.iconTransition) _widgetIcon(context),
//           if (_configModel.textTransition) _widgetText(context)
//         ],
//       ),
//     );
//   }

//   Widget _buildVideoThumb(bool first) {
//     bool rand = _configModel.randomSizes;

//     return Container(
//         width: rand ? HelperFunctions.randomDouble(140, 160) : 150,
//         height: rand ? HelperFunctions.randomDouble(140, 160) : 150,
//         child: _buildVideo(first),
//         decoration: BoxDecoration(boxShadow: _getBoxShadow()));
//   }

//   Widget _buildResizingVideo(bool first) {
//     return AnimatedContainer(
//         duration: Duration(seconds: _scaleDuration),
//         curve: _configModel.randomCurves ? HelperFunctions.randomCurve() : Curves.linear,
//         width: _scalingWidth,
//         height: _scalingHeight,
//         child: _buildVideo(first),
//         decoration: BoxDecoration(boxShadow: _getBoxShadow()));
//   }

//   Widget _buildVideo(bool first) {
//     return FutureBuilder(
//       future: first ? _initializeVideoPlayerFuture : _initializeSecondVideoPlayerFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           return Stack(
//             children: <Widget>[
//               VideoPlayer(first ? _videoController : _secondVideoController),
//             ],
//           );
//         } else {
//           return Center(child: CircularProgressIndicator());
//         }
//       },
//     );
//   }

//   Widget _widgetText(BuildContext context) {
//     return AnimatedBuilder(
//       child: AnimatedDefaultTextStyle(
//         style: _fontStyleToggle
//             ? _getRedRoboto(_configModel.shadows)
//             : _getBlueCourgette(_configModel.shadows),
//         duration: Duration(seconds: _scaleDuration),
//         child: Center(
//           child: Text(_fontStyleToggle
//               ? AppLocalizations.of(context).translate("long_jargon")
//               : AppLocalizations.of(context).translate("short_jargon")),
//         ),
//       ),
//       animation: _reversingController,
//       builder: (BuildContext context, Widget child) {
//         return Transform.rotate(
//           child: child,
//           angle: pi * 2 * _circularSlide.value,
//           origin: Offset(0, 100),
//         );
//       },
//     );
//   }

//   Widget _widgetRotation(BuildContext context) {
//     return Center(
//       child: AnimatedBuilder(
//         child: _buildResizingVideo(true),
//         animation: _slowRotate,
//         builder: (BuildContext context, Widget child) {
//           return Transform.rotate(
//             child: child,
//             angle: _slowRotate.value,
//           );
//         },
//       ),
//     );
//   }

//   Widget _widgetIcon(BuildContext context) {
//     return SlideTransition(
//       position: _slideLoopThree,
//       child: AnimatedContainer(
//           duration: Duration(seconds: _scaleDuration),
//           curve: _configModel.randomCurves ? HelperFunctions.randomCurve() : Curves.linear,
//           width: _scalingWidth,
//           height: _scalingHeight,
//           child: Padding(
//             padding: EdgeInsets.all(12),
//             child: FlutterLogo(),
//           ),
//           decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.blue[900].withOpacity(0.3),
//               boxShadow: _getBoxShadow())),
//     );
//   }

//   Widget _widgetSlideCorners(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         SlideTransition(
//           position: _slideLoopOne,
//           child: Padding(
//             padding: EdgeInsets.all(4),
//             child: AnimatedBuilder(
//               animation: _rotateController,
//               child: _buildVideoThumb(true),
//               builder: (BuildContext context, Widget _widget) {
//                 return Transform.rotate(
//                   angle: _rotateController.value * 5,
//                   child: _widget,
//                 );
//               },
//             ),
//           ),
//         ),
//         SlideTransition(
//           position: _slideLoopTwo,
//           child: Padding(
//             padding: EdgeInsets.all(4),
//             child: AnimatedBuilder(
//                 animation: _rotateController,
//                 child: _buildVideoThumb(false),
//                 builder: (BuildContext context, Widget _widget) {
//                   return Transform.rotate(
//                     angle: _rotateController.value * -10,
//                     child: _widget,
//                   );
//                 }),
//           ),
//         )
//       ],
//     );
//   }

//   Widget _widgetFadeInOut(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         AnimatedOpacity(
//           opacity: !_bgVisibilityToggle ? 1 : 0,
//           duration: Duration(seconds: 1),
//           child: _buildVideo(false),
//         ),
//         AnimatedOpacity(
//           opacity: _bgVisibilityToggle ? 1 : 0,
//           duration: Duration(seconds: 1),
//           child: _buildVideo(true),
//         ),
//       ],
//     );
//   }

//   static List<Shadow> _getShadow() {
//     return [Shadow(color: Colors.grey[500], offset: Offset(6, 6), blurRadius: 6)];
//   }

//   List<BoxShadow> _getBoxShadow() {
//     if (!_configModel.shadows) return [];
//     return [
//       BoxShadow(color: Colors.grey[500], offset: Offset(6, 6), blurRadius: 6, spreadRadius: 2),
//     ];
//   }

//   TextStyle _getRedRoboto(bool shadow) {
//     return GoogleFonts.roboto(
//         textStyle: TextStyle(
//             shadows: shadow ? _getShadow() : [],
//             fontSize: 16,
//             fontStyle: FontStyle.italic,
//             fontWeight: FontWeight.normal,
//             foreground: Paint()
//               ..shader = ui.Gradient.linear(
//                 const Offset(0, 20),
//                 const Offset(200, 20),
//                 <Color>[
//                   Colors.red,
//                   Colors.yellow,
//                 ],
//               )));
//   }

//   TextStyle _getBlueCourgette(bool shadow) {
//     return GoogleFonts.courgette(
//         textStyle: TextStyle(
//       shadows: shadow ? _getShadow() : [],
//       fontSize: 32,
//       fontStyle: FontStyle.normal,
//       fontWeight: FontWeight.bold,
//       foreground: Paint()
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = 2
//         ..color = Colors.blue,
//     ));
//   }

//   void _initializeMainVideoPlayers() {
//     var asset1 = 'assets/content/video/butterfly.mp4';
//     _videoController = VideoPlayerController.asset(asset1);
//     _initializeVideoPlayerFuture = _videoController.initialize();
//     _videoController.setLooping(true);
//     _videoController.play();

//     var asset2 = 'assets/content/video/bunny.webm';
//     _secondVideoController = VideoPlayerController.asset(asset2);
//     _initializeSecondVideoPlayerFuture = _secondVideoController.initialize();
//     _secondVideoController.setLooping(true);
//     _secondVideoController.play();
//   }

//   void _reversingCombinedListener(AnimationStatus status) {
//     bool rand = _configModel.randomSizes;

//     if (status == AnimationStatus.completed) {
//       _reversingController.reverse();
//       setState(() {
//         _scalingHeight = rand ? HelperFunctions.randomDouble(50, 200) : 100;
//         _scalingWidth = rand ? HelperFunctions.randomDouble(50, 200) : 100;

//         _fontStyleToggle = !_fontStyleToggle;
//       });
//     } else if (status == AnimationStatus.dismissed) {
//       _reversingController.forward();
//       setState(() {
//         _scalingHeight = rand ? HelperFunctions.randomDouble(150, 300) : 200;
//         _scalingWidth = rand ? HelperFunctions.randomDouble(150, 300) : 200;
//       });
//     }
//   }

//   void _loadAndInitialize(BuildContext context) async {
//     var status = await Permission.storage.status;
//     if (!status.isGranted) {
//       await Permission.storage.request();
//     }

//     String root = await ExtStorage.getExternalStorageDirectory();
//     String file = "transitions_configuration.json";
//     String path = "$root/flutter_benchmark_configurations/$file";
//     bool confExists = await File(path).exists();
//     if (confExists) {
//       String data = await File(path).readAsString();
//       setState(() {
//         _configModel = TransitionsConfigModel.fromJson(json.decode(data));
//       });
//     } else {
//       String data =
//           await DefaultAssetBundle.of(context).loadString("assets/configuration_files/$file");
//       setState(() {
//         _configModel = TransitionsConfigModel.fromJson(json.decode(data));
//       });
//     }

//     bool rand = _configModel.randomTimes;

//     if (rand) _scaleDuration = HelperFunctions.randomInt(1, 3);

//     //full screen fading videos
//     _fadeController = AnimationController(
//         vsync: this, duration: Duration(seconds: rand ? HelperFunctions.randomInt(3, 6) : 3));
//     _fadeController.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         _fadeController.reverse();
//         setState(() {
//           _bgVisibilityToggle = !_bgVisibilityToggle;
//         });
//       } else if (status == AnimationStatus.dismissed) {
//         _fadeController.forward();
//         setState(() {
//           _bgVisibilityToggle = !_bgVisibilityToggle;
//         });
//       }
//     });
//     _fadeController.forward();

//     // corner to corner sliding and rotating videos
//     _slideControllerOne = AnimationController(
//         vsync: this, duration: Duration(seconds: rand ? HelperFunctions.randomInt(1, 4) : 2))
//       ..repeat(reverse: true);
//     _slideControllerTwo = AnimationController(
//         vsync: this, duration: Duration(seconds: rand ? HelperFunctions.randomInt(1, 4) : 2))
//       ..repeat(reverse: true);
//     _slideLoopOne = Tween<Offset>(begin: Offset(0, 0), end: Offset(1.5, 3)).animate(CurvedAnimation(
//         parent: _slideControllerOne,
//         curve: _configModel.randomCurves ? HelperFunctions.randomCurve() : Curves.linear));
//     _slideLoopTwo = Tween<Offset>(begin: Offset(1.5, 0), end: Offset(0, 3)).animate(CurvedAnimation(
//         parent: _slideControllerTwo,
//         curve: _configModel.randomCurves ? HelperFunctions.randomCurve() : Curves.linear));

//     _rotateController = AnimationController(
//         vsync: this, duration: Duration(seconds: rand ? HelperFunctions.randomInt(3, 6) : 4));
//     _rotateController.repeat();

//     // rotating sliding text
//     _reversingController =
//         AnimationController(vsync: this, duration: Duration(seconds: _scaleDuration));
//     _circularSlide = CurvedAnimation(
//         parent: _reversingController,
//         curve: _configModel.randomCurves ? HelperFunctions.randomCurve() : Curves.linear);
//     _reversingController.addStatusListener(_reversingCombinedListener);
//     _reversingController.forward();

//     // flutter logo
//     _slideControllerThree = AnimationController(
//         vsync: this, duration: Duration(seconds: rand ? HelperFunctions.randomInt(1, 6) : 3))
//       ..repeat(reverse: true);
//     _slideLoopThree = Tween<Offset>(begin: Offset(0, 0), end: Offset(1, 2)).animate(CurvedAnimation(
//         parent: _slideControllerThree,
//         curve: _configModel.randomCurves ? HelperFunctions.randomCurve() : Curves.linear));

//     // center rotating video
//     _slowController = AnimationController(vsync: this, duration: Duration(seconds: 45));
//     _slowController.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         _slowController.reverse();
//       } else if (status == AnimationStatus.dismissed) {
//         _slowController.forward();
//       }
//     });
//     _slowController.forward();
//     _slowRotate = Tween<double>(begin: 0, end: 10).animate(_slowController);
//   }
// }
