//Global Customisable Declarations //<>//
final int alienCol = 10, alienRow = 3, loadingTime = 3000, eachNthTrackingBullet = 1; //3000 = 3 seconds

//Global Declarations
int screen = 0, menu = 1;
boolean gamePlaying = true, setup = true;
PImage splash, background;
StringBuilder name = new StringBuilder("");

//Font
PFont openSans, openSansIt;

//Game
int level = 1;

//Object Declarations
Defender player;
Bullet bullet;
AlienGrid aliens;

void setup() {
  size(1000, 800);
  splash = loadImage("img/splash.jpg");
  background = loadImage("img/background.jpg");
  openSans = loadFont("OpenSans-48.vlw");
  openSansIt = loadFont("OpenSansLight-Italic-48.vlw");
}
//---------------------------------DRAW----------------------------------
void draw() {
  if (millis() < loadingTime) {
    splash();
  } else {
    background(0);

    switch (screen) {
    case 0:
      menuScreen();
      break;

    case 1:
      mainGame();
      break;

    case 2:
      scores();
      break;

    case 3:
      exit();
      break;
    }
  }
}
//------------------------------KEY_PRESSED-------------------------------
void keyPressed() {
  if (keyCode == UP && screen == 0 && menu > 1) {
    menu--;
  }
  if (keyCode == DOWN && screen == 0 && menu < 3) {
    menu++;
  }
  if (keyCode == LEFT && screen == 1 && gamePlaying == true) {
    player.moveLeft = true;
  }
  if (keyCode == RIGHT && screen == 1 && gamePlaying == true) {
    player.moveRight = true;
  }
  if ((keyCode == ENTER || keyCode == RETURN) && screen == 0) { //Return for Mac' compatability
    screen = menu;
  }
  if (key == ' ' && screen == 2) {
    screen = 0;
  }
  if (key == ' ' && bullet == null && screen == 1 && gamePlaying == true) {
    player.bulletsShot++;
    bullet = new Bullet(player.pos, level, true, (player.bulletsShot % eachNthTrackingBullet == 0)); //10 for ever 10 bullets make a tracking bullet
  }
  if ((key != keyCode || keyCode == SHIFT) && screen == 1 && gamePlaying == false && name.length() < 20) { //if on game and has ended
    name.append(key);
  }
  if (keyCode == BACKSPACE && name.length() > 0 && screen == 1 && gamePlaying == false) {
    name.setLength(name.length()-1);
  }
  if (player != null) { //avoids a null pointer exception I had and should only run after game when there is a player
    if (key == ' ' && !(player.score > getLowestScore() || scoreLength() < 10) && screen == 1 && gamePlaying == false) {
      gamePlaying = true;
      screen = 0;
    }
    if (key == ' ' && (player.score > getLowestScore() || scoreLength() < 10) && name.length() != 0 && screen == 1 && gamePlaying == false) {
      addToScores();
      gamePlaying = true;
      screen = 0;
    }
  }
}
//----------------------------KEY_RELEASED-----------------------------
void keyReleased() {
  if (keyCode == LEFT && screen == 1 && gamePlaying == true) {
    player.moveLeft = false;
  }
  if (keyCode == RIGHT && screen == 1 && gamePlaying == true) {
    player.moveRight = false;
  }
}
//------------------------------MAIN_MENU------------------------------
void menuScreen() {
  fill(255);
  textSize(width/10);
  text(title, width/2-(textWidth(title)/2), height/6);

  textSize(width/30);
  fill(255);
  if (menu == 1) { 
    fill(255, 255, 0);
  }
  text(playGameText, width/2-(textWidth(playGameText)/2), (height/15)*11);
  fill(255);
  if (menu == 2) { 
    fill(255, 255, 0);
  }
  text(scoresText, width/2-(textWidth(scoresText)/2), (height/15)*12);
  fill(255);
  if (menu == 3) { 
    fill(255, 255, 0);
  }
  text(exitText, width/2-(textWidth(exitText)/2), (height/15)*13);
}
//-----------------------------SETUP_VARIBLES-----------------------------
void gameVariblesReset() {
  level = 1; //Debug levels
  player.varibleReset();
  aliens.varibleReset();
  name = new StringBuilder("");
}
//-------------------------------MAIN_GAME--------------------------------
void mainGame() {
  image(background, 0, 0);
  //----------------------SETUP-----------------------
  if (setup == true && gamePlaying == true) {

    aliens = new AlienGrid(alienCol, alienRow);
    player = new Defender();
    gameVariblesReset();
    aliens.populateArray();

    setup = false;
  }

  //----------------------GAME-----------------------
  if (gamePlaying == true) {
    textSize(width/50);
    fill(255);
    text("Level: " + level + ",  Lives: " + player.lives + ",  Score: " + player.score, 10, 25);

    aliens.ingameVaribleReset();
    player.render();

    //Bullet
    if (bullet != null) {
      Collision shot = aliens.alienShot(bullet);
      if (bullet.pos.y <= 0) {
        bullet = null;
      } else if (shot.crash == true) {
        aliens.alien[shot.i][shot.j].health -= player.damage;
        bullet = null;
        if (aliens.alien[shot.i][shot.j].health <= 0) {
          aliens.alien[shot.i][shot.j].dying = true;
          player.score += 10 + (10*floor(level/5)); //Gives 10 score first 5 levels, then 10 more each 5 levels, level 10 = +20
        }
      } else {
        bullet.update();
      }
    }

    aliens.update(bullet, player);

    //Increase Level
    if (aliens.aliensLeft <= 0) {
      level++;

      aliens.resetAliens();
    }

    //---------END_GAME----------
    if (player.lives <= 0 || aliens.fixedPos.y + 180 > height - 70) {
      gamePlaying = false;
      setup = true;
      scoreText = "You won with a score of " + player.score;
    }
  }

  //------------------GAME_ENDED-----------------------
  if (gamePlaying == false) {
    endGame();
  }
}

