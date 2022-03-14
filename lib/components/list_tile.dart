import 'package:flutter/material.dart';

import 'package:sevenwonders/components/selector.dart';

class ListTilePlayerWithNumberSelector extends StatelessWidget {
  const ListTilePlayerWithNumberSelector({
    Key? key,
    required this.playerName,
    required this.selector,
  })  : assert(playerName.length > 0),
        super(key: key);

  final String playerName;

  final NumberSelector selector;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
            title: Text(playerName),
          ),
        ),
        selector,
      ],
    );
  }
}
