import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TicTacToeScreen(),
    );
  }
}

class TicTacToeScreen extends StatefulWidget {
  @override
  _TicTacToeScreenState createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  late List<List<String>> board;
  late String currentPlayer;
  late bool gameFinished;
  late int xScore;
  late int oScore;
  int gridSize = 3;
  bool isPlayerX = true;

  @override
  void initState() {
    super.initState();
    initializeGame();
  }

  void initializeGame() {
    board = List.generate(gridSize, (index) => List.filled(gridSize, ''));
    currentPlayer = isPlayerX ? 'X' : 'O';
    gameFinished = false;
    xScore = 0;
    oScore = 0;
  }

  void makeMove(int row, int col) {
    if (board[row][col] == '' && !gameFinished) {
      setState(() {
        board[row][col] = currentPlayer;
        if (checkWinner(row, col)) {
          gameFinished = true;
          updateScore();
          showWinnerDialog();
        } else if (isBoardFull()) {
          gameFinished = true;
          showDrawDialog();
        } else {
          isPlayerX = !isPlayerX;
          currentPlayer = isPlayerX ? 'X' : 'O';
        }
      });
    }
  }

  bool checkWinner(int row, int col) {
    if (board[row].every((symbol) => symbol == currentPlayer)) {
      return true;
    }
    if (List.generate(gridSize, (index) => board[index][col])
        .every((symbol) => symbol == currentPlayer)) {
      return true;
    }
    if ((row == col || row + col == gridSize - 1) &&
        (List.generate(gridSize, (index) => board[index][index])
                .every((symbol) => symbol == currentPlayer) ||
            List.generate(
                    gridSize, (index) => board[index][gridSize - 1 - index])
                .every((symbol) => symbol == currentPlayer))) {
      return true;
    }
    return false;
  }

  bool isBoardFull() {
    return board.every((row) => row.every((symbol) => symbol != ''));
  }

  void showWinnerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Player $currentPlayer wins!'),
          actions: [
            TextButton(
              onPressed: () {
                resetGame();
                Navigator.of(context).pop();
              },
              child: Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  void showDrawDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('It\'s a Draw!'),
          actions: [
            TextButton(
              onPressed: () {
                resetGame();
                Navigator.of(context).pop();
              },
              child: Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  void showResetConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are you sure you want to reset the game?'),
          actions: [
            TextButton(
              onPressed: () {
                resetGame();
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    setState(() {
      initializeGame();
    });
  }

  void updateScore() {
    if (currentPlayer == 'X') {
      xScore++;
    } else {
      oScore++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
        actions: [
          IconButton(
            icon: Icon(Icons.swap_horiz),
            onPressed: () {
              setState(() {
                isPlayerX = !isPlayerX;
                currentPlayer = isPlayerX ? 'X' : 'O';
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.green],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Player X Score: $xScore | Player O Score: $oScore',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize,
                ),
                itemCount: gridSize * gridSize,
                itemBuilder: (context, index) {
                  int row = index ~/ gridSize;
                  int col = index % gridSize;
                  return InkWell(
                    onTap: () => makeMove(row, col),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          board[row][col],
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (!gameFinished) {
                    showResetConfirmationDialog();
                  } else {
                    resetGame();
                  }
                },
                child: Text('Reset Game'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // Button color
                  onPrimary: Colors.white, // Text color
                ),
              ),
              SizedBox(height: 10),
              DropdownButton<int>(
                value: gridSize,
                items: [3, 4, 5]
                    .map((size) => DropdownMenuItem<int>(
                          value: size,
                          child: Text('$size x $size'),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    gridSize = value!;
                    resetGame();
                  });
                },
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
