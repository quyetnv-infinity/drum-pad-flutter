import 'package:and_drum_pad_flutter/core/res/drawer/image.dart';
import 'package:and_drum_pad_flutter/data/model/category_model.dart';

class CategoryBackground {
  static String getCategoryImage(Category category) {
    final name = category.name.trim().toLowerCase();

    if (name == 'edm') {
      return ResImage.imgBgEDM;
    } else if (name == 'hiphop') {
      return ResImage.imgBgHipHop;
    } else if (name == 'phonk') {
      return ResImage.imgBgPhonk;
    } else if (name == 'pop') {
      return ResImage.imgBgPop;
    } else {
      return ResImage.imgBgEDM;
    }
  }
}
