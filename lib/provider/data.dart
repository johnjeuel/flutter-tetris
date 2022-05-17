
import 'package:flutter/material.dart';

import '../modules/block.dart';

class Data with ChangeNotifier {
  int score = 0;
  bool isPlaying = false;
  Block? nextBlock;

  void setScore(int score) {
    this.score = score;
    notifyListeners();
  }

  void addScore(int score){
    this.score += score;
    notifyListeners();
  }

  void setIsPlaying(bool isPlaying) {
    this.isPlaying = isPlaying;
    notifyListeners();
  }

  void setNextBlock(Block nextBlock) {
    this.nextBlock = nextBlock;
    notifyListeners();
  }

  Widget getNextBlockWidget() {
    if(!isPlaying) return Container();

    var width = nextBlock!.width;
    var height = nextBlock!.height;
    var color;

    List<Widget> columns = [];

    for(var y = 0; y < height; ++y) {
      List<Widget> rows = [];
      for(var x = 0; x < width; ++x) {
        if(nextBlock!.subBlocks
        .where((subBlock) => subBlock!.x == x && subBlock!.y == y)
        .length > 0
        ) {
          color = nextBlock!.color;
        } else {
          color = Colors.transparent;
        }

        rows.add(Container(width: 12, height: 12, color: color,));
      }

      columns.add(
        Row(mainAxisAlignment: MainAxisAlignment.center, children: rows,)
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: columns,
    );
  }
}