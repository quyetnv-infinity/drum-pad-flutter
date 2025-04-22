import 'dart:async';
import 'package:ads_tracking_plugin/ads_tracking_plugin.dart';
import 'package:ads_tracking_plugin/analyze/analytics_tracker.dart';
import 'package:drumpad_flutter/config/ads_config.dart';
import 'package:drumpad_flutter/core/constants/hive_table.dart';
import 'package:drumpad_flutter/core/utils/network_checking.dart';
import 'package:drumpad_flutter/hive/hive_registrar.g.dart';
import 'package:drumpad_flutter/service_locator/service_locator.dart';
import 'package:drumpad_flutter/src/application/my_application.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/ads_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/app_setting_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/app_state_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/campaign_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/drum_learn_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/locale_view_model.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/network_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/purchase_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/rate_app_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/result_information_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/tutorial_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/unlock_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AnalyticsTracker.setupCrashlytics();
  await RemoteConfig.initializeRemoteConfig(adConfigs: getAdConfigurations(false), devMode: AdUnitId.devMode);
  AnalyticsUtil.trackAppOpens();
  await _initHive();

  await ServiceLocator.instance.initialise();
  final purchaseProvider = PurchaseProvider();
  final AppSettingsProvider appSettingsProvider = AppSettingsProvider();
  final adsProvider = AdsProvider(appSettingsProvider: appSettingsProvider);
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocateViewModel()),
        ChangeNotifierProvider(create: (_) => appSettingsProvider),
        ChangeNotifierProvider(create: (_) => RateAppProvider()),
        ChangeNotifierProvider(create: (_) => NetworkProvider()),
        ChangeNotifierProvider(create: (_) => DrumLearnProvider(), lazy: false,),
        ChangeNotifierProvider(create: (_) => TutorialProvider(), lazy: false,),
        ChangeNotifierProvider(create: (_) => CampaignProvider(), lazy: false,),
        ChangeNotifierProvider(create: (_) => ResultInformationProvider(), lazy: false,),
        ChangeNotifierProvider(create: (_) => UnlockedSongsProvider(), lazy: false,),
        ChangeNotifierProvider(create: (_) => adsProvider),
        ChangeNotifierProvider(create: (_) => purchaseProvider),
        ChangeNotifierProxyProvider2<AdsProvider, PurchaseProvider, AppStateProvider>(
          create: (_) => AppStateProvider(adsProvider, purchaseProvider),
          update: (_, ads, purchase, appState) {
            appState?.updateDependencies(ads, purchase);
            return appState ?? AppStateProvider(ads, purchase);
          },
          lazy: false,
        ),
      ],
      child: const MyApplication(),
    ),
  );
  configLoading();
}

