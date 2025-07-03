import 'package:and_drum_pad_flutter/core/utils/locator_support.dart';
import 'package:and_drum_pad_flutter/data/model/category_model.dart';
import 'package:and_drum_pad_flutter/view/screen/category/category_details_screen.dart';
import 'package:and_drum_pad_flutter/view/widget/item/mood_and_genres_item.dart';
import 'package:and_drum_pad_flutter/view_model/category_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoodAndGenres extends StatelessWidget {
  final Function(Category category) onTapCategory;
  const MoodAndGenres({super.key, required this.onTapCategory});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Text(context.locale.mood_and_genres, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.8))),
        Consumer<CategoryProvider>(
          builder: (context, provider, _) {
            return GridView.builder(
              padding: EdgeInsets.only(right: 16),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: provider.categories.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.55
            ),
            itemBuilder: (context, index) {
                final category = provider.categories[index];
                return MoodAndGenresItem(
                  category: category,
                  onTap: () {
                    onTapCategory.call(category);
                  },
                );
              }
            );
          },
        ),
      ],
    );
  }
}
