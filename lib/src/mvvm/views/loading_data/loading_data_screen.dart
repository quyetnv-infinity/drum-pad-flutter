import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:drumpad_flutter/core/utils/network_checking.dart';
import 'package:drumpad_flutter/src/mvvm/models/lesson_model.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/background_audio_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/drum_learn_provider.dart';
import 'package:drumpad_flutter/src/mvvm/view_model/network_provider.dart';
import 'package:drumpad_flutter/src/service/api_service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class LoadingDataScreen extends StatefulWidget {
  final SongCollection song;
  /// navigate to next screen with data
  final Function(SongCollection song) callbackLoadingCompleted;
  final Function() callbackLoadingFailed;
  const LoadingDataScreen({super.key, required this.callbackLoadingCompleted, required this.callbackLoadingFailed, required this.song});

  @override
  State<LoadingDataScreen> createState() => _LoadingDataScreenState();
}

class _LoadingDataScreenState extends State<LoadingDataScreen> {
  String _urlZipFile = '';
  List<String> _downloadedPacks = [];
  List<dynamic>? _sequenceData;
  List<dynamic>? _beatRunnerData;

  @override
  void initState() {
    super.initState();
    _urlZipFile = '${ApiService.BASEURL}${widget.song.pathZipFile}';
    getSongDetail();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BackgroundAudioProvider>(context, listen: false).pause();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getSongDetail() async {
    final drumLearnProvider = Provider.of<DrumLearnProvider>(context, listen: false);
    final song = await drumLearnProvider.getSong(widget.song.id);
    if(song != null){
      Future.delayed(Duration(seconds: 1), () {
        widget.callbackLoadingCompleted(song);
        print('song exist');
        return;
      },);
      return;
    } else {
      final networkProvider = Provider.of<NetworkProvider>(context, listen: false);
      if(!networkProvider.isConnected) {
        await NetworkChecking.checkNetwork(context, handleActionWhenComplete: widget.callbackLoadingFailed);
        return;
      }
      await _loadDownloadedPacks();
      await _downloadAndExtractZip();
    }
  }

  Future<void> _loadDownloadedPacks() async {
    try {
      final packsDir = await _getPacksDirectory();
      // print('========${packsDir.path}');
      if (await packsDir.exists()) {
        final entities = packsDir.listSync();
        List<String> packs = [];

        for (var entity in entities) {
          if (entity is Directory) {
            packs.add(entity.path.split('/').last);
          }
        }

        setState(() {
          _downloadedPacks = packs;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Directory> _getPacksDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final packsDir = Directory('${appDir.path}/data_packs');

    if (!await packsDir.exists()) {
      await packsDir.create(recursive: true);
    }

    return packsDir;
  }

  Future<Directory> _getPackDirectory(String packName) async {
    final packsDir = await _getPacksDirectory();
    final packDir = Directory('${packsDir.path}/$packName');

    if (!await packDir.exists()) {
      await packDir.create(recursive: true);
    }

    return packDir;
  }

  Future<void> _downloadAndExtractZip() async {
    final url = _urlZipFile;
    String packName = widget.song.id;

    try {
      final tempDir = await getTemporaryDirectory();
      final zipFilePath = '${tempDir.path}/$packName.zip';

      var response = await http.Client().get(Uri.parse(url));

      // Lưu response data vào file
      final file = File(zipFilePath);
      await file.writeAsBytes(response.bodyBytes);

      // 2. Đọc file ZIP
      final bytes = await File(zipFilePath).readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      // 3. Tạo thư mục cho gói
      final packDir = await _getPackDirectory(packName);
      // print('=========$packDir======');
      // 4. Giải nén từng file và lưu với debug info
      int fileCount = 0;
      int totalFiles = archive.length;
      int audioFilesCount = 0;
      bool jsonFound = false;
      List<String> extractedFilePaths = [];

      for (final file in archive) {
        fileCount++;

        // Chuẩn hóa tên file và đường dẫn
        final filename = file.name;
        final normalizedPath = filename.replaceAll('\\', '/');

        // Lấy tên file thực từ đường dẫn
        final pathParts = normalizedPath.split('/');
        final actualFileName = pathParts.last;

        // Bỏ qua thư mục
        if (file.isFile && actualFileName.isNotEmpty) {
          final data = file.content as List<int>;
          final outputFile = File('${packDir.path}/$actualFileName');

          outputFile
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);

          extractedFilePaths.add(outputFile.path);

          // Đếm số lượng file theo loại
          if (actualFileName.toLowerCase().endsWith('.mp3')) {
            audioFilesCount++;
          } else if (actualFileName.toLowerCase() == 'sequence.json') {
            jsonFound = true;
          }
        }
      }

      // 5. Debug và xóa file ZIP tạm
      await File(zipFilePath).delete();

      setState(() {
        if (!_downloadedPacks.contains(packName)) {
          _downloadedPacks.add(packName);
        }
      });

      // Kiểm tra nội dung đã giải nén
      print('Extracted files: ${extractedFilePaths.join(', ')}');

      // Tải lại danh sách gói và mở gói vừa tải
      await _loadDownloadedPacks();
      await _loadPackContent(packName);

      /// Xử lý data và navigate
      if(_sequenceData == null && _beatRunnerData == null) {
        showToastLoadFailed();
        widget.callbackLoadingFailed();
        return;
      }
      final SongCollection song = SongCollection.fromJson(_sequenceData ?? [], _beatRunnerData ?? []);
      final dataSong = song.copyWith(id: widget.song.id, image: widget.song.image, difficulty: widget.song.difficulty, author: widget.song.author, name: widget.song.name, pathZipFile: widget.song.pathZipFile);
      print('${dataSong.lessons.length} || ${dataSong.beatRunnerLessons.length}');
      context.read<DrumLearnProvider>().updateSong(widget.song.id, dataSong);
      widget.callbackLoadingCompleted(dataSong);
    } catch (e) {
      print('Error during download/extract: $e');
      showToastLoadFailed();
      widget.callbackLoadingFailed();
      return;
    }
  }

  void showToastLoadFailed(){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.black.withValues(alpha: 0.7)
            ),
            child: Text('Load Failed!', style: TextStyle(color: Colors.white, fontSize: 18), textAlign: TextAlign.center,)
        ),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        width: MediaQuery.of(context).size.width * 0.5,
      ),
    );
  }

