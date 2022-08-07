final int HALL_TOP = 40;
final int CANVAS_WIDTH = 600;
final int CANVAS_HEIGHT = CANVAS_WIDTH + 4 * HALL_TOP;

final int NUM_ROWS = 4, NUM_COLS = 4;
final int SPACING_WIDTH = CANVAS_WIDTH / (2 * NUM_COLS + 1), SPACING_HEIGHT = (CANVAS_HEIGHT - 4 * HALL_TOP) / (2 * NUM_ROWS + 1);

final float DOOR_WIDTH = 2 * SPACING_WIDTH, DOOR_HEIGHT = HALL_TOP / 4; 

int carlinX = (int)((1.5 + 2 * (int)(Math.random() * NUM_COLS)) * SPACING_WIDTH);
int carlinY = 2 * HALL_TOP + (2 * NUM_ROWS + 1) * SPACING_WIDTH - (SPACING_WIDTH / 2);


int spiderX = (int)((1.5 + 2 * (int)(Math.random() * NUM_COLS)) * SPACING_WIDTH);
int spiderY = 2 * HALL_TOP + (SPACING_WIDTH / 2);

int characterWidth = SPACING_WIDTH / 2;

float doorX = (float)(Math.random() * (CANVAS_WIDTH - DOOR_WIDTH + 1));

int spiderSpeed = 10;

int currentLevel = 1;

boolean dead = false;

int carlinManaCount = 3, frozenRow = -1, frozenCol = -1;

void setup() {
  size(600, 760);
}

void draw(){
  fill(0, 0, 0);
  
  if(!dead){
    rect(0, 0, CANVAS_WIDTH, HALL_TOP);
    rect(0, HALL_TOP, CANVAS_WIDTH, HALL_TOP);
    
    rect(0, CANVAS_HEIGHT - 2 * HALL_TOP, CANVAS_WIDTH, HALL_TOP); 
    rect(0, CANVAS_HEIGHT - HALL_TOP, CANVAS_WIDTH, HALL_TOP); 
    
    drawHall();
  }
  else{
    fill(0, 0, 0);
    rect(0, 0, CANVAS_WIDTH, CANVAS_HEIGHT);
    displayText("Level: ", currentLevel, 100, CANVAS_WIDTH / 2 - 170, CANVAS_HEIGHT / 2, CANVAS_WIDTH / 2 + 130, CANVAS_HEIGHT / 2);
  }
}

void drawHall(){
  

   fill(220, 220, 220); //gray color
   rect(0, 2 * HALL_TOP, CANVAS_WIDTH, CANVAS_HEIGHT - 4 * HALL_TOP);
   
   fill(150, 75, 0); //brown color
   
   for(int i = 0; i < NUM_ROWS; i++){
      for(int j = 0; j < NUM_COLS; j++){
         rect(SPACING_WIDTH * (2 * j + 1), 2 * HALL_TOP + SPACING_HEIGHT * (2 * i + 1), SPACING_WIDTH, SPACING_HEIGHT); 
      }
   }
   
   if(frozenRow != -1 && frozenCol != -1){
      fill(173, 216, 230);
      rect(frozenCol - characterWidth, frozenRow - characterWidth, SPACING_WIDTH, SPACING_HEIGHT);  
   }
   drawCarlin();
   drawSpider();
   drawDoor();
   displayText("Level: ", currentLevel, 40, CANVAS_WIDTH / 2 - 60, 40, CANVAS_WIDTH / 2 + 60, 40);
   
   displayText("Spider Speed: ", spiderSpeed, 25, CANVAS_WIDTH / 2 - 250, CANVAS_HEIGHT - HALL_TOP, CANVAS_WIDTH / 2 - 80, CANVAS_HEIGHT - HALL_TOP);
   displayText("Remaining Magic: ", carlinManaCount, 25, CANVAS_WIDTH / 2 - 10, CANVAS_HEIGHT - HALL_TOP, CANVAS_WIDTH / 2 + 210, CANVAS_HEIGHT - HALL_TOP);
   
   moveSpider();

}

