import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tetris/config/app_constants.dart';

import 'block.dart';

class Game extends StatefulWidget {
  Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => GameState();
}

class GameState extends State<Game> {
  GlobalKey _keyGameArea = GlobalKey();
  Duration duration = const Duration(milliseconds: 300);
  double? subBlockWidth;
  Block? block;
  Timer? timer;
  bool isPlaying = false;

  Block getNewBlock() {
    int blockType = Random().nextInt(7);
    int orientationIndex = Random().nextInt(4);

    switch (blockType) {
      case 0:
        return IBlock(orientationIndex);
      case 1:
        return JBlock(orientationIndex);
      case 2:
        return LBlock(orientationIndex);
      case 3:
        return IBlock(orientationIndex);
      case 4:
        return TBlock(orientationIndex);
      case 5:
        return SBlock(orientationIndex);
      case 6:
        return ZBlock(orientationIndex);
      default:
        return IBlock(orientationIndex);
    }

  }

  void startGame() {
    isPlaying = true;
    RenderBox? renderBoxGame = _keyGameArea.currentContext?.findRenderObject()! as RenderBox;
    subBlockWidth = (renderBoxGame.size.width - gameAreaBorderWidth * 2) / blocksX;
    block = getNewBlock();
    timer = Timer.periodic(duration, onPlay);
  }

  void onPlay(Timer timer) {
    setState(() {
        block!.move(BlockMovement.down);
    });
  }

  Positioned getPositionedSquareContainer(Color color, int x, int y) {
    return Positioned(
      left: x * subBlockWidth!,
      top:  y * subBlockWidth!,
      child: Container(
        width: subBlockWidth! - subBlockEdgeWidth,
        height: subBlockWidth! - subBlockEdgeWidth,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(Radius.circular(3))
        ),
      ),
    );
  }

  void endGame() {
      isPlaying = false;
    timer!.cancel();
  }

  Widget drawBlocks() {
    if(block == null) return SizedBox();
    List<Positioned> subBlocks = <Positioned>[];

    block!.subBlocks.forEach((subBlock) {
      subBlocks.add(getPositionedSquareContainer(subBlock.color, subBlock.x + block!.x, subBlock.y + block!.y));
    });

    return Stack(children: subBlocks);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: blocksX / blocksY,
      child: Container(
        key: _keyGameArea,
        decoration: BoxDecoration(
          color: Colors.indigo.shade800,
          border: Border.all(
            width: 2,
            color: Colors.indigoAccent
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10))
        ),
        child: drawBlocks(),
      ),
    );
  }
}