  Future<void> _loadPackContent(String packName) async {
    try {
      setState(() {
        _sequenceData = null;
        _beatRunnerData = null;
      });

      final packDir = await _getPackDirectory(packName);
      if (!await packDir.exists()) {
        print('Không tìm thấy thư mục gói: $packName');
        return;
      }

      print('Looking for files in: ${packDir.path}');
      final entities = packDir.listSync();
      print('Found ${entities.length} entities in pack directory');

      List<dynamic>? sequenceData;
      List<dynamic>? beatRunnerData;

      // Debug: in ra tất cả entities
      for (var entity in entities) {
        print('Found entity: ${entity.path}');
      }

      for (var entity in entities) {
        if (entity is File) {
          String filename = entity.path.split('/').last;
          print('Processing file: $filename');

          if (filename.toLowerCase().endsWith('.mp3') && !filename.toLowerCase().contains('._')) {
            print('Found MP3: $filename');
          } else if (filename.toLowerCase() == 'sequence.json' && !filename.toLowerCase().contains('._')) {
            print('Found JSON: $filename');
            try {
              String jsonContent = await File(entity.path).readAsString();
              sequenceData = List.from(json.decode(jsonContent));
              print('JSON parsed successfully');
            } catch (e) {
              print('Error parsing JSON: $e');
            }
          } else if (filename.toLowerCase() == 'beat_runner.json' && !filename.toLowerCase().contains('._')) {
            print('Found JSON: $filename');
            try {
              String jsonContent = await File(entity.path).readAsString();
              beatRunnerData = List.from(json.decode(jsonContent));
              print('JSON parsed successfully');
            } catch (e) {
              print('Error parsing JSON: $e');
            }
          } else if(filename.toLowerCase().contains('._')) {
            File file = File(entity.path);
            if(file.existsSync()){
              file.deleteSync();
              print('Deleted file: $filename');
            }
          }
        }
      }

      setState(() {
        _sequenceData = sequenceData;
        _beatRunnerData = beatRunnerData;
      });
    } catch (e) {
      print('Error loading pack content: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xFF311E6B), Color(0xFF141414)
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: [0, 0.2])
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset('assets/anim/loading.json', width: MediaQuery.of(context).size.width*0.45, fit: BoxFit.fill),
                SizedBox(height: 16,),
                Text('${context.locale.loading}...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 20),)
              ],
            ),
          ),
        )
      ),
    );
  }
}

class AudioFile {
  final String name;
  final String path;

  AudioFile({required this.name, required this.path});
}
