import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData.dark(),
      home: new Game(),
    );
  }
}

class Game extends StatefulWidget {
  @override
  _GameState createState() => new _GameState();
}

class _GameState extends State<Game> {
  List<Button> btns;
  var p1,p2,active;
  var p1Win = 0;
  var p2Win = 0;

  @override
  void initState() {
    super.initState();
    btns = init();
  }

  List<Button> init() {
    p1 = new List();
    p2 = new List();
    active = (p1Win+p2Win)%2+1;

    var buttons = new List<Button>.generate(9, (int index) => Button(id: index));
    return buttons;
  }

  void playGame(Button gb) {
    setState(() {
      if (active == 1) {
        gb.text = "X"; gb.bg = Colors.red; active = 2; p1.add(gb.id);
      } else {
        gb.text = "0"; gb.bg = Colors.blue; active = 1; p2.add(gb.id);
      }
      gb.enabled = false; int winner = checkWinner();
      if (winner == -1) {
        if (btns.every((p) => p.text != "")) { dialog("Game Tie !!"); }
      }
    });
  }

  bool chk(p,a,b,c) {
    return p.contains(a) && p.contains(b) && p.contains(c);
  }

  int checkWinner() {
    var winner = -1;
    if(chk(p1,0,1,2) || chk(p1,3,4,5) || chk(p1,6,7,8) ||
        chk(p1,0,3,6) || chk(p1,1,4,7) || chk(p1,2,5,8) ||
        chk(p1,0,4,8) || chk(p1,2,4,6)) { winner = 1; }

    if(chk(p2,0,1,2) || chk(p2,3,4,5) || chk(p2,6,7,8) ||
        chk(p2,0,3,6) || chk(p2,1,4,7) || chk(p2,2,5,8) ||
        chk(p2,0,4,8) || chk(p2,2,4,6)) { winner = 2; }

    if (winner != -1) {
      setState(() {
        if(winner==1) { p1Win += 1; }
        else if(winner==2) { p2Win += 1; }
      });
      dialog("Player $winner Won !!");
    }
    return winner;
  }

  void reset() {
    if (Navigator.canPop(context)) Navigator.pop(context);
    setState(() { btns = init(); });
  }

  void dialog(text) {
    showDialog( context: context,
        barrierDismissible: false,
        builder: (_) => new AlertDialog(
          title: new Text(text),
          actions: <Widget>[
            new FlatButton( onPressed: reset,
              color: Colors.blue,
              child: new Text("Reset"),
            )],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Center(
            child: Text("Tic Tac Toe"),
          ),
        ),
        body: new Column(
          mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Expanded(
              child: new GridView.builder(
                padding: const EdgeInsets.all(10.0),
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 1.0, crossAxisSpacing: 9.0, mainAxisSpacing: 9.0),
                itemCount: btns.length,
                itemBuilder: (context, i) => new SizedBox(
                  width: 100.0, height: 100.0,
                  child: new RaisedButton(
                    padding: const EdgeInsets.all(8.0),
                    onPressed: btns[i].enabled ? () => playGame(btns[i]) : null,
                    child: new Text( btns[i].text,
                        style: new TextStyle(
                            color: Colors.white, fontSize: 70.0, fontWeight: FontWeight.w900 ) ),
                    color: btns[i].bg,
                    disabledColor: btns[i].bg,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(50.0),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Text("Player 1 wins = $p1Win",
                        style: new TextStyle( color: Colors.red, fontSize: 25.0, fontWeight: FontWeight.w400 )
                    ),
                    Text("Player 2 wins = $p2Win",
                        style: new TextStyle( color: Colors.blue, fontSize: 25.0, fontWeight: FontWeight.w400 )
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(30.0),
              child: Center(
                child: Text("Player $active turn !!",
                    style: new TextStyle( color: active == 1 ? Colors.red : Colors.blue, fontSize: 50.0, fontWeight: FontWeight.w500 )
                ),
              ),
            ),
            new RaisedButton(
              child: new Text( "Reset",
                  style: new TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w400) ),
              color: active == 1 ? Colors.red : Colors.blue,
              padding: const EdgeInsets.all(20.0), onPressed: reset,
            )
          ],
        ));
  }
}

class Button {
  final id; String text; Color bg; bool enabled;
  Button({this.id, this.text = "", this.bg = Colors.grey, this.enabled = true});
}
