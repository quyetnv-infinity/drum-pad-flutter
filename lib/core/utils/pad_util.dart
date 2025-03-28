import 'package:drumpad_flutter/sound_type_enum.dart';
import 'package:flutter/material.dart';

class PadUtil {
  static bool getPadEnable(String sound) {
    for (var key in soundEnable.keys) {
      if (sound.contains(key)) {
        return soundEnable[key]!;
      }
    }
    return false;
  }

  static SoundType getSoundType(String sound) {
    for (var key in soundTypes.keys) {
      if (sound.contains(key)) {
        return soundTypes[key]!;
      }
    }
    return SoundType.drum;
  }

  static List<Color> getPadGradientColor(bool isActive, String sound){
    if(isActive){
      for (var key in soundGradientActiveColors.keys) {
        if (sound.contains(key)) {
          return soundGradientActiveColors[key]!;
        }
      }
    } else {
      for (var key in soundGradientDefaultColors.keys) {
        if (sound.contains(key)) {
          return soundGradientDefaultColors[key]!;
        }
      }
    }
    return [Color(0xFF919191), Color(0xFF5E5E5E)];
  }

  static final Map<String, List<Color>> soundGradientDefaultColors = {
    'lead': [Color(0xFFBC80D6), Color(0xFFAA46D6)],
    'bass': [Color(0xFF82D6CB), Color(0xFF47D6C3)],
    'drums': [Color(0xFF81C8D6), Color(0xFF47BED6)],
    'fx': [Color(0xFFAED680), Color(0xFF93D647)],
  };

  static final Map<String, List<Color>> soundGradientActiveColors = {
    'lead': [Color(0xFFEFCCFF), Color(0xFFD880FF)],
    'bass': [Color(0xFFCCFFF8), Color(0xFF80FFEE)],
    'drums': [Color(0xFFCCF7FF), Color(0xFF80EAFF)],
    'fx': [Color(0xFFE7FFCC), Color(0xFFC3FF80)],
  };

  static final Map<String, bool> soundEnable = {
    'lead': true,
    'bass': true,
    'drums': true,
    'fx': true,
  };

  static final Map<String, SoundType> soundTypes = {
    'lead': SoundType.lead,
    'bass': SoundType.bass,
    'drums': SoundType.drum,
    'fx': SoundType.fx,
  };
}