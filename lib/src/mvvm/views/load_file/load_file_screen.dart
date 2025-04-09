import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class LoadFileScreen extends StatefulWidget {
  const LoadFileScreen({super.key});

  @override
  State<LoadFileScreen> createState() => _LoadFileScreenState();
}

class _LoadFileScreenState extends State<LoadFileScreen> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _packNameController = TextEditingController();
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String _statusText = '';
  List<String> _downloadedPacks = [];
  List<AudioFile> _audioFiles = [];
  List<dynamic>? _sequenceData;
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentlyPlaying;

  @override
  void initState() {
    super.initState();
    _loadDownloadedPacks();
  }

  @override
  void dispose() {
    _urlController.dispose();
    _packNameController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadDownloadedPacks() async {
    try {
      final packsDir = await _getPacksDirectory();
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
          _statusText = 'Đã tìm thấy ${packs.length} gói audio.';
        });
      }
    } catch (e) {
      setState(() {
        _statusText = 'Lỗi khi tải danh sách gói: $e';
      });
    }
  }

  Future<Directory> _getPacksDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final packsDir = Directory('${appDir.path}/audio_packs');

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
    final url = _urlController.text.trim();
    String packName = _packNameController.text.trim();

    if (url.isEmpty) {
      setState(() {
        _statusText = 'Vui lòng nhập URL hợp lệ';
      });
      return;
    }

    if (packName.isEmpty) {
      packName = 'audio_pack_${DateTime.now().millisecondsSinceEpoch}';
    }

    // Kiểm tra quyền
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
        if (!status.isGranted) {
          setState(() {
            _statusText = 'Không có quyền lưu trữ';
          });
          return;
        }
      }
    }

    try {
      setState(() {
        _isDownloading = true;
        _downloadProgress = 0.0;
        _statusText = 'Đang tải gói audio...';
      });

      final tempDir = await getTemporaryDirectory();
      final zipFilePath = '${tempDir.path}/$packName.zip';

      var response = await http.Client().get(Uri.parse(url));

      // Lưu response data vào file
      final file = File(zipFilePath);
      await file.writeAsBytes(response.bodyBytes);

      setState(() {
        _statusText = 'Đang giải nén gói...';
      });

      // 2. Đọc file ZIP
      final bytes = await File(zipFilePath).readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      // 3. Tạo thư mục cho gói
      final packDir = await _getPackDirectory(packName);

      // 4. Giải nén từng file và lưu với debug info
      int fileCount = 0;
      int totalFiles = archive.length;
      int audioFilesCount = 0;
      bool jsonFound = false;
      List<String> extractedFilePaths = [];

      for (final file in archive) {
        fileCount++;
        setState(() {
          _downloadProgress = 0.5 + (fileCount / totalFiles * 0.5);
          _statusText = 'Đang giải nén: ${file.name}';
        });

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
        _isDownloading = false;
        _statusText = 'Đã tải và giải nén thành công: $audioFilesCount file audio, ${jsonFound ? 'có' : 'không có'} file sequence.json';
        if (!_downloadedPacks.contains(packName)) {
          _downloadedPacks.add(packName);
        }
      });

      // Kiểm tra nội dung đã giải nén
      print('Extracted files: ${extractedFilePaths.join(', ')}');

      // Tải lại danh sách gói và mở gói vừa tải
      await _loadDownloadedPacks();
      await _loadPackContent(packName);
    } catch (e) {
      print('Error during download/extract: $e');
      setState(() {
        _isDownloading = false;
        _statusText = 'Lỗi khi tải hoặc giải nén: $e';
      });
    }
  }

  Future<void> _loadPackContent(String packName) async {
    try {
      setState(() {
        _statusText = 'Đang tải dữ liệu gói: $packName';
        _audioFiles = [];
        _sequenceData = null;
      });

      final packDir = await _getPackDirectory(packName);
      if (!await packDir.exists()) {
        setState(() {
          _statusText = 'Không tìm thấy thư mục gói: $packName';
        });
        return;
      }

      print('Looking for files in: ${packDir.path}');
      final entities = packDir.listSync();
      print('Found ${entities.length} entities in pack directory');

      List<AudioFile> audioFiles = [];
      List<dynamic>? sequenceData;

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
            audioFiles.add(AudioFile(
              name: filename,
              path: entity.path,
            ));
          } else if (filename.toLowerCase() == 'sequence.json' && !filename.toLowerCase().contains('._')) {
            print('Found JSON: $filename');
            try {
              String jsonContent = await File(entity.path).readAsString();
              sequenceData = List.from(json.decode(jsonContent));
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

      // Nếu không tìm thấy file, tìm kiếm trong các thư mục con
      if (audioFiles.isEmpty) {
        print('No files found in root directory, checking subdirectories');
        // Kiểm tra trong các thư mục con (thường là cấu trúc thư mục từ file ZIP)
        for (var entity in entities) {
          if (entity is Directory) {
            print('Checking subdirectory: ${entity.path}');
            final subEntities = entity.listSync();

            for (var subEntity in subEntities) {
              if (subEntity is File) {
                String filename = subEntity.path.split('/').last;
                print('Found in subdirectory: $filename');

                if (filename.toLowerCase().endsWith('.mp3')) {
                  audioFiles.add(AudioFile(
                    name: filename,
                    path: subEntity.path,
                  ));
                } else if (filename.toLowerCase() == 'sequence.json') {
                  try {
                    String jsonContent = await File(subEntity.path).readAsString();
                    sequenceData = jsonDecode(jsonContent);
                  } catch (e) {
                    print('Error parsing JSON in subdirectory: $e');
                  }
                }
              }
            }
          }
        }
      }

      setState(() {
        _audioFiles = audioFiles;
        _sequenceData = sequenceData;
        _statusText = sequenceData != null
            ? 'Đã tải gói: $packName (${audioFiles.length} file audio, có file sequence.json)'
            : 'Đã tải gói: $packName (${audioFiles.length} file audio, không có file sequence.json)';
      });
    } catch (e) {
      print('Error loading pack content: $e');
      setState(() {
        _statusText = 'Lỗi khi tải nội dung gói: $e';
      });
    }
  }

  Future<void> _playAudio(AudioFile audio) async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setFilePath(audio.path);
      await _audioPlayer.play();

      setState(() {
        _currentlyPlaying = audio.path;
        _statusText = 'Đang phát: ${audio.name}';
      });

      // Cập nhật trạng thái khi phát xong
      _audioPlayer.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            _currentlyPlaying = null;
            _statusText = 'Phát xong: ${audio.name}';
          });
        }
      });
    } catch (e) {
      setState(() {
        _statusText = 'Lỗi khi phát file: $e';
      });
    }
  }

  Future<void> _deleteAudioPack(String packName) async {
    try {
      final packDir = await _getPackDirectory(packName);

      if (await packDir.exists()) {
        await packDir.delete(recursive: true);

        setState(() {
          _downloadedPacks.remove(packName);
          if (_audioFiles.any((file) => file.path.contains(packName))) {
            _audioFiles = [];
            _sequenceData = null;
            _audioPlayer.stop();
            _currentlyPlaying = null;
          }
          _statusText = 'Đã xóa gói: $packName';
        });
      }
    } catch (e) {
      setState(() {
        _statusText = 'Lỗi khi xóa gói: $e';
      });
    }
  }

  Widget _buildSequenceViewer() {
    if (_sequenceData == null) {
      return Center(
        child: Text(
          'Không có dữ liệu sequence.json',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      );
    }

    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dữ liệu sequence.json:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Container(
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    const JsonEncoder.withIndent('  ').convert(_sequenceData),
                    style: TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tải và Phát Gói Audio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'URL file ZIP',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _packNameController,
              decoration: InputDecoration(
                labelText: 'Tên gói (tùy chọn)',
                border: OutlineInputBorder(),
                hintText: 'my_audio_pack',
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(
              onPressed: _isDownloading ? null : _downloadAndExtractZip,
              child: Text('Tải và Giải Nén'),
            ),
            if (_isDownloading)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    LinearProgressIndicator(value: _downloadProgress),
                    SizedBox(height: 4),
                    Text('${(_downloadProgress * 100).toStringAsFixed(1)}%'),
                  ],
                ),
              ),
            SizedBox(height: 8),
            Text(
              _statusText,
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 16),
            Text(
              'Gói audio đã tải:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Container(
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: ListView.builder(
                itemCount: _downloadedPacks.length,
                itemBuilder: (context, index) {
                  final packName = _downloadedPacks[index];

                  return ListTile(
                    title: Text(packName),
                    leading: Icon(Icons.folder),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteAudioPack(packName),
                    ),
                    onTap: () => _loadPackContent(packName),
                  );
                },
              ),
            ),
            if (_sequenceData != null)
              _buildSequenceViewer(),
            SizedBox(height: 16),
            Text(
              'Files trong gói (${_audioFiles.length} files):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _audioFiles.length,
                itemBuilder: (context, index) {
                  final audioFile = _audioFiles[index];
                  final isPlaying = _currentlyPlaying == audioFile.path;

                  return ListTile(
                    title: Text(audioFile.name),
                    leading: Icon(
                      isPlaying ? Icons.pause_circle_filled : Icons.music_note,
                      color: isPlaying ? Colors.blue : Colors.grey,
                    ),
                    onTap: () => _playAudio(audioFile),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AudioFile {
  final String name;
  final String path;

  AudioFile({required this.name, required this.path});
}