Future<void> _initHive() async {
  var dir = await getApplicationDocumentsDirectory();
  await dir.create(recursive: true);
  var dbPath = '${dir.path}/hive_db';
  Hive
    ..init(dbPath)
    ..registerAdapters();
  await Hive.openBox<SongCollection>(HiveTable.songCollectionTable);
}
//
// class DrumpadScreen extends StatefulWidget {
//   const DrumpadScreen({Key? key}) : super(key: key);
//
//   @override
//   State<DrumpadScreen> createState() => _DrumpadScreenState();
// }
//
// class _DrumpadScreenState extends State<DrumpadScreen> with SingleTickerProviderStateMixin {
//   List<String> availableSounds = [];
//   List<String> lessonSounds = [];
//   Map<String, AudioPlayer> audioPlayers = {};
//   List<Map<String, dynamic>> events = [];
//   int currentEventIndex = 0;
//   Timer? sequenceTimer;
//   bool isPlaying = false;
//   Set<String> highlightedSounds = {};
//   Set<String> remainSounds = {};
//   String firstRemainState = '';
//   bool notePressed = false;
//   double startTimeOffset = 0;
//   DateTime? startTime;
//   bool isLoading = true;
//   double progressValue = 0.0;
//   Timer? progressTimer;
//   Map<String, double> padProgress = {};
//
//   int? _currentHoverIndex;
//   Map<int, int> _pointerToPadIndex = {};
//   Map<int, Offset> _lastPointerPositions = {};
//   final double _movementThreshold = 15.0; // Minimum movement
//   Map<int, String> _pointerToSound = {};
//
//   final GlobalKey _widgetPadKey = GlobalKey();
//   String? _currentLeadSound;
//   Set<int> _padPressedIndex = {};
//
//   DateTime? lastEventTime;
//   DateTime? firstRemainSound;
//   Map<String, String> padStates = {};
//   List<dynamic> lessons = [];
//   int currentLesson = 0;
//
//   List<String> _faceA = [];
//   List<String> _faceB = [];
//
//   int goodPoint = 0;
//   int perfectPoint = 1;
//   int latePoint = 0;
//   int earlyPoint = 0;
//   int missPoint = 0;
//
//   late AnimationController _controller;
//
//   List<Map<String, dynamic>> _futureNotes = [];
//
//   List<Map<String, dynamic>> getFutureNotes(Map<String, dynamic> data) {
//     List<Map<String, dynamic>> futureNotes = [];
//     List<Map<String, dynamic>> events = List<Map<String, dynamic>>.from(data["events"]);
//
//     for (int i = 1; i < events.length; i++) {
//       List<String> notes = List<String>.from(events[i]["notes"]);
//       if (notes.length >= 2) {
//         futureNotes.add({
//           "notes": notes,
//           "index": i
//         });
//       }
//     }
//     return futureNotes;
//   }
//
//   final Map<String, Color> soundColors = {
//     'lead': Colors.redAccent,
//     'bass': Colors.lightGreen,
//     'drums': Colors.lightBlue,
//     'fx': Colors.yellow,
//   };
//
//   final Map<String, SoundType> soundTypes = {
//     'lead': SoundType.lead,
//     'bass': SoundType.bass,
//     'drums': SoundType.drum,
//     'fx': SoundType.fx,
//   };
//
//   SoundType _getSoundType(String sound) {
//     for (var key in soundTypes.keys) {
//       if (sound.contains(key)) {
//         return soundTypes[key]!;
//       }
//     }
//     return SoundType.drum;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _loadSequenceDataFromFile().then((_) {
//       _initializeAudioPlayers();
//       setState(() {
//         isLoading = false;
//       });
//     });
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 150), // Thời gian chạy mặc định
//     )..repeat();
//   }
//
//   @override
//   void dispose() {
//     _disposeAudioPlayers();
//     sequenceTimer?.cancel();
//     progressTimer?.cancel();
//     _controller.dispose();
//     super.dispose();
//   }
//
//   void resetPoint(){
//     perfectPoint = 1;
//     goodPoint = 0;
//     latePoint = 0;
//     earlyPoint = 0;
//     missPoint = 0;
//   }
//   void increasePoint(String state){
//     switch(state){
//       case 'Perfect':
//         perfectPoint++;
//         break;
//       case 'Gud':
//         goodPoint++;
//         break;
//       case 'Late':
//         latePoint++;
//         break;
//       case 'Early':
//         earlyPoint++;
//         break;
//       case 'Miss':
//         missPoint++;
//         break;
//     }
//   }
//
//   void showDialogPoint(){
//     showDialog(context: context, builder: (context) {
//       return AlertDialog(
//         title: Text("Result"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text("Perfect: $perfectPoint"),
//             Text("Good: $goodPoint"),
//             Text("Late: $latePoint"),
//             Text("Early: $earlyPoint"),
//             Text("Miss: $missPoint"),
//           ],
//         ),
//         actions: [
//           TextButton(onPressed: (){
//             Navigator.pop(context);
//           }, child: Text("OK"))
//         ],
//       );
//     },);
//   }
//
//   Future<void> _loadSequenceDataFromFile() async {
//     try {
//       final String jsonString = await rootBundle.loadString('assets/sequence.json');
//       final jsonData = json.decode(jsonString);
//       lessons = List.from(jsonData);
//       currentLesson = 8;
//       events = List<Map<String, dynamic>>.from(lessons[currentLesson]['events']);
//       Set<String> uniqueSounds = {};
//       for (var lesson in lessons) {
//         for (var event in lesson["events"]) {
//           final notes = List<String>.from(event['notes']);
//           uniqueSounds.addAll(notes);
//         }
//       }
//       availableSounds.addAll(uniqueSounds.toList());
//       uniqueSounds = {};
//       for (var event in events) {
//         final notes = List<String>.from(event['notes']);
//         uniqueSounds.addAll(notes);
//       }
//       _splitSoundsByFace();
//       lessonSounds.addAll(sortDrumpadSounds(uniqueSounds.toList(), lessons[currentLesson]['events'][0]["notes"][0].contains("_face_b_") ? _faceB : _faceA));
//       _futureNotes = getFutureNotes(lessons[currentLesson]);
//       print("lessonssss $lessonSounds");
//     } catch (e) {
//       print('Error loading sequence data from file: $e');
//       events = [];
//       availableSounds.clear();
//       lessonSounds.clear();
//     }
//   }
//
//   Future<void> _initializeAudioPlayers() async {
//     _disposeAudioPlayers();
//     for (String sound in availableSounds) {
//       if (sound.isEmpty) return;
//       final player = AudioPlayer();
//       try {
//         await player.setAsset('assets/audio/$sound.mp3');
//         audioPlayers[sound] = player;
//       } catch (e) {
//         print('Error loading audio file for $sound: $e');
//       }
//     }
//   }
//
//   void _splitSoundsByFace() {
//     List<String> faceA = [];
//     List<String> faceB = [];
//
//     for (var sound in availableSounds) {
//       if (sound.contains("_face_a_")) {
//         faceA.add(sound);
//       } else if (sound.contains("_face_b_")) {
//         faceB.add(sound);
//       }
//     }
//     setState(() {
//       _faceA = faceA;
//       _faceB = faceB;
//     });
//   }
//
//   void _disposeAudioPlayers() {
//     for (var player in audioPlayers.values) {
//       player.pause();
//       player.dispose();
//     }
//     audioPlayers.clear();
//     setState(() {
//       audioPlayers = {};
//     });
//   }
//
//   Future<void> _playSound(String sound) async {
//     if (audioPlayers.containsKey(sound)) {
//       if(_getSoundType(sound) == SoundType.lead){
//         if(_currentLeadSound != null) audioPlayers[_currentLeadSound]?.pause();
//         setState(() {
//           _currentLeadSound = sound;
//         });
//       }
//       audioPlayers[sound]?.seek(Duration.zero);
//       audioPlayers[sound]?.play();
//     }
//   }
//
//   void _startSequence() {
//     resetPoint();
//     if (isPlaying || events.isEmpty) return;
//     _resetSequence();
//     setState(() {
//       isPlaying = true;
//     });
//     _scheduleNextEvent();
//   }
//
//   void _resetSequence({bool isPlayingDrum = false}) {
//     _futureNotes = getFutureNotes(lessons[currentLesson]);
//     for (var player in audioPlayers.values) {
//       if(!isPlayingDrum) player.pause();
//     }
//
//     setState(() {
//       isPlaying = false;
//       currentEventIndex = 0;
//       startTimeOffset = 0;
//       highlightedSounds.clear();
//       notePressed = false;
//       progressValue = 0.0;
//       progressTimer = null;
//       padProgress = {};
//     });
//     sequenceTimer?.cancel();
//     progressTimer?.cancel();
//   }
//
//   void _scheduleNextEvent() {
//     sequenceTimer?.cancel();
//     if (currentEventIndex >= events.length) {
//       _resetSequence();
//       return;
//     }
//     final currentEvent = events[currentEventIndex];
//     final nextEventTime = currentEvent['time'] as double;
//     if (currentEventIndex == 0) {
//       startTimeOffset = 0.0;
//     } else {
//       final prevEvent = events[currentEventIndex - 1];
//       startTimeOffset = prevEvent['time'] as double;
//     }
//     final timeUntilEvent = nextEventTime - startTimeOffset;
//     sequenceTimer = Timer(Duration(milliseconds: (timeUntilEvent * 1000).round()), () {
//       _processEvent(currentEvent);
//     });
//   }
//
//   void _processEvent(Map<String, dynamic> event) {
//     setState(() {
//       highlightedSounds.clear();
//       highlightedSounds.addAll(List<String>.from(event['notes']));
//       progressValue = 0.0;
//       padProgress.clear();
//     });
//     lastEventTime = DateTime.now();
//     if (currentEventIndex > events.length - 1) return;
//
//     double currentTime = event['time'];
//     double prevTime = events[currentEventIndex == 0 ? 0 : currentEventIndex - 1]['time'];
//     double delay = currentTime - prevTime;
//
//     // Nếu nốt đầu tiên có thời gian là 0, thì bỏ qua progress cho nốt này
//     if (currentEventIndex == 0 && currentTime == 0) return;
//
//     for (var note in event['notes']) {
//       padProgress[note] = 0.0;
//     }
//
//     progressTimer?.cancel();
//     progressTimer = Timer.periodic(Duration(milliseconds: 10), (timer) {
//       setState(() {
//         for (var note in padProgress.keys) {
//           padProgress[note] = (padProgress[note]! + (10 / (delay * 1000))).clamp(0.0, 1.0);
//         }
//         if (padProgress.values.every((value) => value == 1.0)) {
//           timer.cancel();
//         }
//       });
//     });
//   }
//
//   void _onPadPressed(String sound, int index) {
//     if(_getPadColor(sound) == Colors.grey) return;
//
//     // Add this check to prevent duplicate activations
//     if (_padPressedIndex.contains(index)) return;
//
//     setState(() {
//       _padPressedIndex.add(index);
//     });
//     Future.delayed(Duration(milliseconds: 100), (){
//       setState(() {
//         _padPressedIndex.remove(index);
//       });
//     },);
//
//     // Rest of the method remains the same
//     _playSound(sound);
//
//     lastEventTime ??= DateTime.now();
//
//     double currentTime = (DateTime.now().difference(lastEventTime!).inMilliseconds) / 1000.0;
//     double requiredTime = events[currentEventIndex]['time'] - (currentEventIndex > 0 ? events[currentEventIndex - 1]['time'] : 0);
//
//     String state = "";
//     if(currentEventIndex != 0){
//       if (currentTime < requiredTime - 0.5) {
//         state = 'Early';
//       } else if (currentTime < requiredTime - 0.2) {
//         state = 'Gud';
//       } else if (currentTime > requiredTime + 0.2) {
//         state = 'Late';
//       } else {
//         state = 'Perfect';
//       }
//     }
//
//     increasePoint(state);
//
//     setState(() {
//       padStates[sound] = state;
//       // print(firstRemainState);
//
//       // highlightedSounds.remove(sound);
//     });
//
//     Future.delayed(const Duration(seconds: 1), () {
//       setState(() {
//         padStates.remove(sound);
//       });
//     });
//
//     List<String> requiredNotes = List<String>.from(events[currentEventIndex]['notes']);
//     if(!requiredNotes.contains(sound) && currentEventIndex != 0){
//       increasePoint("Miss");
//       setState(() {
//         padStates[sound] = 'Miss';
//       });
//     }
//     if (remainSounds.contains(sound)) {
//       double currentTime = (DateTime.now().difference(firstRemainSound!).inMilliseconds) / 1000.0;
//       String state = "";
//       if(currentEventIndex != 0){
//         if (currentTime > 0.2) {
//           state = 'Miss';
//         } else{
//           state = firstRemainState;
//         }
//         remainSounds.remove(sound);
//       }
//       setState(() {
//         padStates[sound] = state;
//       });
//       increasePoint(state);
//       print(padStates[sound]);
//     } else if (highlightedSounds.contains(sound)) {
//       if (_futureNotes.isNotEmpty && (_futureNotes[0]["notes"] as List).contains(sound)) {
//         _futureNotes.removeAt(0);
//         setState(() {});
//       }
//       firstRemainSound = DateTime.now();
//
//       remainSounds.clear();
//       for (var remainingSound in highlightedSounds) {
//         if (remainingSound != sound) {
//           remainSounds.add(remainingSound);
//           setState(() {
//             firstRemainState = state;
//           });
//         }
//       }
//       Future.delayed(Duration(milliseconds: 200),() {
//         if(remainSounds.isNotEmpty){
//           for (var e in remainSounds) {
//             setState(() {
//               padStates[e] = 'Miss';
//             });
//             increasePoint("Miss");
//             Future.delayed(const Duration(seconds: 1), () {
//               setState(() {
//                 padStates.remove(e);
//               });
//             });
//           }
//           remainSounds.clear();
//         }
//       });
//       currentEventIndex++;
//       if (currentEventIndex < events.length) {
//         _processEvent(events[currentEventIndex]);
//       } else {
//         _resetSequence(isPlayingDrum: true);
//         showDialogPoint();
//       }
//     }
//     //
//     // print(currentEventIndex);
//     // print(_futureNotes);
//     // print("_______");
//   }
//
//   Color _getPadColor(String sound) {
//     for (var key in soundColors.keys) {
//       if (sound.contains(key)) {
//         return soundColors[key]!;
//       }
//     }
//     return Colors.grey;
//   }
//
//   List<Color> _getPadGradientColor(bool isActive, String sound){
//     if(isActive){
//       for (var key in soundGradientActiveColors.keys) {
//         if (sound.contains(key)) {
//           return soundGradientActiveColors[key]!;
//         }
//       }
//     } else {
//       for (var key in soundGradientDefaultColors.keys) {
//         if (sound.contains(key)) {
//           return soundGradientDefaultColors[key]!;
//         }
//       }
//     }
//     return [Color(0xFF919191), Color(0xFF5E5E5E)];
//   }
//
//   final Map<String, List<Color>> soundGradientDefaultColors = {
//     'lead': [Color(0xFFBC80D6), Color(0xFFAA46D6)],
//     'bass': [Color(0xFF82D6CB), Color(0xFF47D6C3)],
//     'drums': [Color(0xFF81C8D6), Color(0xFF47BED6)],
//     'fx': [Color(0xFFAED680), Color(0xFF93D647)],
//   };
//
//   final Map<String, List<Color>> soundGradientActiveColors = {
//     'lead': [Color(0xFFEFCCFF), Color(0xFFD880FF)],
//     'bass': [Color(0xFFCCFFF8), Color(0xFF80FFEE)],
//     'drums': [Color(0xFFCCF7FF), Color(0xFF80EAFF)],
//     'fx': [Color(0xFFE7FFCC), Color(0xFFC3FF80)],
//   };
//
//   double _getPositionTop() {
//     final RenderBox renderBox = _widgetPadKey.currentContext?.findRenderObject() as RenderBox;
//     final Offset position = renderBox.localToGlobal(Offset.zero); // Lấy vị trí tuyệt đối
//     final double top = position.dy;
//     final double bottom = top + renderBox.size.height;
//     return top;
//   }
//
//   double _calculateProgressValue(int currentIndex, int targetIndex) {
//     // Calculate how far we are between current and target index
//     int distance = targetIndex - currentIndex;
//
//     // Divide the distance into 4 equal steps
//     int stepSize = (distance / 4).ceil();
//     if (stepSize <= 0) stepSize = 1;
//
//     // Calculate which step we're on (0-3)
//     int currentStep = 4 - ((distance + stepSize - 1) ~/ stepSize);
//     currentStep = currentStep.clamp(0, 4);
//
//     // Return progress as a value between 0.0 and 1.0
//     return (currentStep / 4).clamp(0.0, 1.0);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//     return Listener(
//       behavior: HitTestBehavior.translucent,
//       onPointerDown: (event) {
//         // Track new pointer
//         RenderBox box = context.findRenderObject() as RenderBox;
//         Offset localPosition = box.globalToLocal(event.position);
//         _lastPointerPositions[event.pointer] = localPosition;
//
//         // Calculate which pad was touched
//         double itemWidth = box.size.width / 3;
//         double itemHeight = itemWidth;
//         int col = (localPosition.dx ~/ itemWidth).clamp(0, 2);
//         int row = ((localPosition.dy - _getPositionTop()) ~/ itemHeight)
//             .clamp(0, (12 ~/ 3));
//         int index = row * 3 + col;
//
//         if (index < 12) {
//           _pointerToPadIndex[event.pointer] = index;
//           _pointerToSound[event.pointer] = lessonSounds[index];
//         }
//       },
//
//       onPointerUp: (event) {
//         // Clean up when pointer is released
//         _pointerToPadIndex.remove(event.pointer);
//         _pointerToSound.remove(event.pointer);
//         _lastPointerPositions.remove(event.pointer);
//       },
//       onPointerMove: (event) async {
//         RenderBox box = context.findRenderObject() as RenderBox;
//         Offset localPosition = box.globalToLocal(event.position);
//
//         // Check if this pointer has moved enough to trigger a new pad
//         if (_lastPointerPositions.containsKey(event.pointer)) {
//           double distance = (localPosition - _lastPointerPositions[event.pointer]!).distance;
//           if (distance < _movementThreshold) {
//             return; // Movement too small, ignore
//           }
//         }
//
//         double itemWidth = box.size.width / 3;
//         double itemHeight = itemWidth;
//         int col = (localPosition.dx ~/ itemWidth).clamp(0, 2);
//         int row = ((localPosition.dy - _getPositionTop()) ~/ itemHeight)
//             .clamp(0, (12 ~/ 3));
//         int index = row * 3 + col;
//
//         // Only process if index is valid
//         if (index < 12) {
//           String currentSound = lessonSounds[index];
//
//           // Check if this pointer is already on this pad or has already played this sound
//           if (_pointerToPadIndex[event.pointer] == index ||
//               _pointerToSound[event.pointer] == currentSound) {
//             return; // Already on this pad or already played this sound
//           }
//
//           _pointerToPadIndex[event.pointer] = index;
//           _pointerToSound[event.pointer] = currentSound;
//           _lastPointerPositions[event.pointer] = localPosition;
//
//           setState(() {
//             _currentHoverIndex = index;
//           });
//
//           _onPadPressed(currentSound, index);
//         }
//       },
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         appBar: AppBar(
//           title: const Text('Drumpad', style: TextStyle(color: Colors.white)),
//           actions: [
//             IconButton(onPressed: isPlaying ? _resetSequence : _startSequence, icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white,))
//           ],
//           backgroundColor: Colors.black,
//         ),
//         body: SafeArea(
//           child: Column(
//             children: [
//               Expanded(
//                 child: GridView.builder(
//                   key: _widgetPadKey,
//                   padding: const EdgeInsets.all(16.0),
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 3,
//                     childAspectRatio: 1.0,
//                     crossAxisSpacing: 4,
//                     mainAxisSpacing: 4,
//                   ),
//                   physics: NeverScrollableScrollPhysics(),
//                   itemCount: lessonSounds.length,
//                   itemBuilder: (context, index) {
//                     final bool hasSound = index < lessonSounds.length;
//                     final String soundId = hasSound ? lessonSounds[index] : '';
//                     final bool isHighlighted = highlightedSounds.contains(soundId);
//                     final sound = lessonSounds[index];
//                     bool isActive = _padPressedIndex.isNotEmpty && _padPressedIndex.contains(index);
//                     return GestureDetector(
//                       onTapDown: (_) {
//                         setState(() {
//                           _currentHoverIndex = null;
//                         });
//                         _onPadPressed(sound, index);
//                       },
//                       child: Stack(
//                         children: [
//                           AnimatedContainer(
//                             duration: const Duration(milliseconds: 150),
//                             curve: Curves.easeInOut,
//                             padding: EdgeInsets.all(isActive ? 8 : 0),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 // color: isHighlighted ? Colors.orange : (hasSound ? _getPadColor(soundId) : Colors.grey),
//                                 borderRadius: BorderRadius.circular(12.0),
//                                 gradient: RadialGradient(colors: isHighlighted ? [Color(0xFFEDC78C), Colors.orange] : (hasSound ? _getPadGradientColor(isActive, soundId) : [Color(0xFF919191), Color(0xFF5E5E5E)]))
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   padStates[sound] ?? "",
//                                   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           if (
//                           _futureNotes.isNotEmpty
//                             && (_futureNotes[0]["notes"] as List).contains(sound)
//                             && currentEventIndex != 0
//                             && !padProgress.containsKey(sound)
//                             && !sound.contains("drums")
//                             && _futureNotes[0]["index"] - currentEventIndex < 4
//                           )
//                             Stack(
//                               children: [
//                                 Align(
//                                   alignment: Alignment.center,
//                                   child: CircularProgressIndicator(
//                                     value: _calculateProgressValue(currentEventIndex, _futureNotes[0]["index"]),
//                                     strokeWidth: 5,
//                                     backgroundColor: Colors.white24,
//                                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                                   ),
//                                 ),
//                                 Align(
//                                     alignment: Alignment.center,
//                                     child: Text("Wait", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.white)))
//                               ],
//                             ),
//                           if (padProgress.containsKey(sound))
//                             Align(
//                               alignment: Alignment.center,
//                               child:  SizedBox(
//                                 width: 36,
//                                 height: 36,
//                                 child: CircularProgressIndicator(
//                                   value: padProgress[sound],
//                                   strokeWidth: 5,
//                                   backgroundColor: Colors.white24,
//                                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                                 ),
//                               ),
//                             ),
//                           if (isActive)
//                             Lottie.asset('assets/anim/lightning_button.json', fit: BoxFit.cover, controller: _controller)
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               Wrap(
//                 children: List.generate(lessons.length, (index) => TextButton(onPressed: () async {
//                   setState(() {
//                     isLoading = true;
//                     currentLesson = index;
//                     events = List<Map<String, dynamic>>.from(lessons[currentLesson]['events']);
//                     final Set<String> uniqueSounds = {};
//                     for (var event in events) {
//                       final notes = List<String>.from(event['notes']);
//                       uniqueSounds.addAll(notes);
//                     }
//                     lessonSounds.clear();
//                     lessonSounds.addAll(sortDrumpadSounds(uniqueSounds.toList(), lessons[index]['events'][0]["notes"][0].contains("_face_b_") ? _faceB : _faceA));
//                     // print(lessons[index]['events'][0]["notes"][0].contains("_face_b_") ? _faceB : _faceA);
//                   });
//                   // print(availableSounds);
//                   await _initializeAudioPlayers();
//                   _resetSequence();
//                   setState(() {
//                     isLoading = false;
//                   });
//                   // Future.delayed(Duration(microseconds: 1000), _startSequence);
//                 }, child: Text(index.toString(), style: TextStyle(color: index == currentLesson ? Colors.blue : Colors.white)))),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }