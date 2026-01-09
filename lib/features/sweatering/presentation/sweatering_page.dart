import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sweater/features/feed/presentation/widgets/bottomsheet.dart';
import 'package:sweater/models/sport.dart';
import 'package:sweater/features/sweatering/model/sweateringstatus.dart';

class SweateringPage extends ConsumerStatefulWidget {
  final Sport sport;
  const SweateringPage({super.key, required this.sport,});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<SweateringPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.sport.name),
        centerTitle: true,
      ),
      body: Column(
        children: [
          GridView.count(
            crossAxisCount: 2,   //열 개수
            mainAxisSpacing: 12, //세로 간격
            crossAxisSpacing: 12,
            childAspectRatio: 2, //가로/세로 비율
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              _MetricTile('distance', '5.21 km'),
              _MetricTile('speed', '22.3 km/hr'),
              _MetricTile('max speed', '25 km/hr'),
              _MetricTile('duration', '20:00 min'),
              _MetricTile('elevation', '200 m'),
              _MetricTile('avg speed', ' 20 km/h'),
              _MetricTile('pace', '5:00 min/km'),

            ],

          ),
          TextButton(onPressed: () {
            ref.read(sweateringStateProvider.notifier).state = Sweateringstatus.completed;
          }, child: Text('종료'))
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String title;
  final String value;

  const _MetricTile(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}