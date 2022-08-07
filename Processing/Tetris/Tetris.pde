

final int CELLSIZE = 30;
final int NUM_ROWS = 20;
final int NUM_COLS = 12;

final int SQUARES_PER_PIECE = 4;
final int COMPLETED_ROWS_TO_ADD_LEVEL = 5;

final int STARTING_NUM_FRAMES = 60;

int[] fallingX; //the grid coordinates of the falling piece
int[] fallingY;

int[] landedX;
int[] landedY;
int numLanded;

boolean generatedPieceLanded;


int numFrames;

int linesCompleted;

void setup() {
  size(360, 600); //size MUST be (NUM_COLS*CELLSIZE) by (NUM_ROWS*CELLSIZE);
  //noLoop();
  newGame();
}

//newGame: create the arrays required by the game
void newGame(){
  fallingX = new int[SQUARES_PER_PIECE];
  fallingY = new int[SQUARES_PER_PIECE];
  
  landedX = new int[NUM_ROWS * NUM_COLS];
  landedY = new int[NUM_ROWS * NUM_COLS];
  
  numLanded = 0;
  generatedPieceLanded = true;
  numFrames = STARTING_NUM_FRAMES;
  linesCompleted = 0;
}

void draw() {
  fill(211,211,211); //gray color
  rect(0, 0, NUM_COLS * CELLSIZE, NUM_ROWS * CELLSIZE);
  
  //draw the piece 
  drawCells(fallingX, fallingY, SQUARES_PER_PIECE, #44FFFF);
  
  //draw the landed pieces
  drawCells(landedX, landedY, numLanded, #1874CD);
  
  if(!testEndGame(landedY, numLanded)){
    //generate a random game piece
    if(generatedPieceLanded){
      generatePiece(fallingX, fallingY, 1); 
      generatedPieceLanded = false;
    }
    
  
    
    if(frameCount > 0 && frameCount % numFrames == 0){
       if(moveAllowedY(fallingX, fallingY, landedX, landedY, numLanded, 1)){
         makeMove(fallingX, fallingY, 0, 1);
       }
       else{
         numLanded = landPiece(fallingX, fallingY, landedX, landedY, numLanded);
       }
    }
    
    numLanded = clearFullRows(landedX, landedY, numLanded);
  }
  else{
    displayText("GAME OVER!", -1, 40, (NUM_COLS * CELLSIZE) / 4 - 25, (NUM_ROWS * CELLSIZE) / 2, -1, -1);
    displayText("Lines Completed: ", linesCompleted, 25, (NUM_COLS * CELLSIZE) / 4 - 25, (NUM_ROWS * CELLSIZE) / 2 + 40, (NUM_COLS * CELLSIZE) / 2 + 100 , (NUM_ROWS * CELLSIZE) / 2 + 40);
    displayText("Press ENTER to start a new game", -1, 15, (NUM_COLS * CELLSIZE) / 4 - 30, (NUM_ROWS * CELLSIZE) / 2 + 80, -1, -1);
  }
}

void drawCells(int[] testX, int[] testY, int numEntries, int hexColor){
    fill(hexColor);
    for(int i = 0; i < numEntries; i++){
      rect(testX[i] * CELLSIZE, testY[i] * CELLSIZE, CELLSIZE, CELLSIZE);
    }
}

void generatePiece(int[] fallingX, int[] fallingY, int startRow){
    int startCol = (int)((Math.random() * (NUM_COLS)));
    
    ArrayList<int[]> secondCellCoordinatePossibilities = new ArrayList<int[]>();
    secondCellCoordinatePossibilities.add(new int[]{0, 1});
    secondCellCoordinatePossibilities.add(new int[]{-1, 0});
    
    ArrayList<int[][]> thirdCellCoordinatePossibilities = new ArrayList<int[][]>();
    thirdCellCoordinatePossibilities.add(new int[][]{{0, 2}, {-1, 0}, {-1, 1}});
    thirdCellCoordinatePossibilities.add(new int[][]{{-1, 1}, {0, 1}, {-2, 0}});
    
    ArrayList<int[][][]> fourthCellCoordinatePossibilities = new ArrayList<int[][][]>();
    fourthCellCoordinatePossibilities.add(new int[][][]{
      {{0, 3}, {-1, 0}, {-1, 1}, {-1, 2}},
      {{0, 2}, {-1, 1}, {-2, 0}},
      {{0, 2}, {-1, 2}, {-2, 1}, {-1, 0}}
    });
    
    fourthCellCoordinatePossibilities.add(new int[][][]{
      {{-2, 0}, {-2, 1}, {-1, 2}, {0, 1}},
      {{-2, 0}, {-1, 1}, {0, 2}},
      {{0, 1}, {-1, 1}, {-2, 1}, {-3, 0}}
    });
    
    fallingX[0] = startCol;
    fallingY[0] = startRow;
    
    int secondCoordinateIdx = (int)(Math.random() * 2);
    
    fallingX[1] = startCol + secondCellCoordinatePossibilities.get(secondCoordinateIdx)[1];
    fallingY[1] = startRow + secondCellCoordinatePossibilities.get(secondCoordinateIdx)[0];
    
    int thirdCoordinateIdx = (int)(Math.random() * 3);
    
    fallingX[2] = startCol + thirdCellCoordinatePossibilities.get(secondCoordinateIdx)[thirdCoordinateIdx][1];
    fallingY[2] = startRow + thirdCellCoordinatePossibilities.get(secondCoordinateIdx)[thirdCoordinateIdx][0];
    
    int fourthCoordinateIdx = 0;
    
    if(thirdCoordinateIdx == 1)fourthCoordinateIdx = (int)(Math.random() * 3);
    else fourthCoordinateIdx = (int)(Math.random() * 4);
    
    fallingX[3] = startCol + fourthCellCoordinatePossibilities.get(secondCoordinateIdx)[thirdCoordinateIdx][fourthCoordinateIdx][1];
    fallingY[3] = startRow + fourthCellCoordinatePossibilities.get(secondCoordinateIdx)[thirdCoordinateIdx][fourthCoordinateIdx][0];
    
    if(!isFallingCoordinatesValid(fallingX, fallingY))generatePiece(fallingX, fallingY, startRow);
}

boolean search(int[] xValues, int[] yValues, int numValues, int x, int y){
  boolean flag = false;
  
  for(int i = 0; i < numValues; i++){
     if(xValues[i] == x){
        flag = true;
        break;
     }
  }
  
  if(!flag)return false;
  
  for(int i = 0; i < numValues; i++){
     if(yValues[i] == y){
        return true;
     }
  }
  return false;
}

boolean testEndGame(int[] landedY, int numLanded){
  for(int i = 0; i < numLanded; i++)
    if(landedY[i] == 0)return true;
  return false;
}

boolean moveAllowedX(int[] fallingX, int[] fallingY, int[] landedX, int[] landedY, int numLanded, int deltaX){
  for(int i = 0; i < SQUARES_PER_PIECE; i++)
    if(fallingX[i] + deltaX < 0 || fallingX[i] + deltaX >= NUM_COLS)return false;
    
  for(int i = 0; i < SQUARES_PER_PIECE; i++){
    
    for(int j = 0; j < numLanded; j++){
       
        if(fallingX[i] + deltaX == landedX[j] && fallingY[i] == landedY[j])return false;
    }
  }
  return true;
}

boolean moveAllowedY(int[] fallingX, int[] fallingY, int[] landedX, int[] landedY, int numLanded, int deltaY){
  
  for(int i = 0; i < SQUARES_PER_PIECE; i++)
    if(fallingY[i] + deltaY >= NUM_ROWS)return false;
    
  for(int i = 0; i < SQUARES_PER_PIECE; i++){
    
    for(int j = 0; j < numLanded; j++){
       
        if(fallingX[i] == landedX[j] && fallingY[i] + deltaY == landedY[j])return false;
    }
  }
  return true;
}

void makeMove(int[] fallingX, int[] fallingY, int deltaX, int deltaY){
  for(int i = 0; i < SQUARES_PER_PIECE; i++){
    fallingX[i] += deltaX;
    fallingY[i] += deltaY;
  }
}

int landPiece(int[] fallingX, int[] fallingY, int[] landedX, int[] landedY, int numLanded){
  for(int i = 0; i < SQUARES_PER_PIECE; i++){
     landedX[numLanded + i] = fallingX[i];
     landedY[numLanded + i] = fallingY[i];
  }
  numLanded = numLanded + SQUARES_PER_PIECE;
  generatedPieceLanded = true;
  return numLanded;
}

void keyPressed(){
  if(testEndGame(landedY, numLanded)){
      if(keyCode == ENTER)reset();
  }
  else if(key == CODED){
     if(keyCode == LEFT){
       if(moveAllowedX(fallingX, fallingY, landedX, landedY, numLanded, -1))
         makeMove(fallingX, fallingY, -1, 0);
     }
     else if(keyCode == RIGHT){
       if(moveAllowedX(fallingX, fallingY, landedX, landedY, numLanded, 1))
         makeMove(fallingX, fallingY, 1, 0);
     }
     else if(keyCode == DOWN){
       if(moveAllowedY(fallingX, fallingY, landedX, landedY, numLanded, 1))
         makeMove(fallingX, fallingY, 0, 1);
       else numLanded = landPiece(fallingX, fallingY, landedX, landedY, numLanded);
     }
  }
  
  
}

int clearFullRows(int[] x, int[] y, int n){
  for(int r = 0; r <= NUM_ROWS; r++){
    if(rowFull(y, n, r)){
      numLanded = removeRow(x, y, n, r);
      linesCompleted++;
      
      if(linesCompleted % COMPLETED_ROWS_TO_ADD_LEVEL == 0){
         //decrease numFrames
         numFrames -= numFrames / 5;
      }
    }
  }
  return numLanded;
}

boolean rowFull(int[] y, int n, int row){
  int count = 0;
  
  for(int i = 0; i < n; i++)
    if(y[i] == row)count++;
  
  return count == NUM_COLS;
}

int removeRow(int[] x, int[] y, int n, int row){
  int xLength = n, yLength = n;
  for(int i = 0; i < n; i++){
    if(y[i] == row){
       yLength = deleteItem(y, yLength, i);
       xLength = deleteItem(x, xLength, i);
       n = yLength;
       i--;
    }
  }
  
  
  for(int i = 0; i < n; i++){
     if(y[i] < row)y[i] += 1; 
  }
  
  return n;
}

int deleteItem(int[] items, int numItems, int index){
  for(int i = index; i < numItems - 1; i++){
      items[i] = items[i + 1];
  }
  return numItems - 1;
}

boolean isFallingCoordinatesValid(int[] fallingX, int[] fallingY){
  for(int i = 0; i < fallingX.length; i++){
    if(fallingX[i] < 0 || fallingX[i] >= NUM_COLS || fallingY[i] < 0 || fallingY[i] >= NUM_ROWS)return false; 
  }
  return true;
}

void displayText(String text, int value, int textSize, int x1, int y1, int x2, int y2){
  fill(0, 0, 0);
  textSize(textSize);
  text(text, x1, y1);
  if(value != -1){
    
    text(String.valueOf(value), x2, y2);
  }
}

void reset(){
  numLanded = 0;

  generatedPieceLanded = true;
  numFrames = STARTING_NUM_FRAMES;

  linesCompleted = 0;
}