void drawCarlin(){
  fill(255, 255, 255); //white color
  circle(carlinX, carlinY, characterWidth);
  
  fill(0, 0, 0);
  stroke(0, 0, 0);
  circle(carlinX - 8, carlinY - 8, 5);
  circle(carlinX + 8, carlinY - 8, 5);
  
  fill(255, 255, 255);
  arc(carlinX - 10, carlinY + characterWidth/2 + 2, 20, 20, PI, 2*PI);
  arc(carlinX + 10, carlinY + characterWidth/2 + 2, 20, 20, PI, 2*PI);
}

void drawSpider(){
  fill(255, 0, 0); //red color
  circle(spiderX, spiderY, characterWidth);
  
  fill(0, 0, 0);
  
  line(spiderX - 5, spiderY - 5, spiderX - 20, spiderY - 20);
  line(spiderX - 5, spiderY - 5, spiderX - 20, spiderY + 20);
  line(spiderX - 5, spiderY - 5, spiderX - 20, spiderY - 5);
  
  line(spiderX + 5, spiderY + 5, spiderX + 20, spiderY - 20);
  line(spiderX + 5, spiderY + 5, spiderX + 20, spiderY + 20);
  line(spiderX - 5, spiderY - 5, spiderX + 20, spiderY - 5);
}

void drawDoor(){
  fill(255, 255, 0); //yellow color
  rect(doorX, 2 * HALL_TOP - DOOR_HEIGHT, DOOR_WIDTH, DOOR_HEIGHT);
}

void displayText(String text, int value, int textSize, int x1, int y1, int x2, int y2){
  fill(255, 255, 255);
  textSize(textSize);
  text(text, x1, y1);
  text(String.valueOf(value), x2, y2);
}

void moveSpider(){
  
  String[] directions = new String[]{"up", "down", "left", "right"};
  
  int randomIdx = (int)(Math.random() * 4);
  
  String direction = directions[randomIdx];
  
  if(direction.equals("left") || direction.equals("right")){
    int nextX = nextX(spiderX, spiderY, direction, spiderSpeed);
    
    if(spiderX == nextX){
       moveSpider();
       return;
    }
    else spiderX = nextX;
  }
  
  if(direction.equals("up") || direction.equals("down")){
    int nextY = nextY(spiderX, spiderY, direction, spiderSpeed);
    
    if(spiderY == nextY){
       moveSpider();
       return;
    }
    else spiderY = nextY;
  }
  
  if(spiderCaughtCarlin()){
     dead = true; 
  }
  
  if(spiderEntersTheFrozenCell()){
     spiderSpeed -= spiderSpeed / 4; 
  }
}


boolean checkObstacle(int positionX, int positionY){
   if(positionX < characterWidth  || positionX > CANVAS_WIDTH - characterWidth)return true;
   if(positionY < 2 * HALL_TOP || positionY > CANVAS_HEIGHT - 2 * HALL_TOP)return true;
   
   for(int i = 0; i < NUM_ROWS; i++){
      for(int j = 0; j < NUM_COLS; j++){
        
         int[] upperLeftObstacleCoordinates = new int[]{SPACING_WIDTH * (2 * j + 1), 2 * HALL_TOP + SPACING_HEIGHT * (2 * i + 1)};
         int[] upperRightObstacleCoordinates = new int[]{SPACING_WIDTH * (2 * j + 1) + SPACING_WIDTH, 2 * HALL_TOP + SPACING_HEIGHT * (2 * i + 1)};
         
         int[] lowerLeftObstacleCoordinates = new int[]{SPACING_WIDTH * (2 * j + 1), 2 * HALL_TOP + SPACING_HEIGHT * (2 * i + 1) + SPACING_HEIGHT};
         int[] lowerRightObstacleCoordinates = new int[]{SPACING_WIDTH * (2 * j + 1) + SPACING_WIDTH, 2 * HALL_TOP + SPACING_HEIGHT * (2 * i + 1) + SPACING_HEIGHT};
         
         
         if(positionX > upperLeftObstacleCoordinates[0] && positionX < upperRightObstacleCoordinates[0] && 
         positionY > upperLeftObstacleCoordinates[1] && positionY < lowerRightObstacleCoordinates[1])
           return true;
      }
   }
   
   return false;
}

