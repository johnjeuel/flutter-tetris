import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tetris/config/app_constants.dart';
import 'package:provider/provider.dart';
import '../provider/data.dart';
import 'sub_block.dart';
import 'block.dart';

enum Collision {
  landed,
  landedBlock,
  hitWall,
  hitBlock,
  none
}

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
  // bool isPlaying = false;
  // int? score;
  bool isGameOver = false;

  BlockMovement? action;

  List<SubBlock> oldSubBlocks = [];

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
    Provider.of<Data>(context, listen: false).setIsPlaying(true);
    Provider.of<Data>(context, listen: false).setScore(0);

    isGameOver = false;
    oldSubBlocks = <SubBlock>[];
    RenderBox? renderBoxGame = _keyGameArea.currentContext?.findRenderObject()! as RenderBox;
    subBlockWidth = (renderBoxGame.size.width - gameAreaBorderWidth * 2) / blocksX;
    Provider.of<Data>(context, listen: false).setNextBlock(getNewBlock());
    block = getNewBlock();
    timer = Timer.periodic(duration, onPlay);
  }

  void updateScore() {
    var combo = 1;
    Map<int, int> rows = Map();
    List<int> rowsToBeRemoved = <int>[];

    oldSubBlocks?.forEach((subBlock) {
      rows.update(subBlock!.y!, (value) => ++value, ifAbsent: () => 1);
    });

    rows.forEach((rowNum, count) {
      if (count == blocksX) {
        Provider.of<Data>(context, listen: false).addScore(combo++);

        rowsToBeRemoved.add(rowNum);
      }
    });

    if(rowsToBeRemoved.length > 0){
      removeRows(rowsToBeRemoved);
    }
  }
  
  void removeRows(List<int> rowsTobeRemoved) {
    rowsTobeRemoved.sort();
    rowsTobeRemoved.forEach((rowNum) {
      oldSubBlocks.removeWhere((subBlock) => subBlock.y == rowNum);
      oldSubBlocks.forEach((subBlock) {
        if(subBlock!.y! < rowNum){
          subBlock!.y! + 1;
        }
      });
    });
  }

  void onPlay(Timer timer) {
    var status = Collision.none;

    setState(() {
        if(action != null) {
          if(!checkOnEdge(action!)) {
            block!.move(action!);
          }
        }

        for(var oldSubBlock in oldSubBlocks) {
          for(var subBlock in block!.subBlocks){
            var x = block!.x! + subBlock!.x;
            var y = block!.y! + subBlock!.y;
            if(x == oldSubBlock!.x && y == oldSubBlock!.y) {
              switch(action) {
                case BlockMovement.left:
                  block!.move(BlockMovement.right);
                  break;
                case BlockMovement.right:
                  block!.move(BlockMovement.left);
                  break;
                case BlockMovement.rotateClockwise:
                  block!.move(BlockMovement.rotateCounterClockwise);
                  break;
              }
            }

          }
        }

        if(!checkAtBottom()) {
          if(!checkAboveBlock()){
            block!.move(BlockMovement.down);
          } else {
            status = Collision.landedBlock;
          }

        } else {
          status = Collision.landed;
        }

        if(status == Collision.landedBlock && block!.y! < 0){
          isGameOver = true;
          endGame();
        } else if(status == Collision.landed || status == Collision.landedBlock) {
          block!.subBlocks!.forEach((subBlock) {
            subBlock!.x = subBlock!.x! + block!.x!;
            subBlock!.y = subBlock!.y! + block!.y!;
            oldSubBlocks.add(subBlock);
          });

          block = Provider.of<Data>(context, listen: false).nextBlock;
          Provider.of<Data>(context, listen: false).setNextBlock(getNewBlock());
        }

        action = null;
        updateScore();
    });
  }

  bool checkAtBottom() {
    return block!.y! + block!.height == blocksY;
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
    Provider.of<Data>(context, listen: false).setIsPlaying(false);
    timer!.cancel();
  }

  Widget drawBlocks() {
    if(block == null) return SizedBox();
    List<Positioned> subBlocks = <Positioned>[];

    block!.subBlocks.forEach((subBlock) {
      subBlocks.add(getPositionedSquareContainer(subBlock.color, subBlock.x + block!.x, subBlock.y + block!.y));
    });

    oldSubBlocks?.forEach((element) {
      subBlocks.add(getPositionedSquareContainer(element.color!, element.x!, element.y!));
    });

    if(isGameOver) {
      subBlocks.add(getGameOverRect());
    }

    return Stack(children: subBlocks);
  }

  Positioned getGameOverRect() {
    return Positioned(
        child: Container(
          width: subBlockWidth! * 8,
          height: subBlockWidth! * 3,
          alignment:  Alignment.center,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.red
          ),
          child: const Text('Game Over',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          ),
        ),
      left: subBlockWidth! * 1,
        top: subBlockWidth! * 6,
    );
  }

  bool checkAboveBlock() {
    for(var oldSubBlock in oldSubBlocks) {
      for(var subBlock in block!.subBlocks){
        var x = block!.x! + subBlock.x;
        var y = block!.y! + subBlock.y;
        if(x == oldSubBlock.x && y + 1 == oldSubBlock.y) {
          return true;
        }
      }
    }
    return false;
  }

  bool checkOnEdge(BlockMovement action) {
    return (action == BlockMovement.left && block!.x! <= 0) ||
        (action == BlockMovement.right && block!.x! + block!.width >= blocksX);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if(details.delta.dx > 0) {
          action = BlockMovement.right;
        } else {
          action = BlockMovement.left;
        }
      },
      onTap: () {
        action = BlockMovement.rotateClockwise;
      },
      child: AspectRatio(
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
      ),
    );
  }
}
