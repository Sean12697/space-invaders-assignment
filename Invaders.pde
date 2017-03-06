//Global Customisable Declarations //<>//
final int alienCol = 10;
final int alienRow = 3;
final int loadingTime = 3000;

//Global Declarations
PVector fixedPos;
int screen = 0;
boolean gamePlaying = true;
boolean setup = true;
int menu = 1;
boolean moveRight = true;
int aliensLeft = 0;
int rowMin = 0;
int rowMax = 0;
PImage splash, background;

//Font
PFont openSans, openSansIt;

//Game
int level = 1;
int score = 0;
int lives = 3;

//Object Declarations
Defender player;
Bullet bullet;
Alien[][] alien = new Alien[alienCol][alienRow]; //Array

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
  if (keyCode == ENTER && screen == 0) {
    screen = menu;
  }
  if (key == ' ' && screen == 2) {
    screen = 0;
  }
  if (key == ' ' && bullet == null && screen == 1 && gamePlaying == true) {
    bullet = new Bullet(player.pos, level, true);
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
//-------------------------------MAIN_GAME--------------------------------
void mainGame() {
  image(background, 0, 0);
  //----------------------SETUP-----------------------
  if (setup == true) {

    fixedPos = new PVector(50, 60);
    moveRight = true;

    lives = 3;
    level = 1;
    rowMin = 1;
    rowMax = 10;

    player = new Defender();

    for (int i=0; i<alienCol; i++) {
      for (int j=0; j<alienRow; j++) {
        alien[i][j] = new Alien(i, j, fixedPos);
      }
    }

    setup = false;
  }

  //----------------------GAME-----------------------
  if (gamePlaying == true) {
    textSize(width/50);
    fill(255);
    text("Level: " + level + ",  Lives: " + lives + ",  Score: " + score, 10, 25);

    aliensLeft = 0;
    rowMin = 10;
    rowMax = 0;
    player.render();

    //Bullet
    if (bullet != null) {
      Collision shot = alienShot();
      if (bullet.pos.y <= 0) {
        bullet = null;
      } else if (shot.crash == true) {
        alien[shot.i][shot.j].health -= 40;
        bullet = null;
        if (alien[shot.i][shot.j].health <= 0) {
          alien[shot.i][shot.j].dying = true;
          score += 10 + (10*floor(level/5)); //Gives 10 score first 5 levels, then 10 more each 5 levels, level 10 = +20
        }
      } else {
        bullet.update();
      }
    }

    //--------Render_Aliens/Bullets--------
    for (int i=0; i<alienCol; i++) {
      for (int j=0; j<alienRow; j++) {

        if (alien[i][j] != null && !alien[i][j].dead) { //If Alien at index exists

          int r = round(random(100)); // 1:100 chance dodge at level 1, 1:1 at level 100
          if (bullet != null && level > r) {
            alien[i][j].avoidBullet();
          }

          alien[i][j].render(fixedPos);
          aliensLeft++; //States the array is not empty
          if (i + 1 < rowMin) { 
            rowMin = i + 1;
          } //Puts the futhest left index as min
          if (i + 1 > rowMax) { 
            rowMax = i + 1;
          } //Puts the futhest right index as max

          if (alien[i][j].missile != null) { //If alien has a shot missile
            alien[i][j].missile.update(); //Update bullet

            if (alien[i][j].missile.pos.y > height) { //Tests bullets position
              alien[i][j].missile = null;
            } else if (alien[i][j].missile.pos.dist(player.pos) < 20) { //If player shot
              alien[i][j].missile = null;
              player.lostLife();
              lives--;
            } 

            if (bullet != null && alien[i][j].missile != null) {
              if (alien[i][j].missile.pos.dist(bullet.pos) < 12) { //If player bullet and alien bullet hit each other
                alien[i][j].missile = null;
                bullet = null;
              }
            }
          } else {
            alien[i][j].randomShoot(level); //Generate bullet
          }
        }
        if (alien[i][j] != null) {
          if (alien[i][j].dead) {
            alien[i][j] = null;
          }
        }
      }
    }

    //Moves Alien Grid
    float move = ((level-1)*0.1)+1; 
    //Level 1 = 1 (0 * 0.1 = 0 + 1 = 1)
    //Level 2 = 1.5 (1 * 0.1 = 0.1 + 1 = 1.1)
    if ((fixedPos.x + (rowMin*60)) - 100 < 0) {
      moveRight = true;
      fixedPos.add(0, 10);
    }
    if (fixedPos.x + (rowMax*60) > width) {
      moveRight = false;
      fixedPos.add(0, 10);
    }
    if (moveRight == true) {
      fixedPos.add(move, 0);
    }
    if (moveRight == false) {
      fixedPos.sub(move, 0);
    }

    //Increase Level
    if (aliensLeft <= 0) {
      level++;

      fixedPos = new PVector(50, 60);

      for (int i=0; i<alienCol; i++) {
        for (int j=0; j<alienRow; j++) {
          alien[i][j] = new Alien(i, j, fixedPos);
        }
      }
    }

    //---------END_GAME----------
    if (lives <= 0 || fixedPos.y + 180 > height - 70) {
      gamePlaying = false;
      setup = true;
    }
  }

  //------------------GAME_ENDED-----------------------
  if (gamePlaying == false) {
    fill(255);
    textSize(width/10);
    text("Game ended!", width/2-(textWidth("Game ended!")/2), height/6);
  }
}
//-----------------------------ALIEN_SHOT_FUN()---------------------------
Collision alienShot() {
  Collision shot; //for return
  for (int i=0; i<alienCol; i++) {
    for (int j=0; j<alienRow; j++) {
      if (alien[i][j] != null && !alien[i][j].dying) {
        //Goes through each alien that is not null
        //If distance between the bullet and an alien is less then 20 pixels
        if (bullet.pos.dist(alien[i][j].pos) < 20) {
          //Say there is a collision and return the alien index
          return shot = new Collision(true, i, j);
        }
      }
    }
  }
  return shot = new Collision(false, 0, 0);
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
  text(topScoresText, width/2-(textWidth(topScoresText)/2), height/6);

  textSize(width/30);
  fill(255);
  //Scores

  text(quitScores, width/2-(textWidth(quitScores)/2), (height/15)*14);
}