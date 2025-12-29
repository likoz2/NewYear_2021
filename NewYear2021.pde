ArrayList<Rocket> rockets = new ArrayList<Rocket>();
ArrayList<Rocket> remRockets = new ArrayList<Rocket>();
ArrayList<Rocket> addRockets = new ArrayList<Rocket>();
int maxRockets = 16;
PImage img;
ArrayList<Circle> circles = new ArrayList<Circle>();
int[] pix;
boolean newYear = false;
int timeLeft = -1;
Goal goal;

PImage overlay;

PFont fontBold;

void setup() {
  fontBold = createFont("Arial Bold", 700);
  fullScreen();
  background(0);
  save("overlay.png");
  overlay = loadImage("overlay.png");
  setupYear();
  textSize(420);
  textAlign(CENTER, CENTER);
  goal = new Goal();
  frameRate(30);
}

void setupYear() {
  createYearPng("2023");
  img = loadImage("year.png");
  image(img, 0, 0);
  loadPixels();
  pix = new int[pixels.length];
  for (int i = 0; i < pixels.length; i++) {
    pix[i] = pixels[i];
  }
  background(0);
}

void createYearPng(String year) {
  background(0);
  textSize(700);
  textAlign(CENTER);
  textFont(fontBold);
  fill(255);
  text(year, width/2, height/2+150);
  save("year.png");
}

void draw() {
  background(0);
  if (frameCount % 1000 == 0) {
    image(overlay, 0, 0);
    for (Circle c : circles) {
      c.draw();
    }
    save("overlay.png");
    overlay = loadImage("overlay.png");
    circles.clear();
  }
  if (newYear) {
    tryCreateNewRocket();
    image(overlay, 0, 0);
    for (Circle c : circles) {
      c.draw();
    }
    for (Rocket r : addRockets) {
      rockets.add(r);
    }
    addRockets.clear();
    for (Rocket r : rockets) {
      r.draw();
    }
    for (Rocket r : remRockets) {
      rockets.remove(r);
    }
  } else if (!newYear) {
    int hoursLeft = goal.hour - hour();
    int minsLeft = goal.min - minute();
    int secsLeft = goal.sec - second();
    hoursLeft = (hoursLeft+24)%24 - (minsLeft < 0 ? 1 : 0);
    minsLeft = (minsLeft+60)%60 - (secsLeft < 0 ? 1 : 0);
    secsLeft = (secsLeft+60)%60;
    timeLeft = ((hoursLeft*60) + minsLeft)*60 + secsLeft;
    timeLeft = -1;
    //println(timeLeft);
    //text((goal.hour) + ":" + ((goal.min+60)%60) + ":" + ((goal.sec+60)%60), width/2, height/2 - 200);
    //text(nf(hour(), 2) + ":" + nf(minute(), 2) + ":" + nf(second(), 2), width/2, height/2);
    text(nf(hoursLeft, 2) + ":" + nf(minsLeft, 2) + ":" + nf(secsLeft, 2), width/2, height/2);
    if (timeLeft <= 0 || timeLeft > 20*60*60) {
      newYear = true;
    }
  }
}

void tryCreateNewRocket() {
  if (random(0, 1) < 0.04 && rockets.size() < maxRockets) {
    createNewRocket();
    if (random(0, 1) < 0.15) {
      createNewRocket((int)random(35, 50));
    }
  }
}

void createNewRocket() {
  Rocket r = new Rocket(new PVector(random(100, width-100), height-10), 30);
  rockets.add(r);
}

void createNewRocket(int delay) {
  Rocket r = new Rocket(new PVector(random(100, width-100), height-10), delay);
  rockets.add(r);
}

float aboveZero(float f) {
  float ret = 0;
  if (f > 0) {
    ret = f;
  }
  return ret;
}