int nextX(int currentX, int currentY, String direction, int speed){
  int nextX = currentX, nextY = currentY;
  if(direction.equals("left"))nextX = currentX - speed;
  else if(direction.equals("right"))nextX = currentX + speed;
  
  if(!checkObstacle(nextX, nextY))return nextX;
  return currentX;
}

int nextY(int currentX, int currentY, String direction, int speed){
  int nextX = currentX, nextY = currentY;
  if(direction.equals("up"))nextY = currentY - speed;
  else if(direction.equals("down"))nextY = currentY + speed;
  
  if(!checkObstacle(nextX, nextY))return nextY;
  return currentY;
}

void keyPressed(){
  if(key == CODED){
    if(keyCode == UP){
      if(carlinAtTheDoor()){
         levelUp();
         return;
      }
      carlinY = nextY(carlinX, carlinY, "up", SPACING_HEIGHT);
    }
    else if(keyCode == DOWN){
      carlinY = nextY(carlinX, carlinY, "down", SPACING_HEIGHT);
    }
    else if(keyCode == LEFT){
      carlinX = nextX(carlinX, carlinY, "left", SPACING_WIDTH);
    }
    else if(keyCode == RIGHT){
      carlinX = nextX(carlinX, carlinY, "right", SPACING_WIDTH);
    }
  }
  else if(key == ENTER){
     if(carlinManaCount > 0 && frozenRow == -1 && frozenCol == -1){
        carlinManaCount--;
        frozenRow = carlinY;
        frozenCol = carlinX;
     }
  }
  
  if(spiderCaughtCarlin()){
     dead = true; 
  }
}

boolean carlinAtTheDoor(){
  if(carlinX >= doorX && carlinX <= doorX + DOOR_WIDTH && carlinY == 2 * HALL_TOP + (SPACING_WIDTH / 2))return true;
  return false;
}

boolean spiderCaughtCarlin(){
   
  int distSq = (carlinX - spiderX) * (carlinX - spiderX) +
                     (carlinY - spiderY) * (carlinY - spiderY);
  int radSumSq = (characterWidth / 2) * (characterWidth / 2);
  
  if (distSq <= radSumSq)return true;
  return false;
}

boolean spiderEntersTheFrozenCell(){
   
  int[] bottomLeftCoordinatesOfFrozenCell = new int[]{frozenCol - characterWidth, frozenRow + characterWidth};
  int[] topRightCoordinatesOfFrozenCell = new int[]{frozenCol + characterWidth, frozenRow - characterWidth};
  
   if (spiderX >= bottomLeftCoordinatesOfFrozenCell[0] && spiderX <= topRightCoordinatesOfFrozenCell[0] &&
    spiderY <= bottomLeftCoordinatesOfFrozenCell[1] && spiderY >= topRightCoordinatesOfFrozenCell[1])
    return true;
 
   return false;
}

void levelUp(){
  currentLevel += 1;
  spiderSpeed += spiderSpeed / 10;
  
  if(spiderSpeed < 10)spiderSpeed = 10;
  
  reset();
}

void reset(){
  carlinX = (int)((1.5 + 2 * (int)(Math.random() * NUM_COLS)) * SPACING_WIDTH);
  carlinY = 2 * HALL_TOP + (2 * NUM_ROWS + 1) * SPACING_WIDTH - (SPACING_WIDTH / 2);


  spiderX = (int)((1.5 + 2 * (int)(Math.random() * NUM_COLS)) * SPACING_WIDTH);
  spiderY = 2 * HALL_TOP + (SPACING_WIDTH / 2);
  
  doorX = (float)(Math.random() * (CANVAS_WIDTH - DOOR_WIDTH + 1));
  
  frozenRow = -1;
  frozenCol = -1;
}
