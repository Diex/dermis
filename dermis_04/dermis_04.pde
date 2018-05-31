import processing.video.*;
import de.looksgood.ani.*;

int cols = 9;
int rows = 5;
Movie transition;
Locations locs;
ArrayList<Cell> cells = new ArrayList<Cell>();

int cellsToShow;
boolean showVideo = false;
Ani nextImage;
float nextImg = 0;
float nextTimeout = 6;


float videoTimeOut = 20;
float videoAlpha = 1.0;
Ani videoAlphaFade;
boolean videoOut=false;


void setup() {
  size(1920, 1080);
  transition = new Movie(this, "movie2.mp4");
  locs = new Locations(width, height, cols, rows);  
  Ani.init(this);
  fileManager();
  cellsToShow = 45;
  next();
  videoAlphaFade = new Ani(this, 5.0, 0, "videoAlpha", 0, Ani.EXPO_IN, "onEnd:videoOut");
  noCursor();
}

void videoOut() {
  showVideo = false;
  inFadeOut = false;
  videoOut = false;
  next(); // reinicio la levantada de imagenes
  println("video fadeOut ended...");
}

void draw() {
  background(0);

  pushStyle();
  if (showVideo) {
    tint(255, videoAlpha * 255);
    image(transition, 0, 0, width, height);    
    if (transition.time() >= videoTimeOut) {
      if (!videoOut) {
        videoAlphaFade.start();
        videoOut = true;
        println("videoFadeOut started...");
      }
    }
  }
  popStyle();

  for (Cell c : cells) {
    c.render();
  }

  if (allShown()) {
    while (cells.size() > 0) {
      Cell c = cells.get(0);
      c = null;
      cells.remove(0);
    }
    println("all cleared");
  }
}

void keyPressed() {
  if (key == ' ') next();
}


void hideAll() {
  println("hideAll()");
  String name = Long.toHexString(Double.doubleToLongBits(Math.random()));
  for (Cell c : cells) c.hide();
  if (!allBackup()) {
    saveFrame("data/"+name+".jpg");  
    saveMailsList(cells, name);
    println("saveData: " + "data/"+name+".jpg");
  }
}

boolean allBackup() {
  for (Cell c : cells) {
    if (c.sm.isBackup == false) return false;
  }
  if (cells.size() == 0) return false;
  return true;
}

boolean allShown() {
  for (Cell c : cells) {
    if (c.shown == false) return false;
  }
  if (cells.size() == 0) return false;
  return true;
}

void showVideo() {
  showVideo = true;
  transition.jump(0);
  transition.play();
  videoAlpha = 1.0;
}

boolean inFadeOut = false;
void next() {  
  if (inFadeOut) return;
  nextImage =  new Ani(this, nextTimeout, 0, "nextImg", 0, Ani.LINEAR, "onEnd:next");
  if (cellsToShow == cells.size()) {    
    hideAll();
    showVideo();
    inFadeOut = true;
    return;
  }

  Cell c = new Cell(getOneSkinMark(), locs.next(), locs.dim());
  c.show();
  cells.add(c);
}

void movieEvent(Movie m) {
  m.read();
}


SkinMark getOneSkinMark() {
  SkinMark sm = fromInbox(); 
  if ( sm == null) sm = fromBackup();
  return sm;
}