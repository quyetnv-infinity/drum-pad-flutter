import 'package:and_drum_pad_flutter/data/model/lesson_model.dart';

class CampaignModel {
  String difficulty;
  List<SongCollection> data;
  int unlocked;

  CampaignModel({
    required this.difficulty,
    required this.data,
    this.unlocked = 0,
  });
}