//-------------------------------END_OF_GAME------------------------------
void endGame() {
  fill(255);
  textSize(width/10);
  text(gameEnd, width/2-(textWidth(gameEnd)/2), height/6);
  textSize(width/30);
  text(scoreText, width/2-(textWidth(scoreText)/2), (height/12)*3);
  if (player.score > getLowestScore() || scoreLength() < 10) { //if the players score is greater than the last score in the array
    getUserInput();
  }
  text(enterToCont, width/2-(textWidth(enterToCont)/2), (height/6)*5);
}
//-----------------------------LENGTH_OF_SCORES---------------------------
int scoreLength() {
  JSONArray scores = loadJSONArray("scores.json");
  return scores.size();
}
//------------------------------GET_USER_INPUT----------------------------
void getUserInput() {
  text(enterName, width/2-(textWidth(enterName)/2), (height/12)*4);
  String n = name.toString();
  text(n, width/2-(textWidth(n)/2), height/2);
}
//---------------------------ADD_SCORE_TO_SCORES--------------------------
void addToScores() {
  JSONArray scores = loadJSONArray("scores.json");
  appendScore(scores);
  limitScores(scores);
  saveJSONArray(scores, "data/scores.json");
}
//---------------------GET_LAST_SCORE_IN_SCORES_RECORDS-------------------
int getLowestScore() {
  JSONArray scores = loadJSONArray("scores.json");
  sortScores(scores);
  return scores.getJSONObject(scores.size()-1).getInt("score");
}
//-------------------------------APPEND_SCORE-----------------------------
void appendScore(JSONArray scores) {
  JSONObject objScore = new JSONObject();
  objScore.setString("name", name.toString());
  objScore.setInt("score", player.score);
  scores.append(objScore);
}
//-------------------------------SORT_SCORES------------------------------
void sortScores(JSONArray scores) {
  boolean Swapped;
  do
  {
    Swapped = false;
    int n = scores.size();
    for (int i=0; i < n-1; i++)
    {
      //if (Words.get(i).compareToIgnoreCase(Words.get(i+1)) > 0)
      if (scores.getJSONObject(i).getInt("score") < scores.getJSONObject(i+1).getInt("score"))
      {
        //String Temp = Words.get(i);
        //Words.set(i, Words.get(i+1));
        //Words.set(i+1, Temp);
        JSONObject Temp = new JSONObject(); // = scores.getJSONObject(i);
        Temp.setString("name", scores.getJSONObject(i).getString("name"));
        Temp.setInt("score", scores.getJSONObject(i).getInt("score"));
        scores.getJSONObject(i).setString("name", scores.getJSONObject(i+1).getString("name"));
        scores.getJSONObject(i).setInt("score", scores.getJSONObject(i+1).getInt("score"));
        scores.getJSONObject(i+1).setString("name", Temp.getString("name"));
        scores.getJSONObject(i+1).setInt("score", Temp.getInt("score"));
        Swapped = true;
      }
    }
    n -= 1;
  } 
  while (Swapped);
}
//---------------------------LIMIT_ARRAY_OF_SCORES------------------------
void limitScores(JSONArray scores) {
  sortScores(scores);
  int limit = 10;
  while (scores.size() > limit) {
    scores.remove(scores.size()-1);
  }
}
//------------------------------SPLASH_SCREEN-----------------------------
void splash() {
  image(splash, 0, 0);
  textFont(openSansIt, 20);
  double loadTime = millis()/(loadingTime/100);
  String loadText = "Loading Game... " + loadTime + "%";
  text(loadText, width/2-(textWidth(loadText)/2), height/2 + 100);
  textFont(openSans, 20);
}
//---------------------------------SCORE----------------------------------
void scores() {
  fill(255);
  textSize(width/10);
  text(topScoresText, width/2-(textWidth(topScoresText)/2), height/8);

  textSize(width/30);
  fill(255);

  JSONArray scores = loadJSONArray("scores.json");
  fill(0, 255, 0);
  //text("#\t\tPlayer\t\t\tScore", 50, (height/15)*3); //Tabs not working
  text("#", width/20, (height/15)*3);
  text("Name", width/10, (height/15)*3);
  text("Level", width-(width/3), (height/15)*3);
  text("Scores", width-(width/5), (height/15)*3);
  fill(255);
  for (int i = 0; i < scores.size(); i++) {
    JSONObject currentScore = scores.getJSONObject(i);
    String playersName = currentScore.getString("name");
    int playersLevel = currentScore.getInt("level");
    int playersScore = currentScore.getInt("score");
    //text((i + 1) + "\t\t" + playersName + "\t\t\t" + playersScore, 50, (height/15)*(4 + i));
    text((i + 1), width/20, (height/15)*(4 + i));
    text(playersName, width/10, (height/15)*(4 + i));
    text(playersLevel, width-(width/3), (height/15)*(4 + i));
    text(playersScore, width-(width/5), (height/15)*(4 + i));
  }
  text(quitScores, width/2-(textWidth(quitScores)/2), (height/15)*14);
}