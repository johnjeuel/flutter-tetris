import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tetris/modules/game.dart';
import 'package:flutter_tetris/modules/next_block.dart';
import 'modules/score_bar.dart';

void main() {
  runApp(const TetrisApp());
}

class TetrisApp extends StatefulWidget {
  const TetrisApp({Key? key}) : super(key: key);

  @override
  State<TetrisApp> createState() => _TetrisAppState();
}

class _TetrisAppState extends State<TetrisApp> {
  GlobalKey<GameState> _keyGame = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('TETRIS'),
          centerTitle: true,
          backgroundColor: Colors.indigoAccent,
        ),
        backgroundColor: Colors.indigo,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              ScoreBar(),
              SizedBox(height: 50),
              Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                          child: Game(key: _keyGame),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(5, 10, 10, 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              NextBlock(),
                              SizedBox(height: 30),
                              RaisedButton(
                                  child: Text(
                                    _keyGame.currentContext != null && _keyGame.currentState!.isPlaying ? 'End'
                                    : 'Start',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey.shade200
                                    ),
                                  ),
                                  onPressed: (){
                                    setState(() {
                                      _keyGame.currentState != null && _keyGame.currentState!.isPlaying
                                          ? _keyGame.currentState!.endGame()
                                          : _keyGame.currentState!.startGame();
                                    });
                                  },
                                color: Colors.indigo.shade700,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}


