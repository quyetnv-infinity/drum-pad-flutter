import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/view/widget/text/judgement_text.dart';
import 'package:flutter/material.dart';

enum PadStateEnum {
  perfect, good, early, late, miss, none
}

extension PadStateExtension on PadStateEnum {
  Widget getDisplayWidget(BuildContext context) {
    switch (this) {
      case PadStateEnum.perfect:
        return JudgementText.perfect(context.locale.perfect, fontSize: 20,);
      case PadStateEnum.good:
        return JudgementText.good(context.locale.good, fontSize: 20);
      case PadStateEnum.early:
        return JudgementText.early(context.locale.early, fontSize: 20);
      case PadStateEnum.late:
        return JudgementText.late(context.locale.late, fontSize: 20);
      case PadStateEnum.miss:
        return JudgementText.miss(context.locale.miss,fontSize: 20);
      default:
        return const SizedBox.shrink(); // Trả về widget trống nếu không có trạng thái
    }
  }
}
