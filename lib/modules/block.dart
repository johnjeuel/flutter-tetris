import 'package:flutter/material.dart';
import 'sub_block.dart';

enum BlockMovement {
  up,
  down,
  left,
  right,
  rotateClockwise,
  rotateCounterClockwise
}

class Block {
  List<List<SubBlock>>? orientations = [];
  int? x;
  int? y;
  int? orientationIndex;

  Block(this.orientations, Color color, this.orientationIndex) {
    x = 3;
    y = -width - 1;
    this.color = color;
  }

  set color(Color color) {
    orientations?.forEach((orientation) {
      orientation.forEach((subBlock) {
          subBlock.color = color;
      });
    });
  }

  Color get color {
    return orientations![0][0].color!;
  }

  get subBlocks {
    return orientations?[orientationIndex!];
  }

  get width {
    int maxX = 0;
    subBlocks.forEach((subBlock) {
      if(subBlock.x > maxX) maxX = subBlock.x;
    });
    return maxX + 1;
  }

  get height {
    int maxY = 0;
    subBlocks.forEach((subBlock) {
      if(subBlock.y > maxY) maxY = subBlock.y;
    });
    return maxY + 1;
  }

  void move(BlockMovement blockMovement) {
    switch (blockMovement) {
      case BlockMovement.up:
        y = y! - 1;
        break;
      case BlockMovement.down:
        y = y! + 1;
        break;
      case BlockMovement.left:
        x = x! - 1;
        break;
      case BlockMovement.right:
        x = x! + 1;
        break;
      case BlockMovement.rotateClockwise:
        orientationIndex = (orientationIndex! + 1) % 4;
        break;
      case BlockMovement.rotateCounterClockwise:
        orientationIndex = (orientationIndex! + 3) % 4;
        break;
    }
  }
}

class IBlock extends Block {
  IBlock(int orientationIndex) : super([
    [SubBlock(0, 0), SubBlock(0, 1), SubBlock(0, 2), SubBlock(0, 3)],
    [SubBlock(0, 0), SubBlock(1, 0), SubBlock(2, 0), SubBlock(3, 0)],
    [SubBlock(0, 0), SubBlock(0, 1), SubBlock(0, 2), SubBlock(0, 3)],
    [SubBlock(0, 0), SubBlock(1, 0), SubBlock(2, 0), SubBlock(3, 0)],
  ], Colors.red.shade400, orientationIndex);
}

class JBlock extends Block {
  JBlock(int orientationIndex) : super([
    [SubBlock(1, 0), SubBlock(1, 1), SubBlock(1, 2), SubBlock(0, 2)],
    [SubBlock(0, 0), SubBlock(0, 1), SubBlock(1, 1), SubBlock(2, 1)],
    [SubBlock(0, 0), SubBlock(1, 0), SubBlock(0, 1), SubBlock(0, 2)],
    [SubBlock(0, 0), SubBlock(1, 0), SubBlock(2, 0), SubBlock(2, 1)],
  ], Colors.yellow.shade300, orientationIndex);
}

class LBlock extends Block {
  LBlock(int orientationIndex) : super([
    [SubBlock(0, 0), SubBlock(0, 1), SubBlock(0, 2), SubBlock(1, 2)],
    [SubBlock(0, 0), SubBlock(1, 0), SubBlock(2, 0), SubBlock(0, 1)],
    [SubBlock(0, 0), SubBlock(1, 0), SubBlock(1, 1), SubBlock(1, 2)],
    [SubBlock(2, 0), SubBlock(0, 1), SubBlock(1, 1), SubBlock(2, 1)],
  ], Colors.green.shade300, orientationIndex);
}

class OBlock extends Block {
  OBlock(int orientationIndex) : super([
    [SubBlock(0, 0), SubBlock(1, 0), SubBlock(0, 1), SubBlock(1, 1)],
    [SubBlock(0, 0), SubBlock(1, 0), SubBlock(0, 1), SubBlock(1, 1)],
    [SubBlock(0, 0), SubBlock(1, 0), SubBlock(0, 1), SubBlock(1, 1)],
    [SubBlock(0, 0), SubBlock(1, 0), SubBlock(0, 1), SubBlock(1, 1)],
  ], Colors.blue, orientationIndex);
}

class TBlock extends Block {
  TBlock(int orientationIndex) : super([
    [SubBlock(0, 0), SubBlock(1, 0), SubBlock(2, 0), SubBlock(1, 1)],
    [SubBlock(1, 0), SubBlock(0, 1), SubBlock(1, 1), SubBlock(1, 2)],
    [SubBlock(1, 0), SubBlock(0, 1), SubBlock(1, 1), SubBlock(2, 1)],
    [SubBlock(0, 0), SubBlock(0, 1), SubBlock(1, 1), SubBlock(0, 2)],
  ], Colors.purpleAccent, orientationIndex);
}

class SBlock extends Block {
  SBlock(int orientationIndex) : super([
    [SubBlock(1, 0), SubBlock(2, 0), SubBlock(0, 1), SubBlock(1, 1)],
    [SubBlock(0, 0), SubBlock(0, 1), SubBlock(1, 1), SubBlock(1, 2)],
    [SubBlock(1, 0), SubBlock(2, 0), SubBlock(0, 1), SubBlock(1, 1)],
    [SubBlock(0, 0), SubBlock(0, 1), SubBlock(1, 1), SubBlock(1, 2)],
  ], Colors.orange.shade300, orientationIndex);
}

class ZBlock extends Block {
  ZBlock(int orientationIndex) : super([
    [SubBlock(0, 0), SubBlock(1, 0), SubBlock(1, 1), SubBlock(2, 1)],
    [SubBlock(1, 0), SubBlock(0, 1), SubBlock(1, 1), SubBlock(0, 2)],
    [SubBlock(0, 0), SubBlock(1, 0), SubBlock(1, 1), SubBlock(2, 1)],
    [SubBlock(1, 0), SubBlock(0, 1), SubBlock(1, 1), SubBlock(0, 2)],
  ], Colors.cyan.shade300, orientationIndex);
}


