import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:sweater/models/sport.dart';

final selectedSportProvider = StateProvider<Sport?> ((ref) => null);


Widget wheelPicker({
  required WidgetRef ref,
  required List<Sport> sportsList,
  required void Function(Sport selected) onSelected,
  int initialIndex = 0,
}) {
  return Column(
    children: [
       CupertinoPicker(
          magnification: 1.2,
          squeeze: 1.2,
          itemExtent: 60,
          scrollController: FixedExtentScrollController(
            initialItem: initialIndex,
          ),
          onSelectedItemChanged: (index) {
            final selected = sportsList[index];
            ref.read(selectedSportProvider.notifier).state = selected;
          },
          children: sportsList.map((sport) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(sport.icon, size: 22),
                const SizedBox(width: 10),
                Text(
                  sport.name,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            );
          }).toList(),
        ),
    ]
  );
}