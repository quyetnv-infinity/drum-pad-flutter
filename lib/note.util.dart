List<String> sortDrumpadSounds(List<String> sounds) {
  if (sounds.isEmpty) return List.filled(12, "Empty"); // Nếu rỗng, trả về 12 ô trống

  Map<int, String> soundMap = {}; // Lưu số thứ tự và sound
  List<int> numbers = []; // Danh sách số thứ tự

  // Phân loại và lấy số thứ tự
  for (var sound in sounds) {
    int number = extractNumber(sound);
    soundMap[number] = sound;
    numbers.add(number);
  }

  // Xác định phạm vi số thứ tự
  numbers.sort();
  int minNumber = numbers.first;
  int maxNumber = numbers.last;

  // Tạo danh sách đủ 12 ô, ưu tiên giữ thứ tự gốc
  List<String> sortedList = [];
  int index = minNumber;

  while (sortedList.length < 12) {
    if (soundMap.containsKey(index)) {
      sortedList.add(soundMap[index]!);
    } else {
      sortedList.add("");
    }
    index++;

    // Nếu hết số nhưng chưa đủ 12 ô → thêm "Empty"
    if (index > maxNumber && sortedList.length < 12) {
      sortedList.add("");
    }
  }

  return sortedList;
}

// Hàm trích xuất số thứ tự từ tên file
int extractNumber(String sound) {
  final match = RegExp(r'(\d+)').firstMatch(sound);
  return match != null ? int.parse(match.group(0)!) : 0;
}
