import processing.net.*;

Server myServer; 

color lightbrown = #FFFFC3;
color darkbrown  = #D8864E;
PImage wrook, wbishop, wknight, wqueen, wking, wpawn;
PImage brook, bbishop, bknight, bqueen, bking, bpawn;
boolean firstClick;
boolean turn = false;
boolean pawnpromotion;
int row1, col1, row2, col2;
char RAGERAGERAGE;

char grid[][] = {
  {'R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R'}, 
  {'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '}, 
  {'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p'}, 
  {'r', 'n', 'b', 'q', 'k', 'b', 'n', 'r'}
};

void setup() {
  size(800, 800);
  size(800, 800);
  strokeWeight(3);
  textAlign(CENTER, CENTER);
  textSize(20);
  myServer = new Server(this, 1234);
  firstClick = true;



  brook = loadImage("blackRook.png");
  bbishop = loadImage("blackBishop.png");
  bknight = loadImage("blackKnight.png");
  bqueen = loadImage("blackQueen.png");
  bking = loadImage("blackKing.png");
  bpawn = loadImage("blackPawn.png");

  wrook = loadImage("whiteRook.png");
  wbishop = loadImage("whiteBishop.png");
  wknight = loadImage("whiteKnight.png");
  wqueen = loadImage("whiteQueen.png");
  wking = loadImage("whiteKing.png");
  wpawn = loadImage("whitePawn.png");
}

void draw() {
  drawBoard();
  drawPieces();
  receiveMove();

  fill(0);
  if (turn) {
    text("Your Turn", 400, 400);
  } else {
    text(" ", 400, 400);
  }
}
void pawnPromotion() {
  if (key == 'r' || key == 'R') {
    grid[0][col2] = 'r';
  } else if (key == 'b' || key == 'B') {
    grid[0][col2] = 'b';
  } else if (key == 'q' || key == 'Q') {
    grid[0][col2] = 'q';
  } else if (key == 'n' || key == 'N') {
    grid[0][col2] = 'n';
  }
  myServer.write(row1 + "," + col1 + "," + row2 + "," + col2 + ","+ "2");
  pawnpromotion = false;
}
void receiveMove() {
  Client myclient = myServer.available();
  if (myclient != null) {
    String incoming = myclient.readString();
    int r1 = int(incoming.substring(0, 1));
    int c1 = int(incoming.substring(2, 3));
    int r2 = int(incoming.substring(4, 5));
    int c2 = int(incoming.substring(6, 7));
    int ctrl = int(incoming.substring(8, 9));
    

    if (ctrl == 0) {
      grid[r2][c2] = grid[r1][c1];
      grid[r1][c1] = ' ';
      turn = true;
    } else if (ctrl == 1) {
      char tempE = grid[r2][c2];
      grid[r2][c2] = grid[r1][c1];

      grid[r1][c1] = tempE;
      turn = false;
    } else if (ctrl == 2) {
      if (r1 == 1) {
        grid[0][c2]='r';
      } else if (r1 == 2) {
        grid[0][c2]='b';
      } else if (r1 == 3) {
        grid[0][c2]='q';
      } else if (r1 == 4) {
        grid[0][c2]='n';
      }
      turn = true;
    }
  }
}

void drawBoard() {
  for (int r = 0; r < 8; r++) {
    for (int c = 0; c < 8; c++) { 
      if ( (r%2) == (c%2) ) { 
        fill(lightbrown);
      } else { 
        fill(darkbrown);
      }
      rect(c*100, r*100, 100, 100);
    }
  }
}

void drawPieces() {
  for (int r = 0; r < 8; r++) {
    for (int c = 0; c < 8; c++) {
      if (grid[r][c] == 'r') image (wrook, c*100, r*100, 100, 100);
      if (grid[r][c] == 'R') image (brook, c*100, r*100, 100, 100);
      if (grid[r][c] == 'b') image (wbishop, c*100, r*100, 100, 100);
      if (grid[r][c] == 'B') image (bbishop, c*100, r*100, 100, 100);
      if (grid[r][c] == 'n') image (wknight, c*100, r*100, 100, 100);
      if (grid[r][c] == 'N') image (bknight, c*100, r*100, 100, 100);
      if (grid[r][c] == 'q') image (wqueen, c*100, r*100, 100, 100);
      if (grid[r][c] == 'Q') image (bqueen, c*100, r*100, 100, 100);
      if (grid[r][c] == 'k') image (wking, c*100, r*100, 100, 100);
      if (grid[r][c] == 'K') image (bking, c*100, r*100, 100, 100);
      if (grid[r][c] == 'p') image (wpawn, c*100, r*100, 100, 100);
      if (grid[r][c] == 'P') image (bpawn, c*100, r*100, 100, 100);
    }
  }
}
void mouseReleased() {
  if (firstClick) {
    row1 = mouseY/100;
    col1 = mouseX/100;
    firstClick = false;
  } else {
    row2 = mouseY/100;
    col2 = mouseX/100;
    if (turn && !(row2 == row1 && col2 == col1)) {
      RAGERAGERAGE = grid[row2][col2];
      if (grid[row1][col1] == 'p' && row2 == 0) {
        pawnpromotion = true;
      }
      grid[row2][col2] = grid[row1][col1];
      grid[row1][col1] = ' ';
      myServer.write(row1 + "," + col1 + "," + row2 + "," + col2 + "," + "0");
      firstClick = true;
      turn = false;
    }
  }
}
void keyReleased() {
  if ((key == 'z' || key == 'Z') && !turn) {
    grid[row1][col1] = grid[row2][col2];
    grid[row2][col2] =  RAGERAGERAGE;
    myServer.write(row1 + "," + col1 + "," + row2 + "," + col2 + "," + "1");
    turn = true;
  }
  if (pawnpromotion) pawnPromotion();
}
