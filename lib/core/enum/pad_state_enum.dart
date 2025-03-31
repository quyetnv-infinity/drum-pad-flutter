import 'package:drumpad_flutter/core/utils/locator_support.dart';
import 'package:flutter/material.dart';

enum PadStateEnum {
  perfect, good, early, late, miss, none
}

extension PadStateExtension on PadStateEnum {
  String getDisplayText(BuildContext context) {
    switch (this) {
      case PadStateEnum.perfect:
        return context.locale.perfect;
      case PadStateEnum.good:
        return context.locale.good;
      case PadStateEnum.early:
        return context.locale.early;
      case PadStateEnum.late:
        return context.locale.late;
      case PadStateEnum.miss:
        return context.locale.miss;
      default:
        return '';
    }
  }
}